## weaves
##
## Machine learning preparation.
## Uses a binary data file of q/kdb+ ticks, generated technicals and
## trading signals.
##
## The input data was lagged by q/kdb+, so no need to lag it here.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

library(MASS)
library(caret)
library(fTrading)                       # for EWMA

library(doMC)
registerDoMC(cores = 4)

options(useFancyQuotes = FALSE) 

## Clear all away: very important if you re-use names in
## functions.

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

load("folios-in.dat", envir=.GlobalEnv)

## Predict a proportion of the total for each category.
## Stash intermediate results in th.

th <- list()

## @note
## It's difficult to choose between using the value or the proportion.
x0 <- folios.in[ folios.in$type0 == "h", ]
x0 <- unstack(x0, x2tp ~ Categories)

## The last row is their prediction, we'll be using this to boost-by-hand
## We store the last row in test and the rest in train.
## Find the least volatile and begin with that.

th$test <- x0[length(x0),]
th$train <- x0[-nrow(x0),]

th$sd <- stack(sapply(th$train,sd))
th$sd <- th$sd[order(th$sd$values),]
th$order0 <- as.character(th$sd$ind)

## Train with the whole set for this methodology
th$train <- x0

paste(c("train-order: ", th$order0), collapse = "-> ")

df1 <- th$train

## Machine learning parameters
ml0 <- list()
ml0$window0 <- 5
ml0$factor0 <- th$order0[1]

fitControl <- trainControl(## timeslicing
    initialWindow = ml0$window0,
    horizon = 1,
    fixedWindow = FALSE,
    method = "timeslice",
    savePredictions = TRUE)

## @note
## Weightings: EWMA makes no difference
x.samples <- nrow(df1)

x.ewma <- EWMA(c(1, rep(0,x.samples-1)), lambda = 0.050, startup = 1)
x.weights <- rev(x.ewma) / sum(x.ewma)

## Or just
## x.weights <- rep(1, x.samples)

ml0$fmla <- as.formula(paste(ml0$factor0, "~ ."))

set.seed(seed.mine)
modelFit1 <- train(ml0$fmla, data = df1,
                   method = "pls",
                   preProc = c("center", "scale"),
                   weights = x.weights,
                   trControl = fitControl)
modelFit1

predict(modelFit1, df1)

modelImp <- varImp(modelFit1, scale = FALSE)
plot(modelImp, top = min(20, length(colnames(df1))))

plot.ts(ts(data.frame(pred=predict(modelFit1, df1),obs=th$train[[ ml0$factor0 ]])), 
        plot.type="multiple")



