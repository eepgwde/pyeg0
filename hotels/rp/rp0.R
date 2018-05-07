## weaves
##
## Accessing remote rkdb table for IPv4 lookup to city/country
##
## @note
## See the Makefile for the q/kdb+ address

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}
gc()

library(rkdb)

library(MASS)
library(rpart)
library(rpart.plot)

library(doMC)

registerDoMC(cores = NULL)

options(useFancyQuotes = FALSE) 

## Load up the target given on the command line.

x.args = commandArgs(trailingOnly=TRUE)

if (length(x.args) <= 0) {
    x.args = c("/cache/baks/11/ingrss0/frd0.dat", "smpls", "localhost:4444")
}

src0 <- "tbl00.dat"                       # a default
if (length(x.args) >= 1) {
    src0 <- x.args[1]
}

tgt0 <- "tbl00"                       # a default
if (length(x.args) >= 2) {
    tgt0 <- x.args[2]
}

src1 <- "localhost:5000"                       # a default
if (length(x.args) >= 3) {
    src1 <- x.args[3]
}

## Load file and table

load(src0, envir=.GlobalEnv)

ppl <- get(tgt0)                        # get indirectly
dim(ppl)

## We currently only process IPv4

idxs <- grepl("^[0-9a-fA-F]+:", ppl$remote_addr)

ppl <- ppl[ !idxs, ]

## Connect to q/kdb+

x.qkdb <- unlist(strsplit(src1, ":", fixed=TRUE))
stopifnot(length(x.qkdb) == 2)

h <- open_connection(host=x.qkdb[1], port=x.qkdb[2])

## All the address fields

c0 <- colnames(tbl00)
idx <- grepl("addr", c0)

addrs <- c0[which(idx)]

l0 <- c("193.62.22.98", "193.113.9.162")

ips <- execute(h, ".geoip.str2lcns", l0)

ips <- execute(h, ".geoip.str2lcns", ppl$remote_addr)

## How to write a table remotely
## execute(h, '{ `raddr set x }', ppl$remote_addr)

ips$localecode <- as.factor(ips$localecode)

ppl1 <- cbind(ppl, ips)

table(ppl1$isfraud)

table(ppl1$localecode, ppl1$isfraud)

ppl1[ ppl1$isfraud, c("localecode", "source_address_zip")]


cls0 <- "cwy3-fworks"
cls0 <- unlist(strsplit(cls0, "-"), use.names=TRUE)
scls0 <- paste(c(tgt0, cls0), collapse="-")

if (length(x.args) >= 3) {
    cls0 <- unlist(strsplit(x.args[3], "-"), use.names=TRUE)
    scls0 <- paste(c(tgt0, cls0), collapse="-")
}

print(cls0)


set.seed(br0[["seed"]])                 # helpful for testing

ppl1 <- ppl

df <- ppl[, c("isclm0", "priority")]
df$hipr <- df$priority >= 3.5
table(df[, c("isclm0", "hipr")])
  

## for class models change isclm0 to be a factor - it's prettier to view

ppl1$isclm1 <- factor(ppl1[[ br0[["outcomen"]] ]], labels=c("noclaim", "claim"))

## Build the formula
cls1 <- lapply(cls0, function(x) br0[[x]])
xnam <- unlist(cls1, use.names = FALSE)

## Either isclm1 or outcome1
out0 <- "isclm1 ~ "

fmla <- as.formula(paste(out0, paste(xnam, collapse= "+")))

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
print(br0[["source"]])
print(fit)
sink()

if (1==0) {

    plotcp(fit)

    plot(fit, uniform = TRUE, main = scls0)
    text(fit, use.n = TRUE, all = TRUE, cex = .8)

    rpart.plot(fit, type=1, extra=101, main = scls0)

}

tiff(filename=paste(scls0, "-%03d.tiff", sep=""), 
     bg="transparent", width=1280, height=1024)

plotcp(fit)

plot(fit, uniform = TRUE, main = scls0)
text(fit, use.n = TRUE, all = TRUE, cex = .8)

rpart.plot(fit, type=1, extra=3, varlen=0, fallen.leaves=TRUE, main = scls0)
rpart.plot(fit, type=1, extra=109, varlen=0, digits=5, 
           fallen.leaves=TRUE, main = scls0)

dev.off()

## Save all

save(fit0, ppl1, file="ppl1.dat")

