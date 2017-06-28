### weaves

## Following mutagen in Building Predictive Models in R Using the caret Package

## I can't get past the correlations highCorr. NA elements.

library(QSARdata)

data(Mutagen)

set.seed(1)

mutagen <- Mutagen_Outcome
descr <- Mutagen_Dragon

inTrain <- createDataPartition(mutagen, p = 3/4, list = FALSE)

trainDescr <- descr[inTrain,]
testDescr <- descr[-inTrain,]
trainClass <- mutagen[inTrain]
testClass <- mutagen[-inTrain]

prop.table(table(mutagen))

prop.table(table(trainClass))

ncol(trainDescr)

nzv <- nearZeroVar(trainDescr, saveMetrics= TRUE)

nzv1 <- nzv[ nzv$nzv, ]
nzv1 <- nzv1[ order(nzv1$percentUnique, nzv1$freqRatio), ]

nnames <- setdiff(colnames(trainDescr), rownames(nzv)[nzv$zeroVar])

descr <- Mutagen_Dragon[,nnames]

inTrain <- createDataPartition(mutagen, p = 3/4, list = FALSE)

trainDescr <- descr[inTrain,]
testDescr <- descr[-inTrain,]
trainClass <- mutagen[inTrain]
testClass <- mutagen[-inTrain]

prop.table(table(mutagen))

prop.table(table(trainClass))

ncol(trainDescr)

descrCorr <- cor(scale(trainDescr), use = "pairwise.complete.obs")

cols <- names(which(is.na(df[1,])))
nnames <- setdiff(colnames(trainDescr), cols)

trainDescr <- trainDescr[, nnames]



descrCorr <- cor(scale(trainDescr), use = "pairwise.complete.obs")

highCorr <- findCorrelation(descrCorr, cutoff = .90, verbose = TRUE)

trainDescr <- trainDescr[, -highCorr]
testDescr <- testDescr[, -highCorr]
ncol(trainDescr)
