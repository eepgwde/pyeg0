## weaves
## smava 1a - Using random forest

getwd()

## load in packages
library(caret)
library(ranger)
library(tidyverse)
library(e1071)
library(MASS)
library(rpart)
library(rpart.plot)
library(ipred)
library(mlbench)
library(pROC)
library(gbm)

library(doMC)

registerDoMC(cores = 4)

options(useFancyQuotes = FALSE)

## Data sets

load("smava1.dat", envir=.GlobalEnv)

## from smava00.R we have df0, outcomes and smava0

## simple controls

## Grid
## This does not work - mtry not recognised issue.

rfGrid <- expand.grid(ntree = 1000, sampsize =90000, 
                      importance = TRUE, 
                      nPerm =2, oob.prox = TRUE)

## Create model with default paramters

control <- trainControl(
  method="repeatedcv", number=10, repeats=3,
  summaryFunction = twoClassSummary, classProbs=TRUE )

## More controls

## Very, very slow - make sure you have PCAs in there.
x.ntrees <- 500
mtry.max <- floor(sqrt(length(colnames(df0))))

## For testing - and for bad data.
x.ntrees <- 100
mtry.max <- 5

metric <- "ROC"
mtry <- 2:mtry.max
# tunegrid <- expand.grid(.mtry=mtry)


rfFit1 <- train(df0, outcomes,
                method = "ranger",
                importance = "permutation",
                verbose = FALSE)
rfFit1

smava0$rf <- rfFit1
fit0 <- rfFit1

##

trainPred <- predict(fit0, df0)

conf0 <- confusionMatrix(trainPred, outcomes, positive = "Yes")
conf0

## Only 65% accurate on the whole set!

nvars <- floor(length(colnames(df0)) * 2/3)

jpeg(filename=paste("smava0", "mf-rf", "-%03d.jpeg", sep=""), 
     width=1024, height=768)

modelImp <- varImp(fit0, scale = FALSE)
plot(modelImp, top = min(dim(modelImp$importance)[1], nvars) )

## Get a density and a ROC
## You need twoClassSummary for this

x.p <- predict(fit0, df0, type = "prob")[2]

test.df <- data.frame(true0=x.p[[ "Yes" ]], Obs=outcomes)
test.roc <- roc(Obs ~ true0, test.df)

densityplot(~test.df$true0, groups = test.df$Obs, auto.key = TRUE)

plot.roc(test.roc)

dev.off()

## Make a prediction using test.

## Apply the same data pre-processing and predict.

## Don't do the order.

test0 <- data.frame(test) # just an backup to use in the interpreter.
test1 <- data.frame(test)

for(c in smava0$cs) {
  test1[[c]] <- as.numeric(test1[[c]])
}

test1$x2na <- 0
test1[ is.na(test1$x2), "x2na" ] <- 1
test1[ is.na(test1$x2), "x2" ] <- smava0$x2impute

test1n <- test1[, smava0$ft1]

## pre-process
df0 <- predict(smava0$pp, test1n)

testPred <- predict(smava0$gbm, df0)

predictions <- data.frame(test)
predictions$predictionAccepted <- testPred

save(predictions, file="predictions.rdata")

