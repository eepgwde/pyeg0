## weaves
##
## Visual validation
##
## @note
## Uses older version of R, so no caret.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

library(MASS)
library(rpart)

library(doMC)

registerDoMC(cores = NULL)

options(useFancyQuotes = FALSE) 

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

load("src/ppl0.dat", envir=.GlobalEnv)
ppl00 <- ppl0

fit <- rpart(customer ~ age + income + education,
             method = "class", data = ppl0[ppl0$in0,] )

summary(fit)

printcp(fit)

plotcp(fit)

plot(fit, uniform = TRUE, main = "with income")
text(fit, use.n = TRUE, all = TRUE, cex = .8)


ppl1 <- ppl0[ppl0$in0,]
x.names <- ! colnames(ppl0) %in% c("income", "in0")

ppl1 <- ppl0[, colnames(ppl0)[x.names] ]


fit <- rpart(customer ~ .,
             method = "class", data = ppl1 )

summary(fit)

printcp(fit)

plotcp(fit)

plot(fit, uniform = TRUE, main = "without income")
text(fit, use.n = TRUE, all = TRUE, cex = .8)



