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
# Not working
# library(rpart.plot)

options(useFancyQuotes = FALSE) 

## Load up the target given on the command line.

args = commandArgs(trailingOnly=TRUE)

## To run by hand in R Studio, change this line

if (length(args) <= 0) {
      args = c("frd0.Rdat", "smpls",  "cs1") # change the last string to one of the frd0$ftres , eg. paym0, cs1
}

src0 <- "frd0.Rdat"                       # a default
if (length(args) >= 1) {
    src0 <- args[1]
}

tgt0 <- "smpls"                       # a default
if (length(args) >= 2) {
    tgt0 <- args[2]
}

cls0 <- "paym0"                       # a default
if (length(args) >= 3) {
  cls0 <- args[3]
}

scls0 <- paste(c(tgt0, cls0), collapse="-")

print(cls0)

load(src0, envir=.GlobalEnv)

ppl <- get(tgt0)                        # get indirectly
dim(ppl)                                

ppl00 <- ppl                            # backup

set.seed(frd0[["seed"]])                 # helpful for testing

ppl1 <- ppl

frd0[["source"]] <- scls0

## for class models change isclm0 to be a factor - it's prettier to view

ppl1$isfrd1 <- factor(ppl1[[ frd0$ftres[["outcomen"]] ]], labels=c("nofraud", "fraud"))

## Build the formula

c0 <- frd0$ftres[[ cls0 ]]
## c0 <- setdiff(x0, c("source_address_zip_check", "total_no_of_seats"))
c0 <- setdiff(x0, c("total_no_of_seats"))

## Either isclm1 or outcome1
out0 <- "isfrd1 ~ "

fmla <- as.formula(paste(out0, paste(c0, collapse= "+")))

## Recursive partition tree voodoo

fit0 <- list()

fit0[["maxcompete"]] <- 12
fit0[["cp"]] <- 0.00005

fit0[["control"]] <- rpart.control(maxcompete=fit0[["maxcompete"]], cp=fit0[["cp"]], 
                                   xval=10, maxdepth=8, surrogatestyle = 1)

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

## find the set of rules you want and copy into this filtering function

## find the 

filter0 <- function(tbl) {
  return(with(tbl, subset(tbl,  avgprice>=15010 & ddaysl< 1.02 )))
}

df0 <- unique(filter0(ppl1))

