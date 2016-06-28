## weaves
##
## Visual validation
##

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

featurePlot(x = ppl0, y = ppl0$customer,
            plot = "pairs",
            auto.key = list(columns = 3))

featurePlot(x = ppl0, y = ppl0$customer,
            plot = "density",
            scales = list(x = list(relation="free"),
                y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            auto.key = list(columns = 3))

