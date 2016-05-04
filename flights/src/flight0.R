### weaves

## Following the caret vignette.

###################################################
### code chunk number 1: loadLibs
###################################################
library(MASS)
library(caret)
library(mlbench)
library(pROC)
library(pls)

options(useFancyQuotes = FALSE) 

# Accounting info.
getInfo <- function(what = "Suggests")
{
  text <- packageDescription("caret")[what][[1]]
  text <- gsub("\n", ", ", text, fixed = TRUE)
  text <- gsub(">=", "$\\\\ge$", text, fixed = TRUE)
  eachPkg <- strsplit(text, ", ", fixed = TRUE)[[1]]
  eachPkg <- gsub(",", "", eachPkg, fixed = TRUE)
  # out <- paste("\\\\pkg{", eachPkg[order(tolower(eachPkg))], "}", sep = "")
  # paste(out, collapse = ", ")
  length(eachPkg)
}

### project-specific: begin
## Set-seed, load original CSV file and do some simple-cleaning
## Various datasets 

set.seed(101)                           # helpful for testing

flight <- read.csv("../bak/flight.csv")

# Backup
flight.raw <- flight

# Some additions

flight$DEPSPOKE <- flight$DEPGRP == "Spoke"
flight$ARRSPOKE <- flight$ARRGRP == "Spoke"

# And some deletions

t.cols <- colnames(flight)

t.drops <- t.cols[grep("^RANK*", t.cols)]
t.drops <- c(t.drops, t.cols[grep("^(ARR|DEP)GRP$", t.cols)])
t.drops <- c(t.drops, "D80THPCTL")

flight <- flight[ , t.cols[!(t.cols %in% t.drops)] ]

## Let's do the flight duration logic see the flight logic the notes.

flight$xDURN <- flight$SARRHR - flight$SDEPHR
flight$xHNGR <- flight$xDURN < 0

## I don't think there is any hangaring. I have to clean this up.

## Max flight time is 8 hours for the positives, but red-eyes can
## take longer

hr.wrap <- function(d0, a0) {
    t0 <- a0 - d0
    if (t0 >= 0) return(t0)
    t0 <- 24 - d0
    t0 <- t0 + a0
    return(t0)
}

flight$xDURN2 <- apply(flight[,c("SDEPHR", "SARRHR")], 1, 
                       function(y) hr.wrap(y['SDEPHR'], y['SARRHR']))

flight[which(flight$xDURN2 != flight$xDURN), c("SDEPHR", "SARRHR", "xDURN","xDURN2", "xHNGR")]
t.cols <- colnames(flight)

t.drops <- c("SARRHR", "xDURN")
flight <- flight[ , t.cols[!(t.cols %in% t.drops)] ]

## Backup

flight00 <- flight

# And we drop many, many rows because R cannot take large datasets.
# These are the ranges we have been asked to predict on.

flight <- flight[flight$AVGLOFATC >= 3.1 & flight$AVGLOFATC <= 4.4,]

## Take another copy - this is all we need as the training/prediction
## set.

flight1 <- flight

## T1
# Try to drop D00 and just use LEGTYPE

flight$D00 <- NULL
legtyped <- flight

## T2
# Try to drop LEGTYPE and use D00.

flight <- flight1
flight$LEGTYPE <- NULL

d00ed <- flight

## Data insights
                                        #
## Using the D00 and LEGTYPE dataset, I have this concern that D00 is
## a derived probit and we should ignore it.

flight <- flight1

## So something is defining the behaviour.

## Try to simplify structure

head(model.matrix(LEGTYPE ~ ., data = flight))

dummies <- dummyVars(LEGTYPE ~ ., data = flight)
flight.dum <- predict(dummies, newdata = flight)

## It's too big to use, but useful for inspection.

### Numeric variables

## Check some more correlations, I haven't scaled yet.

x1 <- as.data.frame(as.matrix(sapply(flight, class)))

flight.num <- flight[,names(x1[which(x1$V1 %in% c("numeric", "integer")),])]

flight.nzv <- nearZeroVar(flight.num, saveMetrics = TRUE)
flight.nzv

flight.cor <- cor(flight.num, use = "pairwise.complete.obs")

highlyCorDescr <- findCorrelation(flight.cor, cutoff = .75, verbose=TRUE)

# Which tells me that row 1, column is very highly correlated to AVGSQ.

