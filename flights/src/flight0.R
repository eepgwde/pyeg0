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
flight0 <- flight

# Some additions

flight$DEPSPOKE <- flight$DEPGRP == "Spoke"
flight$ARRSPOKE <- flight$ARRGRP == "Spoke"

# And some deletions

t.cols <- colnames(flight)

t.drops <- t.cols[grep("^RANK*", t.cols)]
t.drops <- c(t.drops, t.cols[grep("^(ARR|DEP)GRP$", t.cols)])
t.drops <- c(t.drops, "D80THPCTL")

flight <- flight[ , t.cols[!(t.cols %in% t.drops)] ]
flight00 <- flight

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

## Data insights
                                        #
## Using the big dataset, I have this concern that D00 is a derived
## probit and we should ignore it.

flight <- flight1

t.cols <- colnames(flight)

### Interpreter paste-ins for file 

## jpeg(width = 640, height = 640)
## plot())
## dev.off()

## Look at some plots for the numeric performance metrics AVG and, by
## chance I chose, AVAILBUCKET, which is at the end.

## This is more data validation. D00 must partition all parameters
## cleanly.

t.cols0 <- t.cols[grep("^AV.)*", t.cols)]
t.cols0 <- append("D00", t.cols0)

featurePlot(x = flight[, t.cols0],
            y = flight$LEGTYPE,
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = length(t.cols0) - 1))

## see d00vsAV

## See some density plots.
t.cols1 <- head(t.cols0, -1)
transparentTheme(trans = .9)
featurePlot(x = flight[, t.cols1],
            y = flight$LEGTYPE,
            plot = "density",
            scales = list(x = list(relation="free"),
                          y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            layout = c(length(t.cols1), 1),
            auto.key = list(columns = length(t.cols1)-1))

## Not very distinct partitioning. AVGSQ is most distinct.

## Correlations are not good for this subset.
library(corrgram)
corrgram(flight[, t.cols1], 
         abs = TRUE, 
         lower.panel=panel.shade, upper.panel=panel.pie,
         diag.panel=panel.minmax, text.panel=panel.txt)

corrplot::corrplot(cor(flight[, t.cols1],
                       use="pairwise.complete.obs"),
                   method="number")

## So something is defining the behaviour.

## Try to simplify structure

head(model.matrix(LEGTYPE ~ ., data = flight))

dummies <- dummyVars(LEGTYPE ~ ., data = flight)
head(predict(dummies, newdata = flight))

## It's too big to use, but useful for inspection.

## But very difficult: too many airports, too many aircraft.

plot(table(flight00$SKDDEPSTA))

plot(table(flight00$SKDARRSTA))

plot(density(as.numeric(flight00$SKDARRSTA)))

plot(table(flight00$SKDEQP))

## Things you notice. 

## AVGSKDAVAIL is related to AVAILBUCKET, but AVAILBUCKET is complete

## AVGLOFATC is zero at times? Must mean direct flight?

## Definitely a strong correlation to time of day, just by eye.

## I think this is time series data! departure < arrive unless
## hangared for the night or a very short flight.

## For the big data set, we have only 41 flights that arrive before
## they leave, some are very short flights, aargh! three types in all.

dim(flight00[which(flight00$SARRHR < flight00$SDEPHR), 
             c("SARRHR", "SDEPHR")])

## The flight duration is not related to AVGLOFATC, eg. Rio to Sao
## Paulo is less than an hour, ISTR, but it would be translantic from
## London

flight00[which(flight00$SARRHR == flight00$SDEPHR), 
         c("SARRHR", "SDEPHR", "AVGLOFATC")]

## Try some tree inspection

tree.f1 <- rpart(LEGTYPE ~ SDEPHR + SARRHR, method="class", data=flight1)

printcp(tree.f1)
summary(tree.f1)

plotcp(tree.f1)

plot(tree.f1, uniform=TRUE,
     main="dep and arrive")
text(tree.f1, use.n=TRUE, all=TRUE, cex=.8)
