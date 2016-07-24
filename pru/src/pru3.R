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
library(pls)

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

## I lost track of the date range somewhere along the line.
## This is train 2015, test 2016
th$years <- 2005:2016

## @note
## We work on proportions and not exact values.
## The proportions may not be exact, but will scale them to be so - sum to one
## There are 3 sample sets, but either h or t is sufficient.
## x0 <- folios.in[ folios.in$type0 == "t", ]
## x0 <- folios.in[ , ]

th$sum1 <- 1

x0 <- folios.in[ folios.in$type0 == "h", ]

## you have to re-classify for unstack to work correctly.
x0$Categories <- as.factor(as.character(x0$Categories)) 

th$classes <- levels(x0$Categories)

x0 <- unstack(x0, x2tp ~ Categories)
rownames(x0) <- th$years

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

## This script puts the GDP estimates in, so it isn't optional.
## It's a "what-if" scenario.
if (exists("x.wdi")) {
    source("pru3a.R")
}

## Currently only corroborating the last 2016 numbers from 2015.  So
## we train up to 2015, that is 2014 is used to predict 2015 and we
## learn that.
##
## And the test set is 2015 to predict 2016; we provide an estimate of
## the GDP for 2016, with other demographic indicators.

## The data we received in folios.in above also has the "true" forecasts in.
## We remove their forecasts for 2016 for checking later.
th$test0 <- x0[nrow(x0),]
x0 <- x0[-nrow(x0),]

## And this then is the training/test arrangement.
## We don't remove the test set. It is the response to 2014.
th$test <- x0[nrow(x0),]
th$train <- x0                          # *don't* remove the test set.
x0 <- NULL
rm("x0")

## @note
##
## The R package caret is a facade package. It is better organised but
## is broken for anything other than binary predictors.
##
## At its website, it has some good diagrams explaining
## time-series. In that respect, we are using a full window with a
## horizon of one.

## This runs the training and prediction and returns th$preds
source("pru3d.R")

## th$preds is over all comparisons
## These have to be renormalized - very small errors introduced
## Find the one with the least error relative to their predictions

renorm.f0 <- function(x) { return(x/sum(x)) }
th$preds <- as.data.frame(t(apply(th$preds, 1, renorm.f0)))

err.f0 <- function(x) { return(err.rmser(x, th$test0[, th$classes])) }
e0 <- apply(th$preds, 1, err.f0)

e1 <- as.integer(which(min(e0) == e0))

fmt0 <- "Min Root Mean Square Ratio: %5.2f%% ; ncomps: %d"
print(sprintf(fmt0, 100 * as.numeric(e0[e1]), e1))

