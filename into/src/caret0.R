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

## Heuristics from train() 

## These were listed as near zero variance, but are good indicators.
if (FALSE) {
    w[['zv1']] <- c("i0.Reason.2", "i0.Reason.7", "i1.Reason.5", "na.Supplier", "a1.Viscosity")
    w[['n']] <- w[['n']][, setdiff(colnames(w[['n']]), w[['zv1']])]
}

## Back.in.Spec is prescient

tag.f <- 'Back.in.Spec'
w[['n']] <- w[['n']][, setdiff(colnames(w[['n']]), tag.f)]

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

ctrl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 5,
    summaryFunction = twoClassSummary,
    classProbs = TRUE)

## Random forest

set.seed(seed.mine)
rfFit1 <- train(trainDescr, trainClass,
                method = "rf",
                preProc = c("center", "scale"),
                trControl = ctrl,
                metric = "ROC",
                verbose = TRUE)
rfFit1

## GBM
## Some trial and error with variables to branch and boost.

gbmGrid <- expand.grid(interaction.depth = 3,
                        n.trees = (1:30)*90,
                        shrinkage = 0.2,
                        n.minobsinnode = 10)

gbmFit1 <- train(trainDescr, trainClass,
                 method = "gbm",
                 preProc = c("center", "scale"),
                 trControl = ctrl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid,
                 metric = "ROC",
                 verbose = TRUE)
gbmFit1

## Results

getRoc <- function(model, data, outcome) {
  roc(outcome,
      predict(model, data, type = "prob")[, "Fail"])
}

rfFit1 %>%
    getRoc(data=testingDescr, outcome=testingClass) %>% 
    auc()


gbmFit1 %>%
    getRoc(data=testingDescr, outcome=testingClass) %>% 
    auc()

testPred <- predict(rfFit1, testingDescr)
postResample(testPred, testingClass)
confusionMatrix(testPred, testingClass, positive = "Fail")

rfImp <- varImp(rfFit1, scale = TRUE)
rfImp

testPred <- predict(gbmFit1, testingDescr)
postResample(testPred, testingClass)
confusionMatrix(testPred, testingClass, positive = "Fail")

gbmImp <- varImp(gbmFit1, scale = TRUE)
gbmImp
