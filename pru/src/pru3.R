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

### GDP predictions from industry analysts
## GDP annual growth rate for next two years (2016 to 2017), an ARIMA from tradingeconomics.com
gdp.predictions <- data.frame(gdp=c(0.052, 0.053), year=c(2016, 2017))


source("pruA0.R")

load("wdi.Rdata", envir=.GlobalEnv)     # the WDI data
load("folios-in.dat", envir=.GlobalEnv) # the expenditures totals
load("folios-ul2.dat", envir=.GlobalEnv) # the expenditures classed see pru2.R

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

## Set-up the learner's results holder: ml0
## Predict a proportion of the total for each category.
## Stash intermediate results in th.
## @note
## Run from here

if (exists("ml0")) {
    rm("ml0")
}
th <- list()

## @note
## Weirdly, we work on proportions and not exact values.
## The proportions may not be exact, but will scale them to be so.
## There are 3 sample sets, but either h or t is sufficient.
## x0 <- folios.in[ folios.in$type0 == "t", ]
## x0 <- folios.in[ , ]
x0 <- folios.in[ folios.in$type0 == "h", ]

## you have to re-classify for unstack to work correctly.
x0$Categories <- as.factor(as.character(x0$Categories)) 

th$classes <- levels(x0$Categories)

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
    ## @todo
    ## This could be function call now, but I won't be re-using it elsewhere.
    source("pru3a.R")
}

## The last row is their prediction, we'll be using this to boost-by-hand
## We store the last row in test and the rest in train.
## Find the least volatile and begin with that.

th$test <- x0[nrow(x0),]
th$train <- x0[-nrow(x0),]

## We only predict the expenditure classes
th$sd <- stack(sapply(th$train[, th$classes],sd))
th$sd <- th$sd[order(-th$sd$values),]

th$order0 <- as.character(th$sd$ind)

## Train with the whole set for testing.
##  th$train <- x0

paste(c("train-order: ", th$order0), collapse = "-> ")

df1 <- th$train

## Machine learning parameters
## Some tuning needed to minimize
ml0 <- list()
ml0$window0 <- 6
ml0$factor0 <- th$order0[1]

fitControl <- trainControl(             # timeslicing
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


