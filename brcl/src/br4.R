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
    number = 10,
    ## repeated ten times
    repeats = 10,
    classProbs = TRUE)

## Some trial and error to set interaction and trees.

gbmGrid <- expand.grid(interaction.depth = c(1, 2),
                       n.trees = (1:20)*50,
                       shrinkage = 0.2,
                       n.minobsinnode = min(20, dim(trainDescr)[2])

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

fit1 <- gbmFit1

### Images

jpeg(filename=paste(ml0$outcomen, "%03d.jpeg", sep=""), 
     width=1024, height=768)

modelImp <- varImp(fit1, scale = FALSE)
plot(modelImp, top = min(dim(modelImp$importance)[1], 20) )

## Get a density and a ROC

x.p <- predict(fit1, testDescr, type = "prob")[2]

test.df <- data.frame(true0=x.p[[ ml0$outcome0 ]], Obs=testClass)
test.roc <- roc(Obs ~ true0, test.df)

densityplot(~test.df$true0, groups = test.df$Obs, auto.key = TRUE)

plot.roc(test.roc)

dev.off()








