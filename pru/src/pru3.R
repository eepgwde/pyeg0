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

x0 <- folios.in[ folios.in$type0 == "h", ]
x0 <- unstack(x0, x2tp ~ Categories)

## The last row is their prediction, we'll be using this to boost-by-hand
## We store the last row in test and the rest in train.
## Find the least volatile and begin with that.

th$test <- x0[length(x0),]

th$train <- x0[-nrow(x0),]

th$sd <- stack(sapply(th$train,sd))
th$sd <- th$sd[order(th$sd$values),]

paste(c("train-order: ", as.character(th$sd$ind)), collapse = "-> ")




ppl00 <- ppl0

sapply(ppl00, FUN=function(x) { sum(as.integer(is.na(x))) })

### My experiment control parameters will be ml0

ml0 <- list()

### Sizing up
## 
ml0$lastin <- tail(which(ppl0$in0), 1)

### Prescience: variables
## Name of the variable, the values, the "true" value for a confusion matrix.
ml0$outcomen <- "customer"
ml0$outcomes <- ppl0[[ ml0$outcomen ]]
ml0$outcome0 <- levels(ml0$outcomes)[-1]

ml0$prescient <- c("income")
ml0$ignore <- c("in0")

x.removals <- union(ml0$prescient, ml0$ignore)

## we keep the outcome variable in to help the imputation.

ppl <- ppl0[,setdiff(colnames(ppl0), x.removals)]

factors.numeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)], as.integer))

df0 <- factors.numeric(ppl)

## Centering, scaling and imputing

## This uses a general script. It drops columns. The stop conditions
## tests if we have accidentally dropped some rows.

## This will add extra levels.

sapply(ppl, function(x) sum(as.integer(is.na(x))))

# Function in a script: pass df0 and receive df1
source("br3a.R")

stopifnot(dim(df0)[1] == dim(df1)[1])

ppl1 <- df1

save(ppl1, ml0, file="ppl1.dat")

