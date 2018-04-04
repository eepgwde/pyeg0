## weaves
##
## Visual validation using Recursive Partition Trees.
##
## @note
## Uses older version of R, so no caret.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}
gc()

library(MASS)
library(rpart)
library(rpart.plot)

options(useFancyQuotes = FALSE) 

## Load up the target given on the command line.

x.args = commandArgs(trailingOnly=TRUE)

## To run by hand in R Studio, change this line

if (length(x.args) <= 0) {
    x.args = c("thw0.dat", "noclicks",  "noclicks-classes")
}

src0 <- "thw0.dat"                       # a default
if (length(x.args) >= 1) {
    src0 <- x.args[1]
}

tgt0 <- "noclicks"                       # a default
if (length(x.args) >= 2) {
    tgt0 <- x.args[2]
}

cls0 <- "nums-classes"                       # a default
if (length(x.args) >= 3) {
  cls0 <- x.args[3]
}

scls0 <- paste(tgt0, cls0, sep="-")

print(scls0)

load(src0, envir=.GlobalEnv)

ppl <- get(tgt0)                        # get indirectly
dim(ppl)                                

ppl00 <- ppl                            # backup

set.seed(frd0[["seed"]])                 # helpful for testing

ppl1 <- ppl[ !is.na(ppl$cluster), ]

frd0[["source"]] <- scls0

## Build the formula

c0s <- unlist(strsplit(cls0, "-", fixed=TRUE))

c0 <- unlist(sapply(c0s, function(x) frd0$ftres[[x]], USE.NAMES=FALSE))
c0 <- setdiff(c0, frd0$ftres$discard)

## Either isclm1 or outcome1
out0 <- sprintf("%s ~ ", frd0$ftres$outcomen)

c0 <- setdiff(c0, c("impressions", "tcnv0"))
## out0 <- sprintf("%s ~ ", "acnv0")

fmla <- as.formula(paste(out0, paste(c0, collapse= "+")))

## Recursive partition tree voodoo

fit0 <- list()

fit0[["maxcompete"]] <- 12
fit0[["cp"]] <- 0.00005

fit0[["control"]] <- rpart.control(maxcompete=fit0[["maxcompete"]], cp=fit0[["cp"]], 
                                   xval=10, maxdepth=16, surrogatestyle = 1)

fit <- rpart(fmla, method = "class", control=fit0[["control"]], data = ppl1 )

summary(fit)

printcp(fit)

x.ctr <- 1
x.flnm <- sprintf("%s-%03d.txt", scls0, x.ctr)

sink(x.flnm)
print(frd0[["source"]])
print(fit)
sink()

if (1==0) {

    plotcp(fit)

    plot(fit, uniform = TRUE, main = scls0)
    text(fit, use.n = TRUE, all = TRUE, cex = .8)

    rpart.plot(fit, type=1, extra=101, main = scls0)

}

jpeg(filename=paste(scls0, "-%03d.jpeg", sep=""), 
    width=1280, height=1024)

plotcp(fit)

plot(fit, uniform = TRUE, main = scls0)
text(fit, use.n = TRUE, all = TRUE, cex = .8)

rpart.plot(fit, type=1, extra=3, varlen=0, fallen.leaves=TRUE, main = scls0)
rpart.plot(fit, type=1, extra=109, varlen=0, digits=5, fallen.leaves=TRUE, main = scls0)

dev.off()

## Save all

x.flnm <- sprintf("%s.Rdat", scls0)

save(fit0, fit, ppl1, file=x.flnm)

probs <- predict(fit, ppl1, type="prob")

## To get a set of rules use

print(fit)

## Group by interest
## x1 <- table(pdf$gender, pdf$age, pdf$interest, pdf$cluster)

## pdf1 <- as.data.frame(x1)
## colnames(pdf1) <- c("cluster", "interest", "gender", "age", "freq")

