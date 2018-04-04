## weaves
##
## Data analysis
## Herts Carriageways. 

## Get started with a load and save to binary.

library(zoo)
library(dplyr)
library(lubridate)

x.args = commandArgs(trailingOnly=TRUE)

if (length(x.args) <= 0) {
    x.args <- c("out/xncas1w.csv", "-triage-cat1")
}

tgt0 <- "out/xncas1.csv"
if (length(x.args) >= 1) {
    tgt0 <- x.args[1]
}

rgm0 <- NULL
if (length(x.args) >= 2) {
    rgm0 <- x.args[2]
}

scls0 <- "ncas1"

hcc00 <- read.csv(tgt0, 
                  stringsAsFactors=FALSE, strip.white=TRUE,
                  header=TRUE, na.strings=c(""))

hcc00$dt0 <- as.Date(hcc00$dt0)

x.remove <- c("superseded", "unsuperseded", "mm0")

hcc <- hcc00[, !(colnames(hcc00) %in% x.remove) ]

## Now we want to split by policy date

rgms <- read.csv("regime.csv", 
                  stringsAsFactors=TRUE, strip.white=TRUE,
                 header=TRUE, na.strings=c(""))

rgms$dt0 <- as.Date(rgms$dt0)

## use a while loop for the break.
while (!is.null(rgm0)) {

    x.prior <- substr(rgm0, 1, 1) == "-"

    rgm1 <- gsub("^[^a-z]+", "", rgm0)

    if (! any(rgms$regime == rgm1)) {
        warning("bad regime: ", rgm1)
        break;
    }

    hcc <- hcc[ order(hcc$dt0), ]

    dt1 <- rgms[ rgms$regime == rgm1, "dt0"]

    prior0 <- subset(hcc, dt0 <= dt1)
    next0 <- subset(hcc, dt0 > dt1)

    rows0 <- min(dim(prior0)[1], dim(next0)[1])
    
    if (x.prior) {
        hcc <<- tail(prior0, n=rows0)
    } else {
        hcc <<- head(next0, n=rows0)
    }

    break
}

## Clear away any NAs

v0 <- lapply(colnames(hcc), function(x) { if (!any(is.na(hcc[[x]]))) return(NULL);
    idx <- is.na(hcc[[x]]);
    hcc[[x]][idx] <<- 1; return(NULL) });

which(is.na(hcc))

m1 <- as.matrix(hcc[, !(colnames(hcc) %in% "dt0") ])

ccf0 <- function(tbl, pairs) {
    ccf(tbl[, pairs[1]], tbl[, pairs[2]], main=paste(pairs, collapse=" "), na.action=na.pass)
}

## Use decompose for seasonal plots

data1 <- hcc %>% select(dt0, claims) %>% 
    mutate(yr0=as.integer(year(dt0)), month0=as.integer(month(dt0))) %>%
    select(dt0, yr0, month0, claims)

data2 <- ts(data1$claims, 
            start=c(data1$yr0[1], data1$month0[1]), 
            end=c(data1$yr0[nrow(data1)], data1$month0[nrow(data1)]), 
            frequency=12)

claims0 <- decompose(data2)


data1 <- hcc %>% select(dt0, enqs) %>% 
    mutate(yr0=as.integer(year(dt0)), month0=as.integer(month(dt0))) %>%
    select(dt0, yr0, month0, enqs)

data2 <- ts(data1$enqs, 
            start=c(data1$yr0[1], data1$month0[1]), 
            end=c(data1$yr0[nrow(data1)], data1$month0[nrow(data1)]), 
            frequency=12)

enqs0 <- decompose(data2)


jpeg(filename=paste(scls0, "-%03d.jpeg", sep=""), 
     width=1024, height=768)

plot(claims0)
title("Claims")

plot(enqs0)
title("Enquiries")

## hope: repudiations lead claims

x.pairs <- rev(c("claims", "repudns"))
ccf0(hcc, x.pairs)

### enqs to repudns

x.pairs <- c("enqs", "repudns")
z0 <- zoo(hcc[, x.pairs])
          
ccf0(z0, x.pairs)

dev.off()

save(hcc, file="hcc00.dat")


