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
library(Rweaves1)

library(doMC)

registerDoMC(cores = NULL)

options(useFancyQuotes = FALSE) 

## Load up the target given on the command line.

args = commandArgs(trailingOnly=TRUE)

if (length(args) <= 0) {
    args = c("/misc/build/0/hcc/cache/out/xe2c.csv", "uni0", "modelq3")
}

tgt0 <- ""                       # a default
if (length(args) >= 1) {
    tgt0 <- args[1]
}

e2c <- read.csv(tgt0, 
                stringsAsFactors=TRUE, strip.white=TRUE,
                header=TRUE, na.strings=c(""))


pdf <- e2c[, ! colnames(e2c) %in% c("cwy0")]

jpeg(filename=paste("rp2", "-%03d.jpeg", sep=""), 
     width=1280, height=1024)

set.seed(107)
r0 <- cluster.make0(pdf, plot0=TRUE, title="Claims clusters")

dev.off()

pdf <- r0[["best"]]

zz <- "rp2.txt"

zz <- file(zz, open = "wt")
sink(zz)

cat("\n\n")
cat("most populated clusters, descending order\n")
sort(table(pdf$cluster), decreasing=TRUE)

cat("\nBy road priority\n")
table(pdf$cluster, pdf$pri)

cat("\nBy prior history - clm is no prior defects, enquiries or major works\n")
table(pdf$cluster, pdf$type1)

cat("\nBy number of other assets with same asset prefix\n")
table(pdf$cluster, pdf$nassets)

cat("\nBy log of distance\n")
table(pdf$cluster, pdf$distance)

cat("\nBy log of model traffic\n")
table(pdf$cluster, pdf$mtraffic)

pdf <- r0[["source"]]

cat("\n\n")
cat("all clusters\n")
sort(table(pdf$cluster), decreasing=TRUE)

cat("\nBy road priority\n")
table(pdf$cluster, pdf$pri)

cat("\nBy prior history - clm is no prior defects, enquiries or major works\n")
table(pdf$cluster, pdf$type1)

## table(pdf$cluster, pdf$lanes)

cat("\nBy number of other assets with same asset prefix\n")
table(pdf$cluster, pdf$nassets)

cat("\nBy log of distance\n")
table(pdf$cluster, pdf$distance)

cat("\nBy log of model traffic\n")
table(pdf$cluster, pdf$mtraffic)

sink()

## Save all

# save(fit0, ppl1, file="ppl1.dat")

