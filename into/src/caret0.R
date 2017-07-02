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

library(DMwR) # for smote implementation
library(purrr) # functional programming

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
                               p = .75, 
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

m.verbose <- FALSE

## Random forest

set.seed(seed.mine)
rfFit1 <- train(trainDescr, trainClass,
                method = "rf",
                preProc = c("center", "scale"),
                trControl = ctrl,
                metric = "ROC",
                verbose = m.verbose)
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
                 verbose = m.verbose)
gbmFit1

## Results

getRoc <- function(model, data, outcome, name0="Fail") {
  roc(outcome,
      predict(model, data, type = "prob")[, name0 ])
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

## Using imbalance methods

ctrl$seeds <- gbmFit1$control$seeds

weights0 <- ifelse(trainClass == "Pass",
 (1/table(trainClass)[1]) * 0.5,
 (1/table(trainClass)[2]) * 0.5)

## Build weighted model

gbmFit2 <- train(trainDescr, trainClass,
                 method = "gbm",
                 preProc = c("center", "scale"),
                 trControl = ctrl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid,
                 weights = weights0,
                 metric = "ROC",
                 verbose = m.verbose)
gbmFit2

testPred <- predict(gbmFit2, testingDescr)
postResample(testPred, testingClass)
confusionMatrix(testPred, testingClass, positive = "Fail")

gbmImp <- varImp(gbmFit2, scale = TRUE)
gbmImp

## Up sampling

ctrl$seeds <- gbmFit1$control$seeds
ctrl$sampling <- "up"

gbmFit3 <- train(trainDescr, trainClass,
                 method = "gbm",
                 preProc = c("center", "scale"),
                 trControl = ctrl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid,
                 metric = "ROC",
                 verbose = m.verbose)
gbmFit3


testPred <- predict(gbmFit3, testingDescr)
postResample(testPred, testingClass)
confusionMatrix(testPred, testingClass, positive = "Fail")

gbmImp <- varImp(gbmFit3, scale = TRUE)
gbmImp

## Down-sampling

## minobsinnode has to be reduced.
## Consequently converges quickly, but more inaccurate.

gbmGrid4 <- expand.grid(interaction.depth = 3,
                        n.trees = (1:30)*90,
                        shrinkage = 0.2,
                        n.minobsinnode = 5)

ctrl$seeds <- gbmFit1$control$seeds
ctrl$sampling <- "down"

gbmFit4 <- train(trainDescr, trainClass,
                 method = "gbm",
                 preProc = c("center", "scale"),
                 trControl = ctrl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid4,
                 metric = "ROC",
                 verbose = m.verbose)
gbmFit4


testPred <- predict(gbmFit4, testingDescr)
postResample(testPred, testingClass)
confusionMatrix(testPred, testingClass, positive = "Fail")

gbmImp <- varImp(gbmFit4, scale = TRUE)
gbmImp


## SMOTE

## Build smote model
## SMOTE: Synthetic Minority Over-sampling Technique

ctrl$seeds <- gbmFit1$control$seeds
ctrl$sampling <- "smote"

gbmFit5 <- train(trainDescr, trainClass,
                 method = "gbm",
                 preProc = c("center", "scale"),
                 trControl = ctrl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid,
                 metric = "ROC",
                 verbose = m.verbose)
gbmFit5


testPred <- predict(gbmFit5, testingDescr)
postResample(testPred, testingClass)
confusionMatrix(testPred, testingClass, positive = "Fail")

gbmImp <- varImp(gbmFit5, scale = TRUE)
gbmImp

## Summary

model_list <- list(original = gbmFit1,
                   randomForest = rfFit1,
                   weighted = gbmFit2,
                   down = gbmFit3,
                   up = gbmFit4,
                   smote = gbmFit5)

model_list_roc <- model_list %>%
  map(getRoc, data = testingDescr, outcome=testingClass)

model_list_roc %>%
    map(auc)

## Plot

results_list_roc <- list(NA)
num_mod <- 1

results_df_roc <- NULL

for(the_roc in model_list_roc){
  
    df <- data.frame(tpr = the_roc$sensitivities,
                     fpr = 1 - the_roc$specificities,
                     model = names(model_list)[num_mod])

    if (is.null(results_df_roc)) {
        results_df_roc <<- df
    } else {
        results_df_roc <<- rbind(results_df_roc, df)
    }
}

## Plot ROC curve for all 5 models

if (exists("m.img"))
    jpeg(width=1024, height=1024, filename = "auc-%02d.jpg")


custom_col <- c("#000000", "#009E73", "#0072B2", "#D55E00", "#CC79A7")

ggplot(aes(x = fpr,  y = tpr, group = model), data = results_df_roc) +
  geom_line(aes(color = model), size = 1) +
  scale_color_manual(values = custom_col) +
  geom_abline(intercept = 0, slope = 1, color = "gray", size = 1) +
    theme_bw(base_size = 18)

if (exists("m.img"))
    dev.off()


## Save everything for plotting.

save(list = ls(all.names = TRUE), file = "fits.RData", envir = .GlobalEnv)
