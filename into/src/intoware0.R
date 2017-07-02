### weaves

## Processing for flights data.

## Following the caret vignette.

rm(list=ls())

m.name <- "Within.Spec"

m.name0 <- Sys.getenv('X_OUTCOME')
if (nchar(m.name0)>0) {
    m.name <- m.name0
    rm('m.name0')
}
print(m.name)

###################################################
### code chunk number 1: loadLibs
###################################################
library(doMC)
registerDoMC(cores = 4)

library(MASS)
library(caret)
library(mlbench)
library(pROC)
library(pls)

library(Rweaves1)
library(corrplot)

options(useFancyQuotes = FALSE) 

# Accounting info.
getInfo <- function(what = "Suggests")
{
  text <- packageDescription("caret")[what][[1]]
  text <- gsub("\n", ", ", text, fixed = TRUE)
  text <- gsub(">=", "$\\\\ge$", text, fixed = TRUE)
  eachPkg <- strsplit(text, ", ", fixed = TRUE)[[1]]
  eachPkg <- gsub(",", "", eachPkg, fixed = TRUE)
  out <- paste("\\\\pkg{", eachPkg[order(tolower(eachPkg))], "}", sep = "")
  paste(out, collapse = ", ")
  length(eachPkg)
  out
}

## Setup trace and imaging.

m.trace <- "trace.flag"
if (!file.exists(m.trace)) {
    rm("m.trace")
}

m.img <- "jpeg.flag"
if (!file.exists(m.img)) {
    rm("m.img")
}

print(sprintf("trace: %d", exists("m.trace")))

if (exists("m.trace")) getInfo()

### project-specific: begin
## Set-seed, load original CSV file, order it
## and do some simple-cleaning
## Various datasets 

seed.mine = 107
set.seed(seed.mine)                     # helpful for testing

into0 <- read.csv("../bak/intoware.csv")

into0$Date <- as.Date(as.character(into0$Date), format="%d/%m/%Y")
into0$wday <- weekdays(into0$Date)

c(max(into0$Date), min(into0$Date))

into0 <- into0[ order(into0$Date), ]

## Classing and some indicators
source("intoware2.R")

## Dropping non-indicators

m.names <- colnames(into0)[grepl("^i[0-9]\\.", colnames(into0))]

m.names <- unique(gsub("^i[0-9]+\\.", "", m.names))

into0 <- into0[, setdiff(colnames(into0), m.names)]

## Meterological
source("intoware1.R")

## And check.
m.names <- colnames(into0)[!class.columns(into0, cls0="POSIX")]
tallies <- sapply(m.names, function(x) table(into0[[ x ]], useNA="ifany"))
if (exists("m.trace")) tallies

if (exists("m.trace")) View(into0)

## Dropped columns

## Zero variance

t0 <- sapply(tallies, length)
m.names <- names(which(t0 == 1))
m.names <- setdiff(colnames(into0), m.names)
t0 <- NULL

into0 <- into0[, m.names]

# Using generic w list for my caret methods 

w <- list()

w[['raw']] <- into0

w[['df']] <- w[['raw']]

rm("into0")

w[['outcome-name']] <- m.name

w[['outcome']] <- w[['df']][[ w[['outcome-name']] ]]
# w[['df']][, w[['outcome-name']] ] <- NULL

## Caret operations.

w <- caret.zv(w)

w[['n']] <- caret.filter(w)

if (exists("m.trace")) {
    save(w, file="w.RData")
    load("w.RData", .GlobalEnv)
}

## NA operations

w[['n']] <- caret.numeric(w)

m0 <- scale(as.matrix(w[['n']]))

## annoying NA should be gone.
## cor <- cor(m0, use = "pairwise.complete.obs")

c0 <- cor(m0, use = "pairwise.complete.obs")

w[['fail-corr']] <- caret.cor0(c0)
w[['fail-corr']]

## No NA's in the correlation matrix.
stopifnot(!any(grepl("NA's", names(summary(c0[upper.tri(c0)])))))
              
if (exists("m.img"))
    jpeg(width=1024, height=1024, filename = "corr-%02d.jpg")

corrplot(c0, method="circle", type="lower", order="alphabet")

corrplot(c0, method="circle", type="lower", order="hclust")

if (exists("m.img"))
    dev.off()

## Remove highly correlated components.

sink("into0-corr.txt")
w[['hi-corr']] <- findCorrelation(c0, cutoff = 0.99, verbose=TRUE, names=TRUE)
sink()

if (exists("m.trace")) {
    invisible(lapply(colnames(c0), write, "into0-corr.txt", append=TRUE))
}

## Prefer yday over Date
w[['hi-corr']] <- gsub("yday", "Date", w[['hi-corr']])
w[['hi-corr']]

## Remove highly-correlated components.
m.names <- setdiff(colnames(w[['df']]), w[['hi-corr']])

w[['df']] <- w[['df']][, m.names]

w[['n']] <- caret.filter(w)
w[['n']] <- caret.numeric(w)

## And the outcome
w[['n']] <- w[['n']][, setdiff(colnames(w[['n']]), w[['outcome-name']]) ]

save(w, file="w.RData")
load("w.RData", .GlobalEnv)

stopifnot(!exists("m.trace"))

