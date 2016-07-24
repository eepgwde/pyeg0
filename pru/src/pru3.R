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

### Run: Complete: from here

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

## test: We can make it harder rather than use their forecasts, I can
## make th$test expenditures the max of the last few
## entries of the training set.

th$test0 <- th$test                     # make a backup

## So take the min from the last 5 years
## [Easy to understand, it should shift down if the GDP has gone up.]
t1 <- sapply(th$train[ (nrow(th$train)-4):nrow(th$train), th$classes], min)
## renormalize and make it the test sample
th$test[1, th$classes] <- t1/sum(t1)

stopifnot(sum(th$test[1, th$classes]) == 1)

## We only predict the expenditure classes
th$sd <- stack(sapply(th$train[, th$classes],sd))
th$sd <- th$sd[order(-th$sd$values),]   # most volatile is first
th$sd <- th$sd[order(th$sd$values),]    # least

th$order0 <- as.character(th$sd$ind)

## Train with the whole set for testing.
##  th$train <- x0

paste(c("train-order: ", th$order0), collapse = "-> ")

df1 <- th$train

### Run: Iterate: from here
x.steps <- 4

for (x.step in 1:x.steps) {
    print(x.step)
    for (x.folio in th$order0) {
        print(x.folio)
        source("pru3b.R")
    }

    e0 <- sum(as.numeric(th$test0[, th$classes] - th$test[, th$classes ])^2)
    print(paste("error: ", as.character(e0)))
}

