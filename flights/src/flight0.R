### weaves

## Processing for flights data.

## Following the caret vignette.

###################################################
### code chunk number 1: loadLibs
###################################################
library(MASS)
library(caret)
library(mlbench)
library(pROC)
library(pls)

library(doMC)
registerDoMC(cores = 4)

options(useFancyQuotes = FALSE) 

# Accounting info.
getInfo <- function(what = "Suggests")
{
  text <- packageDescription("caret")[what][[1]]
  text <- gsub("\n", ", ", text, fixed = TRUE)
  text <- gsub(">=", "$\\\\ge$", text, fixed = TRUE)
  eachPkg <- strsplit(text, ", ", fixed = TRUE)[[1]]
  eachPkg <- gsub(",", "", eachPkg, fixed = TRUE)
  # out <- paste("\\\\pkg{", eachPkg[order(tolower(eachPkg))], "}", sep = "")
  # paste(out, collapse = ", ")
  length(eachPkg)
}

### project-specific: begin
## Set-seed, load original CSV file, order it
## and do some simple-cleaning
## Various datasets 

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

flight <- read.csv("../bak/flight.csv")
flight <- flight[order(flight$D00),]

# Backup
flight.raw <- flight

# Check warnings
src.adjust <- TRUE
source(file = "flight1.R")

# To check adjustment, there is test code in flight-nb.R

# Some additions

flight$DEPSPOKE <- flight$DEPGRP == "Spoke"
flight$ARRSPOKE <- flight$ARRGRP == "Spoke"

# And some deletions

t.cols <- colnames(flight)

t.drops <- t.cols[grep("^RANK*", t.cols)]
t.drops <- c(t.drops, t.cols[grep("^(ARR|DEP)GRP$", t.cols)])
t.drops <- c(t.drops, "D80THPCTL")

flight <- flight[ , t.cols[!(t.cols %in% t.drops)] ]

## Let's do the flight duration logic see the flight logic the notes.

flight$xDURN <- flight$SARRHR - flight$SDEPHR
flight$xHNGR <- flight$xDURN < 0

## I don't think there is any hangaring. I have to clean this up.

## Max flight time is 8 hours for the positives, but red-eyes can
## take longer

hr.wrap <- function(d0, a0) {
    t0 <- a0 - d0
    if (t0 >= 0) return(t0)
    t0 <- 24 - d0
    t0 <- t0 + a0
    return(t0)
}

flight$xDURN2 <- apply(flight[,c("SDEPHR", "SARRHR")], 1, 
                       function(y) hr.wrap(y['SDEPHR'], y['SARRHR']))

flight[which(flight$xDURN2 != flight$xDURN), c("SDEPHR", "SARRHR", "xDURN","xDURN2", "xHNGR")]
t.cols <- colnames(flight)

t.drops <- c("SARRHR", "xDURN")
flight <- flight[ , t.cols[!(t.cols %in% t.drops)] ]

## Backup

flight00 <- flight

# And we drop many, many rows because R slows with large datasets.
# These are the ranges we have been asked to predict on.

flight <- flight[flight$AVGLOFATC >= 3.1 & flight$AVGLOFATC <= 4.4,]

## Take another copy - this is all we need as the training/prediction
## set.

flight1 <- flight

## Data insights

## *Run from here.

## Using the D00 and LEGTYPE dataset, I have this concern that D00 is
## a derived probit and we should ignore it.

flight <- flight1

## So something is defining the behaviour.

## Try to simplify structure

head(model.matrix(LEGTYPE ~ ., data = flight))

dummies <- dummyVars(LEGTYPE ~ ., data = flight)
flight.dum <- predict(dummies, newdata = flight)

## It may be too big to use, but useful for inspection.

### Numeric variables

## Check some more numeric correlations, I haven't scaled yet.
## I'd cut correlations above 0.75 because of overfitting.

x1 <- as.data.frame(as.matrix(sapply(flight, class)))

flight.num <- flight[,names(x1[which(x1$V1 %in% c("numeric", "integer")),])]

flight.nzv <- nearZeroVar(flight.num, saveMetrics = TRUE)
flight.nzv

# annoying NA
flight.cor <- cor(flight.num, use = "pairwise.complete.obs")

descrCorr <- findCorrelation(flight.cor, cutoff = .65, verbose=TRUE)

colnames(flight.num)[descrCorr]

## Which tells me that departure time is very highly correlated to AVGSQ.
## AVGSQ is average stand queue?

### Try and impute the AVG, it might have more information than the
### bucket.

flight$xAVAILBUCKET <- as.numeric(gsub("^[A<]+", "", flight$AVAILBUCKET))

## Arbitrary choice to set to -1.
flight[which(flight$AVAILBUCKET == 'A<0'), "xAVAILBUCKET" ] <- -1

flight.na <- flight[, c("AVGSKDAVAIL", "xAVAILBUCKET")]

preProcValues <- preProcess(flight.na, method = c("knnImpute"))
flight.na1 <- predict(preProcValues, flight.na)

flight$xAVGSKDAVAIL <- flight.na1$AVGSKDAVAIL

## And I'll leave the centered and scale values in for now.
## and delete the troublesome ones

flight$AVGSKDAVAIL <- NULL
flight$xHNGR <- NULL
flight$AVAILBUCKET <- NULL

# This should be deleted, leave it in and the results are ideal because it defines LEGTYPE.
flight$D00 <- NULL

## Keep the results but don't change the order.
outcomes.flight <- flight$LEGTYPE

flight$LEGTYPE <- NULL

## Try converting all the factors to numerics

flight[,names(x1[which(x1$V1 %in% c("factor")),])]

## If you know your factors are definitely factors, you don't need this
##  asNumeric <- function(x) as.numeric(as.character(x))

factors.numeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)], as.numeric))

flight.num0 <- factors.numeric(flight)

flight.scl0 <- scale(flight.num0)

## Now split the results

inTrain <- createDataPartition(outcomes.flight, p = 0.65, list = FALSE)

trainDescr <- flight.scl0[inTrain,]
testDescr <- flight.scl0[-inTrain,]

trainClass <- outcomes.flight[inTrain]
testClass <- outcomes.flight[-inTrain]

prop.table(table(flight.scl0))

prop.table(table(trainClass))

dim(trainDescr)
dim(testDescr)

## Check Near-zero variance

nzv <- nearZeroVar(trainDescr, saveMetrics= TRUE)
stopifnot( all(nzv$nzv == FALSE) )

# It's imputed and behaves well, no need for this.
# descrCorr <- cor(scale(trainDescr), use = "pairwise.complete.obs")

descrCorr <- cor(scale(trainDescr))

## This cut-off should be under src.adjust control.
## I'm under Git, so I can tinker with it.
highCorr <- findCorrelation(descrCorr, cutoff = .70, verbose = TRUE)

colnames(trainDescr)[highCorr]

descr.ncol0 <- ncol(trainDescr)

# I've switched off the correlation remover and the results are better.
if (sum(highCorr) > 0) {
    warning("overfitting: correlations: err.trainDescr: ", paste(colnames(trainDescr)[highCorr], collapse = ", ") )
    err.trainDescr <- trainDescr
    trainDescr <- trainDescr[,-highCorr]
}

descr.ncol1 <- ncol(trainDescr)

paste("Dropped: ", as.character(descr.ncol0 - descr.ncol1))

descrCorr <- cor(trainDescr)
summary(descrCorr[upper.tri(descrCorr)])

## Dominant correlations
## At 0.9, there are some big ones that might need re-thinking.

table.descrCorr <- as.data.frame(as.table(descrCorr))
table.descrCorr <- table.descrCorr[which(table.descrCorr$Var1 != table.descrCorr$Var2),]
table.descrCorr[order(abs(table.descrCorr$Freq), decreasing = TRUE),]

### Models

## Try GBM (gradient boosting). Works well for mixed data.
## And there is a tutorial for it with caret.

## Training controller and big grid
## Check the ROC (my preferred.)

fitControl <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 10,
    classProbs = 10,
    summaryFunction = twoClassSummary)

## Some trial and error with variables to branch and boost.
## I'm just going to try the airports and the planes and the duration
## of the flight. There may be some distance relationship there that
## air traffic control use.

## Annoying because I drop variables, this needs to be looked up.

tr.cols <- colnames(trainDescr)
tr.cols
tr.icols <- grep("((STA|EQP)$)|(^x)", tr.cols)
tr.icols <- rev(tr.icols)

gbmGrid <- expand.grid(interaction.depth = tr.icols,
                        n.trees = (1:30)*80,
                        shrinkage = 0.1,
                        n.minobsinnode = 20)

set.seed(seed.mine)
gbmFit1 <- train(trainDescr, trainClass,
                 method = "gbm",
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 tuneGrid = gbmGrid,
                 metric = "ROC",
                 verbose = FALSE)
gbmFit1

## The acid test is dissapointing, but I've seen worse.

testPred <- predict(gbmFit1, testDescr)
postResample(testPred, testClass)
confusionMatrix(testPred, testClass, positive = "Weak")

## The training set is exact even with the correlation cut-offs
## As one would hope - but 
trainPred <- predict(gbmFit1, trainDescr)
postResample(trainPred, trainClass)
confusionMatrix(trainPred, trainClass, positive = "Weak")

