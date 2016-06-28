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

load("ppl0.dat", envir=.GlobalEnv)
ppl00 <- ppl0

### My experiment control parameters will be ml0

ml0 <- list()

### Sizing up
## 
ml0$lastin <- tail(which(ppl0$in0), 1)

### Prescience: variables

ml0$outcomen <- "customer"
ml0$outcomes <- ppl0[[ ml0$outcomen ]]

ml0$prescient <- c("income")
ml0$ignore <- c("in0")

x.removals <- union(ml0$prescient, ml0$ignore)
x.removals <- union(x.removals, ml0$outcomen)

ppl <- ppl0[,setdiff(colnames(ppl0), x.removals)]

factors.numeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)], as.numeric))

df0 <- factors.numeric(ppl)

## Imputing
## 

# Function in a script: pass df0 and receive df1
source("br3a.R")

stopifnot(dim(df0)[1] == dim(df1)[1])

ppl1 <- df1

save(ppl1, ml0, file="ppl1.dat")

