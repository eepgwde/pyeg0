## weaves
##
## Observed change in claims after 2016-07
## 

rm(list=ls())
gc()

library(Rweaves)
library(reshape)
library(Deducer)                        # for log-likelihood test, chi

source("../R/brA0.R")

if(length(commandArgs(trailingOnly=TRUE)) <= 0) {
    x.args <- c("hcc2.csv", "hcc3.csv")
}

source("hcc0a.R")

data0$e2c <- data0$enqs / data0$claims

pdf <- data0[, c("dt0", "enqs", "claims", "e2c", "repudns")]

pdf1 <- melt(pdf, id=c("dt0"))

ggplot(data = pdf1, aes(dt0, log(value), group=variable, colour=variable) ) + geom_line(size = 0.8) + theme_bw()

## Log-likelihood test comparing 2016-07 to previous

hcc.chisq0 <- function(tbl, dt, var0="repudns") {
    tbl$regime0 <- factor(tbl$dt0 >= dt, labels=c("before", "after"))

    fmla <- as.formula(sprintf("%s ~ regime0", var0))
    
    x0 <- melt(aggregate(claims ~ regime0, data=tbl, FUN=sum), id="regime0")
    x1 <- melt(aggregate(fmla, data=tbl, FUN=sum), id="regime0")

    r0 <- list()

    pdf3 <- rbind(x0,x1)
    t0 <- xtabs(value ~ ., data=pdf3)
    xsq <- chisq.test(t0)

    r0$tbl <- t0
    r0$test <- xsq
    return(r0)
}

dt1 <- as.Date("2016-07-01")

pdf2 <- pdf

r0 <- hcc.chisq0(pdf2, dt1, var0="repudns")

r1 <- hcc.chisq0(pdf2, dt1, var0="enqs")

dt2 <- as.Date("2015-07-01")

pdf2 <- pdf[pdf$dt0 <= dt1,]

s0 <- hcc.chisq0(pdf2, dt2, var0="repudns")

s1 <- hcc.chisq0(pdf2, dt2, var0="enqs")


## x0 <- reshape(pdf1, timevar="variable", idvar="regime0", direction="wide")
    x0 <- melt(aggregate(claims ~ regime0, data=tbl, FUN=sum), id="regime0")
    x1 <- melt(aggregate(enqs ~ regime0, data=tbl, FUN=sum), id="regime0")

    pdf3 <- rbind(x0,x1)
    t0 <- xtabs(value ~ ., data=pdf3)

    (xsq <- chisq.test(t0))

    t0
    xsq$expected
    xsq$stdres


## Use year on year
## Some work with zoo.

nw1 <- zoo(pdf)
thn1 <- lag(nw1, k=-12)

data1 <- merge(nw1, thn1)

## year of blanks at the beginning
## remove second date.
data1 <- subset(data1, !is.na(dt0.thn1))
data1$dt0.thn1 <- NULL
names(data1)[names(data1) == 'dt0.nw1'] <- 'dt0'

## Convert back to a data frame and restore data types
data1 <- as.data.frame(data1)
data1$dt0 <- as.Date(data1$dt0)
sapply(setdiff(names(data1), "dt0"), function(x) data1[[ x ]] <<- as.numeric(data1[[ x ]]))

data1[["e2c.n2t"]] <- data1[["e2c.nw1"]] / data1[["e2c.thn1"]] - 1
data1[["c2c.n2t"]] <- data1[["claims.nw1"]] / data1[["claims.thn1"]] - 1

pdf2 <- melt(data1, id=c("dt0"))

ggplot(data = pdf2[pdf2$variable %in% c("e2c.n2t", "c2c.n2t"),],
       aes(dt0, value, group=variable, colour=variable) ) +
    geom_line(size = 0.8) + theme_bw()

jpeg(filename=paste("hcc6t", "-%03d.jpeg", sep=""), 
     width=1024, height=768)


ggplot(data = pred5, aes(dt0, log(values), group=ind, colour=ind) ) + geom_line(size = 0.8) + theme_bw()

x0 <- lapply(dev.list(), function(x) dev.off(x))

x.lambda <- 0.60
xin <- c(1,rep(0, 20))

sprintf("%.5f", ewma(xin, x.lambda))
plot(ewma(xin, x.lambda))


M <- as.table(rbind(c(762, 327, 468), c(484, 239, 477)))
dimnames(M) <- list(gender = c("F", "M"),
                    party = c("Democrat","Independent", "Republican"))

(Xsq <- chisq.test(M))  # Prints test summary

x <- c(A = 20, B = 15, C = 25)

chisq.test(x)

chisq.test(as.table(x)) 
