## weaves
##
## Machine learning: fit
##
## Load the ml0 parameters from file.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

library(MASS)
library(caret)
library(mlbench)
library(pROC)
library(gbm)

library(doMC)
registerDoMC(cores = detectCores(logical = FALSE))

options(useFancyQuotes = FALSE) 

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

load("ppl1.dat", envir=.GlobalEnv)
ppl00 <- ppl1

df <- ppl1

## Partitioning
## Because we are use GBM in classificatioiin mode, we have to use
## the outcome as a separate list (no formula). ml0$outcomes contains
## the outcomes.

set.seed(seed.mine)
inTrain <- createDataPartition(ml0$outcomes, p = 0.77, list = FALSE)

trainDescr <- df[inTrain,]
testDescr <- df[-inTrain,]

trainClass <- ml0$outcomes[ inTrain ]
testClass <- ml0$outcomes[ -inTrain ]

prop.table(table(trainClass))
dim(trainDescr)

prop.table(table(testClass))
dim(testDescr)

## Grid

fitControl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 5,
    ## repeated ten times
    repeats = 5,
    classProbs = TRUE)

## Some trial and error

gbmGrid <- expand.grid(interaction.depth = 
                           c(1, 5, 9),
                       n.trees = (1:20)*10,
                       shrinkage = 0.1,
                       n.minobsinnode = 20)

set.seed(seed.mine)
gbmFit1 <- train(trainDescr, trainClass,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid,
                 metric = "Kappa",
                 savePredictions = TRUE,
                 verbose = FALSE)
gbmFit1

## Training set

trainPred <- predict(gbmFit1, trainDescr)
postResample(trainPred, trainClass)
confusionMatrix(trainPred, trainClass, positive = ml0$outcome0)

## Test set

testPred <- predict(gbmFit1, testDescr)
postResample(testPred, testClass)
confusionMatrix(testPred, testClass, positive = ml0$outcome0)








