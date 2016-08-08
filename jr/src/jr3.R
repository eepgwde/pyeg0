## weaves
##
## Machine learning preparation.
## Uses a binary data file of q/kdb+ ticks, generated technicals and
## trading signals.
##
## The input data was lagged by q/kdb+, so no need to lag it here.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

library(MASS)
library(caret)
library(mlbench)
library(pROC)
library(pls)
library(zoo)
library(fTrading)                       # for EWMA
library(pracma)                       # for hurstexp()

library(doMC)
registerDoMC(cores = 4)

options(useFancyQuotes = FALSE) 

## Clear all away: very important if you re-use names in
## functions.

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

source("plot0.R")
source("plot1.R")

load("folios-all.dat", envir=.GlobalEnv)

folios <- levels(folios.all$folio0)

### My experiment control parameters will be ml0

ml0 <- list()

### Take a few days to train and then test with as many as you wish.
## The time-slicing will use the test data too.

ml0$train.size <- 25
ml0$test.size <- 180 # not used

ml0$lastin <- folios.all[tail(which(folios.all$in0 == 1), n=1), "dt0"]
ml0$lastout <- folios.all[tail(which(folios.all$in0 == 0), n=1), "dt0"]

ml0$range <- c(ml0$lastin - ml0$train.size, ml0$lastout)

x.range <- (folios.all$dt0 >= ml0$range[1]) & (folios.all$dt0 <= ml0$range[2])

folios.in <- folios.all[x.range, ]

## We need to set a sliding window, we must use a least 20 days, but
## check none of the trades were held for longer than that.

ml0$window0 <- ml0$train.size
if (max(folios.in$h05, na.rm=TRUE) > ml0$window0) {
    ml0$window <- max(folios.in$h05, na.rm=TRUE)
}

### Prescience: variables
## Unlike jr2.R, we remove prescient features for the machine
## learner.

## Target feature is fp05
## I can leave the price in, because the data has been lagged.
##
## we remove these factors later
## fv05 is whether strategy or not.
## wapnl05 is the profit (or loss)

ml0$outcomen <- "fp05"
ml0$prescient <- c("fcst", "h05", "in0")
ml0$ignore <- c("l20")

x.removals <- union(ml0$prescient, ml0$ignore)

## I tried removing these thinking that z?? would provide their info.
## I might try it again on another iteration.
## ml0$derived <- c("u20", "d20", "u20", "y20", "u05", "d05", "u05", "y05")
## This two were good predictors, but are going because of the NAs
## Alternatively, I could set them to the max observed, because they are
## div-by-zero.
## ml0$derived <- c("y20", "y05")
## x.removals <- union(x.removals, ml0$derived)

folios.train0 <- folios.in[,setdiff(colnames(folios.in), 
                                    x.removals)]

folios.train0$y05[which(is.na(folios.train0$y05))] <- 2 * max(folios.train0$y05, na.rm=TRUE)
folios.train0$y20[which(is.na(folios.train0$y20))] <- 2 * max(folios.train0$y20, na.rm=TRUE)

folios.train0 <- ustk.factorize(folios.train0, fmetric0=ml0$outcomen)


### Following jr2.R, unstack 
## The shorter data set works better

train.ustk0 <- ustk.folio1(folios.train0, rownames0="dt0")

ml0$history <- diff(ml0$range)
## Shorter data set.
train.ustk1 <- tail(train.ustk0, n = ml0$history)

rm("profits1")
rm("profits0")

for (x.folio in folios) {
    print(x.folio)
    source("jr3b.R")
}

write.csv(profits0, file = "profits0.csv")
