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

library(ggplot2)

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

### My experiment control parameters will be ml0

ml0 <- list()

### Take 120 days around the in/out mark.

ml0$lastin <- folios.all[tail(which(folios.all$in0 == 1), n=1), "dt0"]
ml0$range <- c(ml0$lastin - 90, ml0$lastin + 30)

x.range <- (folios.all$dt0 >= ml0$range[1]) & (folios.all$dt0 <= ml0$range[2])

folios.in <- folios.all[x.range, ]

## We need to set a sliding window, we must use a least 20 days, but
## check none of the trades were held for longer than that.

ml0$window0 <- 30
if (max(folios.in$h05, na.rm=TRUE) > ml0$window0) {
    ml0$window <- max(folios.in$h05, na.rm=TRUE)
}

### Prescience: variables
## Unlike jr2.R, we remove prescient features for the machine
## learner.

## Target feature is fp05
## I can leave the price in, because the data has been lagged.

ml0$outcomen <- "fp05"
ml0$prescient <- c("fcst", "wapnl05", "h05", "fv05", "in0")
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

train.ustk1 <- ustk.folio1(folios.train0)

ml0$history <- 90
## Shorter data set.
train.ustk2 <- tail(train.ustk1, n = ml0$history)

### Test one portfolio

ml0$folio <- "KF"

df <- train.ustk2

## Get the folio outcome and remove the others.
## And deal with NA
df <- ustk.outcome(df, folio=ml0$folio, metric=ml0$outcomen)
ml0$outcomes <- attr(df, "outcomes")
ml0$outcomes[which(is.na(ml0$outcomes))] <- factor(ml0$outcomes)[1]

## For testing the learner, use a very small dataset of just two folios

## df <- ustk.xfolios(df, folios=c(ml0.folio, "KG", "KH"))

factors.numeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)], as.numeric))

df0 <- factors.numeric(df)

### Find the near-zero variance and high correlation variables
source("jr3a.R")

### PLS controller is a sliding window.

fitControl <- trainControl(## timeslicing
    initialWindow = ml0$window0,
    horizon = ml0$window0,
    fixedWindow = TRUE,
    method = "timeslice",
    classProbs = TRUE)

## Put the outcomes back in and use a global formula.

df1[, ml0$outcomen] <- ml0$outcomes

## @note
## Weightings: EWMA don't make any difference
x.samples <- dim(df1)[1]
x.ewma <- EWMA(c(1, rep(0,x.samples-1)), lambda = 0.30, startup = 1)
x.weights <- x.ewma / sum(x.ewma)
x.weights <- rep(1, x.samples)

## The formula is the "use-all" statement.
set.seed(seed.mine)
modelFit1 <- train(fp05 ~ ., data = df1,
                   method = "pls",
                   weights = x.weights,
                   trControl = fitControl, metric = "Kappa")
modelFit1

### Time-slices: training and test is available.
##
## use
##  modelFit1$control$index for training data
##  modelFit1$control$indexOut for testing data

## The training set should be near exact even with the correlation
## cut-offs.

trainPred <- predict(modelFit1, df1)
postResample(trainPred, ml0$outcomes)
confusionMatrix(trainPred, ml0$outcomes, positive = "profit")

modelImp <- varImp(modelFit1, scale = FALSE)
plot(modelImp, top = 20)

## The last testing set: this has not been used for training, so should
## be a good test.

x.idx <- length(modelFit1$control$indexOut) - 1
x.idxes <- modelFit1$control$indexOut[[x.idx]]

testClass <- ml0$outcomes[x.idxes]
testDescr <- df1[x.idxes,]

testPred <- predict(modelFit1, testDescr)
postResample(testPred, testDescr)
confusionMatrix(testPred, testClass, positive = "profit")

x.idx <- length(modelFit1$control$indexOut)
x.idxes <- modelFit1$control$indexOut[[x.idx]]

testClass <- ml0$outcomes[x.idxes]
testDescr <- df1[x.idxes,]

testPred <- predict(modelFit1, testDescr)
postResample(testPred, testDescr)
confusionMatrix(testPred, testClass, positive = "profit")


