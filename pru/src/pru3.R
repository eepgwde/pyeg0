## weaves
##
## Machine learning preparation.
## Uses a binary data file of q/kdb+ ticks, generated technicals and
## trading signals.
##
## The input data was lagged by q/kdb+, so no need to lag it here.

## Clear all away: very important if you re-use names in
## functions.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

library(MASS)
library(caret)
library(fTrading)                       # for EWMA
library(zoo)

library(doMC)
registerDoMC(cores = 4)

options(useFancyQuotes = FALSE) 

source("pruA0.R")

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

load("folios-in.dat", envir=.GlobalEnv) # the expenditures
load("wdi.Rdata", envir=.GlobalEnv)     # the WDI data

### GDP predictions from industry analysts
## GDP annual growth rate for next two years (2016 to 2017), an ARIMA from tradingeconomics.com
gdp.predictions <- data.frame(gdp=c(0.052, 0.053), year=c(2016, 2017))

## Predict a proportion of the total for each category.
## Stash intermediate results in th.

th <- list()

th$classes <- levels(folios.in$Categories)

## @note
## Weirdly, we work on proportions and not exact values.
## The proportions may not be exact, but will scale them to be so.

x0 <- folios.in[ folios.in$type0 == "h", ]
x0 <- unstack(x0, x2tp ~ Categories)

## Extend x0 with WDI data and demographics

x.wdi <- TRUE
x.demog <- FALSE                        # and do not zero fill
x.price <- FALSE                        # and do not zero fill
x.fx <- FALSE                           # and do not zero fill

## This is how to switch them off
## rm(x.wdi)
## rm(x.demog)
## rm(x.price)
rm(x.fx)

if (exists("x.wdi")) {

    ## I'll just use the deltas and fill-back.

    ## @note
    ## The demographic data does help, halves my var1 estimate below.
    ## Must fill forward and back.
    if (exists("x.demog")) {

        ## Some demographic data, added as deltas, this is relatively
        ## stable and we can fill forward
        ## @note
        ## These are not so important.
        m0 <- c("SP.ADO.TFRT","SP.DYN.TFRT.IN")
        x1 <- wdi.filled(wdi0=wdi$demog$values, metrics0=m0, zero0=x.demog)

        stopifnot(nrow(x0) == nrow(x1))
        x1$year <- NULL                     # I kept the year in for debugging.

        x0 <- cbind(x0, x1)                 # add the columns

        ## Some more about male/female in population
        ## These are important.
        ## The data isn't very complete.
        m0 <- c("SP.POP.TOTL", "SP.POP.TOTL.FE.ZS", "SL.EMP.TOTL.SP.FE.ZS", "SL.EMP.TOTL.SP.MA.ZS", "SL.EMP.TOTL.SP.ZS")

        ## @note
        ## These might slow it down.
        if (TRUE) {
            m1 <- c("SP.RUR.TOTL", "SP.URB.TOTL", "SL.TLF.ACTI.1524.ZS", "SL.TLF.ACTI.1524.FE.ZS", "SL.TLF.ACTI.1524.MA.ZS")
            m0 <- c(m0, m1)
        }

        x1 <- wdi.filled(wdi0=wdi$popn$values, metrics0=m0, zero0=x.demog)

        stopifnot(nrow(x0) == nrow(x1))
        x1$year <- NULL                     

        x0 <- cbind(x0, x1)
    }

    ## @note
    ## The pricing data makes no change
    if (exists("x.price")) {

        ## CPI and Wholesale, wholesale is a very short set, so I've set it equal to CPI.
        m0 <- c("CPTOTSAXN", "FP.WPI.TOTL")
        x1 <- wdi.filled(wdi0=wdi$price$values, metrics0=m0, zero0=x.price)
        x1[((nrow(x1)-2):nrow(x1)),2] <- x1[((nrow(x1)-2):nrow(x1)),1] # short set kludge

        stopifnot(nrow(x0) == nrow(x1))
        x1$year <- NULL                     # I kept the year in for debugging.

        x0 <- cbind(x0, x1)                 # add the columns
    }

    if (exists("x.fx")) {

        ## CPI and Wholesale, wholesale is a very short set, so I've set it equal to CPI.
        m0 <- c("DPANUSSPB", "PA.NUS.PPPC.RF")
        x1 <- wdi.filled(wdi0=wdi$fx$values, metrics0=m0, zero0=x.price)

        stopifnot(nrow(x0) == nrow(x1))
        x1$year <- NULL                     # I kept the year in for debugging.

        x0 <- cbind(x0, x1)                 # add the columns
    }

    ## The GDP data is nearly complete, we add an industry estimate
    ## So different from the stable demographics.
    ## @todo
    ## I've had to add a second GDP metric to make my code work.
    m0 <- c("NY.GDP.PCAP.PP.CD","SL.GDP.PCAP.EM.KD")
    x2 <- wdi.filled(wdi0=wdi$gdp$values, metrics0=m0)

    ## Use just one prediction from above 
    gdp <- gdp.predictions$gdp[1]

    ## Copy a blank row, make a scaling factor and apply it
    x3 <- x2[nrow(x2)-1,]
    f0 <- gdp/x3[1,1]                   # just a scaling factor
    x3 <- f0 * x3

    x2[nrow(x2),] <- x3
    x2 <- x2[, c(1,3)]                  # get rid of the superfluous column

    stopifnot(nrow(x0) == nrow(x2))
    x2$year <- NULL

    x0 <- cbind(x0, x2)
}

## The last row is their prediction, we'll be using this to boost-by-hand
## We store the last row in test and the rest in train.
## Find the least volatile and begin with that.

th$test <- x0[nrow(x0),]
th$train <- x0[-nrow(x0),]

## We only predict the expenditure classes
th$sd <- stack(sapply(th$train[, th$classes],sd))
th$sd <- th$sd[order(th$sd$values),]

th$order0 <- as.character(th$sd$ind)

## Train with the whole set for testing.
##  th$train <- x0

paste(c("train-order: ", th$order0), collapse = "-> ")

df1 <- th$train

## Machine learning parameters
ml0 <- list()
ml0$window0 <- 6
ml0$factor0 <- th$order0[1]

fitControl <- trainControl(## timeslicing
    initialWindow = ml0$window0,
    horizon = 1,
    fixedWindow = TRUE,
    method = "timeslice",
    savePredictions = TRUE)

## @note
## Weightings: try EWMA
x.samples <- nrow(df1)

x.ewma <- EWMA(c(1, rep(0,x.samples-1)), lambda = 0.050, startup = 1)
x.weights <- rev(x.ewma) / sum(x.ewma)

## For the results accuracy, make the same weighting a bit longer.
x.ewma <- EWMA(c(1, rep(0,x.samples)), lambda = 0.050, startup = 1)
x.rweights <- rev(x.ewma) / sum(x.ewma)
    
## Or just
## x.weights <- rep(1, x.samples)

ml0$fmla <- as.formula(paste(ml0$factor0, "~ ."))

set.seed(seed.mine)
modelFit1 <- train(ml0$fmla, data = df1,
                   method = "pls",
                   preProc = c("center", "scale"),
                   weights = x.weights,
                   trControl = fitControl)
modelFit1

ml0$model0 <- modelFit1
ml0$preds <- c(predict(modelFit1, df1), predict(modelFit1, th$test))

ml0$modelImp <- varImp(modelFit1, scale = FALSE)

jpeg(width=1024, height=768, filename = "totals-%03d.jpeg")

plot(modelFit1)

plot(ml0$modelImp, top = min(20, length(colnames(df1))))

plot.ts(ts(data.frame(pred=predict(modelFit1, df1),obs=th$train[[ ml0$factor0 ]])), 
        plot.type="multiple")

dev.off()

## Make up my own exponential accuracy metric and we hope to improve this by adding more
## WDI data.

r0 <- data.frame(pred=ml0$preds, obs = c(th$train[[ ml0$factor0 ]], th$test[[ ml0$factor0 ]]))

ml0$var1 <- sum((r0$pred - r0$obs)^2 * x.rweights)
ml0$var1


