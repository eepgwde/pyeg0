### weaves

## caret using the weaves:caret structure.

rm(list=ls())

library(doMC)
registerDoMC(cores = 4)

library(MASS)
library(caret)
library(mlbench)
library(pROC)
library(pls)

library(Rweaves1)

library(AppliedPredictiveModeling)

options(useFancyQuotes = FALSE) 

load("w.RData")

print(sprintf("outcome: %s", w[['outcome-name']]))

## Change to something more meaning

x0 <- ! col.str2logical(w[['outcome']])
x0 <- factor(as.character(x0))
levels(x0) <- c("Pass", "Fail")
w[['outcome']] <- x0

## Check the imbalance.

p0 <- prop.table(table(w[['outcome']]))
odds.against(p0[2])

## Heuristics from train() says

if (FALSE) {
    w[['zv1']] <- c("i0.Reason.2", "i0.Reason.7", "i1.Reason.5", "na.Supplier", "a1.Viscosity")
    w[['n']] <- w[['n']][, setdiff(colnames(w[['n']]), w[['zv1']])]
}

## end: Heuristics

seed.mine <- 107
set.seed(seed.mine)

inTrain <- createDataPartition(y = w[['outcome']], 
                               ## the outcome data are needed
                               p = .85, 
                               ## The percentage of data in the 
                               ## training set
                               list = FALSE)
                               ## The format of the results

trainDescr <- w[['n']][inTrain,]

## Because sampling can re-introduce zero-variance variables.
w[['df']] <- trainDescr
w <- caret.zv(w)


w[['n']] <- caret.filter(w)
w[['n']] <- caret.numeric(w)

trainDescr <- w[['n']][inTrain,]
testingDescr  <- w[['n']][-inTrain,]

trainClass <- w[['outcome']][inTrain]
testingClass <- w[['outcome']][-inTrain]

nrow(trainDescr)
nrow(testingDescr)


## plsFit <- train(Class ~ ., 
##                  data = trainDescr,
##                  method = "pls",
##                  ## Center and scale the predictors for the trainDescr 
##                  ## set and all future samples.
##                  preProc = c("center", "scale"))

## trainDescr0 <- trainDescr
## trainDescr <- preProcess(trainDescr0, method = c("center", "scale"))

tr.cols <- colnames(trainDescr)
tr.cols
tr.icols <- grep("((STA|EQP)$)|(^xD)", tr.cols)
tr.icols <- rev(tr.icols)

fitControl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 10,
    classProbs = TRUE)

## Some trial and error with variables to branch and boost.
## Try all variables

gbmGrid <- expand.grid(interaction.depth = 
                           length(colnames(trainDescr)),
                        n.trees = (1:30)*90,
                        shrinkage = 0.2,
                        n.minobsinnode = 10)

set.seed(seed.mine)
rfFit1 <- train(trainDescr, trainClass,
                 method = "rf",
                 preProc = c("center", "scale"),
                 metric = "Kappa",
                 verbose = TRUE)
rfFit1

gbmFit1 <- train(trainDescr, trainClass,
                 method = "gbm",
                 preProc = c("center", "scale"),
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid,
                 metric = "Kappa",
                 verbose = TRUE)
gbmFit1

