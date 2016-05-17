## weaves
##
## Machine learning preparation.
## File with q/kdb+ generated technicals.

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

load("folios-in.dat", envir=.GlobalEnv)

### My experiment control parameters will be ml0

ml0 <- list()

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
## I can leave the price in, because I lag the data later.
ml0$outcomen <- "fp05"
ml0$prescient <- c("fcst", "wapnl05", "h05", "fv05", "in0")
ml0$ignore <- c("l20")
## Tried removing these thinking that z?? would provide info.
## ml0$derived <- c("u20", "d20", "u20", "y20", "u05", "d05", "u05", "y05")
## Check against the price signal
## ml0.prescient <- c("fcst", "wapnl05", "h05", "fv05", "in0")

x.removals <- union(ml0$prescient, ml0$ignore)
## x.removals <- union(x.removals, ml0$derived)

folios.train0 <- folios.in[,setdiff(colnames(folios.in), 
                                    x.removals)]

folios.train0 <- ustk.factorize(folios.train0, fmetric0=ml0$outcomen)

### Following jr2.R, unstack 
## The shorter data set works better, so we must add weights
## or use an iterative evaluator.

train.ustk1 <- ustk.folio1(folios.train0)

ml0$history <- 90
## Shorter data set.
train.ustk2 <- tail(train.ustk1, n = ml0$history)

### Test one portfolio

ml0$folio <- "KF"

df <- train.ustk2

## Get the folio outcome and remove the others.
df <- ustk.outcome(df, folio=ml0$folio, metric=ml0$outcomen)

ml0$outcomes <- attr(df, "outcomes")

### Prescience: 1 day lag on trading variables
## Enforce the one day trading lag.
ts.zoo <- zoo(df)
ts.zoo1 <- lag(ts.zoo, k=-1)
df0 <- data.frame(ts.zoo1)

## @note
## Not this one.
## ml0$outcomes <- ml0$outcomes[2:length(ml0$outcomes)]
## This one.
ml0$outcomes <- ml0$outcomes[1:((length(ml0$outcomes)-1))]

## For testing the learner, use a very small dataset of just two folios

## df <- ustk.xfolios(df, folios=c(ml0.folio, "KG", "KH"))

factors.numeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)], as.numeric))

df0 <- factors.numeric(df0)

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

## For time-slices,
## use modelFit1$control$index for training data
## modelFit1$control$indexOut for testing data



## The training set should be near exact even with the correlation
## cut-offs.

trainPred <- predict(modelFit1, df1)
postResample(trainPred, ml0$outcomes)
confusionMatrix(trainPred, ml0$outcomes, positive = "profit")

modelImp <- varImp(modelFit1, scale = FALSE)
plot(modelImp, top = 20)

## The last testing set: this has not been used for training, so should
## be good.

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

## 

