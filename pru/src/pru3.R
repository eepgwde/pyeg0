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

## This script puts the GDP figure in, so must be run.
if (exists("x.wdi")) {
    source("pru3a.R")
}

## Currently only corroborating the last 2016 numbers from 2015

th$test <- x0[nrow(x0),]
th$train <- x0[-nrow(x0),]
x0 <- NULL
rm("x0")

## test: we make our best guess of th$test expenditures
## the max of the last few entries of the training set.

th$test0 <- th$test                     # make a backup that is true

## So take the min from the last 5 years
t1 <- sapply(th$train[ (nrow(th$train)-4):nrow(th$train), th$classes], min)
## renormalize and make it the test sample
th$test[1, th$classes] <- t1/sum(t1)

t1 <- NULL
rm("t1")

source("pru3d.R")

