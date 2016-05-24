### weaves

## Following mutagen in Building Predictive Models in R Using the caret Package

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

descrCorr <- cor(scale(trainDescr), use = "pairwise.complete.obs")

highCorr <- findCorrelation(descrCorr, cutoff = .90, verbose = TRUE)

trainDescr <- trainDescr[, -highCorr]
testDescr <- testDescr[, -highCorr]
ncol(trainDescr)
