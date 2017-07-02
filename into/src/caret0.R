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

## Heuristics from train() says

w[['zv1']] <- c("i0.Reason.6", "i1.Reason.5", "i1.Reason.6", "i3.Reason.6", "na.Supplier")

w[['n']] <- w[['n']][, setdiff(colnames(w[['n']]), w[['zv1']])]

## end: Heuristics

seed.mine <- 107
set.seed(seed.mine)

inTrain <- createDataPartition(y = w[['outcome']], 
                               ## the outcome data are needed
                               p = .75, 
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

###################################################
### code chunk number 6: plsFit
###################################################
ctrl <- trainControl(method = "repeatedcv",
                    repeats = 3,
                    classProbs = TRUE,
                    summaryFunction = twoClassSummary)
                    
set.seed(123)                    
plsFit <- train(Class ~ ., 
                data = trainDescr,
                method = "pls",
                tuneLength = 15,
                trControl = ctrl,
                metric = "ROC",
                preProc = c("center", "scale"))


###################################################
### code chunk number 7: plsPrint
###################################################
plsFit


###################################################
### code chunk number 8: baPlot
###################################################
trellis.par.set(caretTheme())
print(plot(plsFit))


###################################################
### code chunk number 9: plsPred
###################################################
plsClasses <- predict(plsFit, newdata = testingDescr)
str(plsClasses)
plsProbs <- predict(plsFit, newdata = testingDescr, type = "prob")
head(plsProbs)


###################################################
### code chunk number 10: plsCM
###################################################
confusionMatrix(data = plsClasses, testingDescr$Class)


###################################################
### code chunk number 11: rdaFit
###################################################
## To illustrate, a custom grid is used
rdaGrid = data.frame(gamma = (0:4)/4, lambda = 3/4)
set.seed(123)                    
rdaFit <- train(Class ~ ., 
                data = trainDescr,
                method = "rda",
                tuneGrid = rdaGrid,
                trControl = ctrl,
                metric = "ROC")
rdaFit
rdaClasses <- predict(rdaFit, newdata = testingDescr)
confusionMatrix(rdaClasses, testingDescr$Class)


###################################################
### code chunk number 12: rs
###################################################
resamps <- resamples(list(pls = plsFit, rda = rdaFit))
summary(resamps)


###################################################
### code chunk number 13: diffs
###################################################
diffs <- diff(resamps)
summary(diffs)


###################################################
### code chunk number 14: plsPlot
###################################################

plotTheme <- caretTheme()
plotTheme$plot.symbol$col <- rgb(.2, .2, .2, .5)
plotTheme$plot.symbol$pch <- 16
trellis.par.set(plotTheme)
print(xyplot(resamps, what = "BlandAltman"))


