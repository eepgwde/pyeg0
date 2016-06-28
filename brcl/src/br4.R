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

registerDoMC(cores = 4)

options(useFancyQuotes = FALSE) 

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

load("ppl1.dat", envir=.GlobalEnv)
ppl00 <- ppl1

if (any(colnames(ppl1) == ml0$outcomen)) {
    ppl1[[ ml0$outcomen ]] <- NULL
}

df <- as.data.frame(ppl1)

## Partitioning
## Because we are using GBM as a classifier mode, we have to use
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

nzv <- nearZeroVar(trainDescr, saveMetrics = TRUE)
stopifnot(all(!nzv$zeroVar) & all(!nzv$nzv))

## Grid

fitControl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 10,
    allowParallel = FALSE,
    classProbs = TRUE)

## Some trial and error to set interaction and trees.

gbmGrid <- expand.grid(interaction.depth = c(10, 2, 3),
                       n.trees = (1:50)*50,
                       shrinkage = 0.1,
                       n.minobsinnode = 20 )
nrow(gbmGrid)

set.seed(seed.mine)
gbmFit1 <- train(as.data.frame(trainDescr), trainClass,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid,
                 metric = "Kappa",
                 savePredictions = TRUE,
                 verbose = TRUE)
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








