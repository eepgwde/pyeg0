### weaves

# Following the caret vignette.

###################################################
### code chunk number 1: loadLibs
###################################################
library(MASS)
library(caret)
library(mlbench)
data(Sonar)
library(pROC)
library(pls)
options(useFancyQuotes = FALSE) 
getInfo <- function(what = "Suggests")
{
  text <- packageDescription("caret")[what][[1]]
  text <- gsub("\n", ", ", text, fixed = TRUE)
  text <- gsub(">=", "$\\\\ge$", text, fixed = TRUE)
  eachPkg <- strsplit(text, ", ", fixed = TRUE)[[1]]
  eachPkg <- gsub(",", "", eachPkg, fixed = TRUE)
  #out <- paste("\\\\pkg{", eachPkg[order(tolower(eachPkg))], "}", sep = "")
  #paste(out, collapse = ", ")
  length(eachPkg)
}

# Load caret - CART based training and ML toolkit.

library(caret)
library(mlbench)

# Load original CSV file

set.seed(101)
flight <- read.csv("W:/walter.eaves/research/flight.csv")

# Backup
flight0 <- flight

# Some additions

flight$DEPSPOKE <- flight$DEPGRP == "Spoke"
flight$ARRSPOKE <- flight$ARRGRP == "Spoke"

# And some deletions

t.cols <- colnames(flight)

t.drops <- t.cols[grep("^RANK*", t.cols)]
t.drops <- c(t.drops, t.cols[grep("^SKD(ARR|DEP)STA$", t.cols)])
t.drops <- c(t.drops, "D80THPCTL")

flight <- flight[ , t.cols[!(t.cols %in% t.drops)] ]

# And we drop many, many rows because R cannot take large datasets.
# These are the ranges we have been asked to predict on.

flight <- flight[flight$AVGLOFATC >= 3.1 & flight$AVGLOFATC <= 4.4,]

## Take another copy

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

## Try Neural Net

t.cols <- colnames(legtyped)
form.0 <- paste(t.cols[!(t.cols %in% "LEGTYPE")], collapse=' + ')
form.0 <- paste("LEGTYPE", form.0, sep = " ~ ")
form.0 <- as.formula(form.0)

legtyped.mdl <- neuralnet::neuralnet(form.0, data=legtyped, hidden=10)


createDataPartition(d00ed)
