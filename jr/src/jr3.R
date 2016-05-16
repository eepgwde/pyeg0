## weaves
##
## Machine learning preparation.
## File with q/kdb+ generated technicals.

library(MASS)
library(caret)
library(mlbench)
library(pROC)
library(pls)

library(ggplot2)

library(doMC)
registerDoMC(cores = 4)

options(useFancyQuotes = FALSE) 

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

## Clear all away: very important if you re-use names in
## functions.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

source("plot0.R")
source("plot1.R")

load("folios-in.dat", envir=.GlobalEnv)

folios.in0 <- head(folios.in)

### Prescience
## Unlike jr2.R, we remove prescient features for the machine
## learner.

## We need to set a sliding window, we must use a least 20 days, but
## check none of the trades were held for longer than that.

ml0.window0 <- 20
if (max(folios.in$h05, na.rm=TRUE) > ml0.window0) {
    ml0.window <- max(folios.in$h05, na.rm=TRUE)
}

## Target feature is fp05
ml0.prescient <- c("fcst", "wapnl05", "h05", "fv05", "in0", "p00")
## Check against the price signal
ml0.prescient <- c("fcst", "wapnl05", "h05", "fv05", "in0")

folios.train0 <- folios.in[,setdiff(colnames(folios.in), ml0.prescient)]

### Following jr2.R, unstack 

train.ustk1 <- ustk.folio1(folios.train0)

## Shorter data set.
train.ustk2 <- tail(train.ustk1, n = 60)



