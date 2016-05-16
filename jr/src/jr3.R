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
ml0.ignore <- c("l20")
## Check against the price signal
## ml0.prescient <- c("fcst", "wapnl05", "h05", "fv05", "in0")

folios.train0 <- folios.in[,setdiff(colnames(folios.in), 
                                    union(ml0.prescient, ml0.ignore))]

### Clear up the outcomes to binary
## Check we have a binary classifier.
if (length(levels(folios.train0$fp05)) != 2) {
    warning("Non binary results: forcing loss")
    x.factors <- unique(factor(folios.train0$fp05))
    x.idxes <- which(folios.train0$fp05 == unique(factor(folios.train0$fp05))[1])
    folios.train0[x.idxes, "fp05"] <- x.factors[2]
}

### Following jr2.R, unstack 

train.ustk1 <- ustk.folio1(folios.train0)

## Shorter data set.
train.ustk2 <- tail(train.ustk1, n = 180)

### Test one portfolio

ml0.folio <- "KF"
ml0.outcomen <- "fp05"

df <- train.ustk2

## Get the outcome and remove it.
df <- ustk.outcome(df, folio=ml0.folio, metric=ml0.outcomen)

ml0.outcomes <- attr(df, "outcomes")

## For testing the learner, use a very small dataset of just two folios

df <- ustk.xfolios(df, folios=c(ml0.folio, "KG"))

factors.numeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)], as.numeric))

df0 <- factors.numeric(df)

## Center, scale, remove any NA using nearest neighbours.
## PCA as "pca" is useful here.
ml0.imputer <- preProcess(df0, method=c("center", "scale", "knnImpute"))

## Apply the imputations.
df1 <- predict(ml0.imputer, df0)

### Data splitting
## Time slicing *not* random samples.

inTrain <- createTimeSlices(ml0.outcomes, 
                            ml0.window0  + floor(ml0.window0/2), 
                            horizon = ml0.window0, 
                            fixedWindow = TRUE, skip = 0)

idx <- 1

trainDescr <- df1[inTrain$train[[idx]],]
testDescr <- df1[-inTrain$test[[idx]],]

trainClass <- ml0.outcomes[inTrain$train[[idx]]]
testClass <- ml0.outcomes[inTrain$test[[idx]]]

prop.table(table(trainClass))
dim(trainDescr)

prop.table(table(testClass))
dim(testDescr)

### Near zero-vars and correlations
## PCA would find these, but for this iteration, we want to validate
## If any at all possible.

err.trainDescr <- list()

nzv <- nearZeroVar(trainDescr, saveMetrics= TRUE)
if (!any(nzv$nsv)) {
    warning("overfitting: near-zero var: err.trainDescr: ", paste(colnames(trainDescr)[nzv$nzv], collapse = ", ") )
    
    err.trainDescr <- append(err.trainDescr, trainDescr)
    trainDescr <- trainDescr[, -nzv$nzv ]
}

# It's imputed and behaves well, no need for this.
# descrCorr <- cor(scale(trainDescr), use = "pairwise.complete.obs")

descrCorr <- cor(scale(trainDescr))

## This cut-off should be under src.adjust control.
## There should be many of these. Because all derived from r00.
highCorr <- findCorrelation(descrCorr, cutoff = .75, verbose = TRUE)

colnames(trainDescr)[highCorr]

descr.ncol0 <- ncol(trainDescr)

# And remove the very highly correlated.
if (sum(highCorr) > 0) {
    warning("overfitting: correlations: err.trainDescr: ", paste(colnames(trainDescr)[highCorr], collapse = ", ") )
    err.trainDescr <- trainDescr
    trainDescr <- trainDescr[,-highCorr]
}

descr.ncol1 <- ncol(trainDescr)

paste("Dropped: ", as.character(descr.ncol0 - descr.ncol1))

descrCorr <- cor(trainDescr)
summary(descrCorr[upper.tri(descrCorr)])

### GBM controllers

fitControl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 10,
    classProbs = TRUE)

## Some trial and error with variables to branch and boost.
## Setting the interaction.depth
## Try all variables with length(colnames(trainDescr))

descr.grid <- floor(3/2 * descr.ncol1)

gbmGrid <- expand.grid(interaction.depth = 2,
                        n.trees = (1:descr.grid)*30,
                        shrinkage = 0.1,
                        n.minobsinnode = 10)

set.seed(seed.mine)
gbmFit1 <- train(trainDescr, trainClass,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid,
                 metric = "Kappa",
                 verbose = FALSE)

gbmFit1

## The acid test is dissapointing, but I've seen worse.

testPred <- predict(gbmFit1, testDescr)
postResample(testPred, testClass)
confusionMatrix(testPred, testClass, positive = "profit")

## The training set is exact even with the correlation cut-offs
## As one would hope - but 
trainPred <- predict(gbmFit1, trainDescr)
postResample(trainPred, trainClass)
confusionMatrix(trainPred, trainClass, positive = "profit")

## Get a density and a ROC

x.p <- predict(gbmFit1, testDescr, type = "prob")[2]
test.df <- data.frame(Weak=x.p$Weak, Obs=testClass)
test.roc <- roc(Obs ~ Weak, test.df)



