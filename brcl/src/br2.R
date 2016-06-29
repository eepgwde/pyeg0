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

ppl0 <- ppl0[ppl0$in0, c("age", "workclass", "education", "occupation", "customer")]

y0 <- ppl0$customer
ppl0$customer <- NULL

library(AppliedPredictiveModeling)

jpeg(filename=paste("feature", "%03d.jpeg", sep=""), 
     width=1024, height=768)

transparentTheme(trans = 0.9)
featurePlot(x = ppl0, y = y0,
            plot = "pairs",
            auto.key = list(columns = 3))

factors.numeric <- function(d) modifyList(d, lapply(d[, sapply(d, is.factor)], as.integer))

df0 <- factors.numeric(ppl0)


featurePlot(x = df0, y = y0,
            plot = "density",
            scales = list(x = list(relation="free"),
                y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            layout = c(4,1),
            auto.key = list(columns = 3))

dev.off()
