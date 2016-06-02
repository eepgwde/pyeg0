### weaves
## Main process loop

### Test one portfolio

if (!exists("x.folio")) {
    ml0$folio <- "KF"
} else {
    ml0$folio <- x.folio
}

df <- train.ustk1

## Get the folio strategty and outcome and remove the others.
## And deal with NA
df <- ustk.outcome(df, folio=ml0$folio, metric="fv05")
ml0$strat <- attr(df, "outcomes")

df <- ustk.outcome(df, folio=ml0$folio, metric="wapnl05")
ml0$wapnl05 <- attr(df, "outcomes")

df <- ustk.outcome(df, folio=ml0$folio, metric=ml0$outcomen)
ml0$outcomes <- attr(df, "outcomes")
ml0$outcomes[which(is.na(ml0$outcomes))] <- factor(ml0$outcomes)[1]

ml0$pnl <- data.frame(ml0$outcomes, ml0$strat, ml0$wapnl05, 
                      row.names=rownames(df), stringsAsFactors=FALSE)
colnames(ml0$pnl) <- c("outcomes", "strat", "pnl")

## For testing the learner, use a very small dataset of just two folios

## df <- ustk.xfolios(df, folios=c(ml0.folio, "KG", "KH"))

factors.numeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)], as.numeric))

df0 <- factors.numeric(df)

### Find the near-zero variance and high correlation variables
## This creates df1
source("jr3a.R")

### PLS controller is a sliding window.

fitControl <- trainControl(## timeslicing
    initialWindow = ml0$window0,
    horizon = 1,
    fixedWindow = TRUE,
    method = "timeslice",
    savePredictions = TRUE,
    classProbs = TRUE)

## Put the outcomes back in and use a global formula.

df1[, ml0$outcomen] <- ml0$outcomes

## @note
## Weightings: EWMA makes no difference
x.samples <- dim(df1)[1]

# x.ewma <- EWMA(c(1, rep(0,x.samples-1)), lambda = 0.050, startup = 1)
# x.weights <- rev(x.ewma) / sum(x.ewma)
x.weights <- rep(1, x.samples)

## The formula is the "use-all" statement.
set.seed(seed.mine)
modelFit1 <- train(fp05 ~ ., data = df1,
                   method = "pls",
                   weights = x.weights,
                   trControl = fitControl, metric = "Kappa")
modelFit1

## Individual predictions are archived.
## See the time-series work.
write.csv(modelFit1$pred, "mf1-pred.csv")

### Time-slices: training and test is available.
##
## use
##  modelFit1$control$index for training data
##  modelFit1$control$indexOut for testing data

## The training set should be near exact even with the correlation
## cut-offs.

trainPred <- predict(modelFit1, df1)
postResample(trainPred, ml0$outcomes)
confusionMatrix(trainPred, ml0$outcomes, positive = "profit")

## The out-of-sample sets can be selected

ml0$lastin.idx <- which(as.numeric(rownames(df)) > ml0$lastin)[1]

x.idxes <- as.numeric(modelFit1$control$indexOut[which(modelFit1$control$indexOut >= ml0$lastin.idx)])

testClass <- ml0$outcomes[x.idxes]
testDescr <- df1[x.idxes,]

testPred <- predict(modelFit1, testDescr)
postResample(testPred, testClass)
confusionMatrix(testPred, testClass, positive = "profit")

### Final plots

## Variable importance

jpeg(filename=paste(ml0$folio, "%03d.jpeg", sep=""), 
     width=1024, height=768)

modelImp <- varImp(modelFit1, scale = FALSE)
plot(modelImp, top = 20)

## Get a density and a ROC

x.p <- predict(modelFit1, testDescr, type = "prob")[2]
test.df <- data.frame(profit=x.p$profit, Obs=testClass)
test.roc <- roc(Obs ~ profit, test.df)

densityplot(~test.df$profit, groups = test.df$Obs, auto.key = TRUE)

plot.roc(test.roc)

dev.off()


## Profit calculation

## Column append to the profit and loss table
ml0$pnl$pred <- trainPred

profits1 <- pnl.calc(ml0$pnl, ml0$folio)

if (!exists("profits0")) {
    profits0 <- profits1
} else {
    profits0 <- rbind(profits0, profits1)
}

