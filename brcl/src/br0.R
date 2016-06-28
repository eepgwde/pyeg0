## weaves
##
## Data simplification
## Identical to the AdultUCI data set.

library("arules")

source("brA0.R")

data("AdultUCI")

sapply(AdultUCI, FUN=function(x) { sum(as.integer(is.na(x))) })

## Preparation: save as CSV from XL
## sed -e 's/," /,"/g'
## to remove leading spaces in text fields.

ppl00 <- read.csv("../bak/CustomerData1.csv", 
                  stringsAsFactors=TRUE, strip.white=TRUE,
                  header=TRUE, na.strings=c("?"))

sapply(ppl00, FUN=function(x) { sum(as.integer(is.na(x))) })

ppl <- ppl00

## Re-assurance they are the same:
stopifnot(all(ppl$age == AdultUCI$age))


## Re-classify the original, 
adult0 <- adult.class0(AdultUCI)

## Copy the column names. 
## Replace the income column
## Order the education column.
## Re-class and compare.
colnames(ppl) <- colnames(adult0)
ppl$income <- adult0$income
ppl$education <- ordered(ppl$education, levels(adult0$education))

ppl0 <- adult.class0(ppl)

all.equal(ppl0, adult0)

## Simplify some column names and then some classes

ppl0 <- adult.capital(ppl0)

ppl0[[ "capital-loss" ]] <- NULL
ppl0[[ "capital-gain" ]] <- NULL

cnames <- colnames(ppl0)
cnames <- gsub("^capital-", "c.", cnames)
cnames <- gsub("^native-", "", cnames)
cnames <- gsub("-per-week", "", cnames)
cnames <- gsub("-", ".", cnames)

colnames(ppl0) <- cnames

ppl0$workclass <- adult.workclass(ppl0$workclass)

ppl0$occupation <- adult.occupation(ppl0$occupation)

ppl0$country <- adult.country(ppl0$country)

ppl0$education <- adult.education(ppl0$education)

ppl0$customer <- ordered(ppl00$customer, labels = c("no", "yes"))

## Because we have an extra income field from the Adult data
## we can use that to help our predictor.

ppl0$in0 <- ! is.na(ppl0$income)

## Usual issues with NA

idxes <- sapply(colnames(ppl0), function(x) { sum(as.integer(is.na(ppl0[[ x ]]))) }, simplify="array", USE.NAMES=FALSE) > 0
adult.na <- colnames(ppl0)[idxes]
adult.na <- adult.na[ adult.na != "income" ]

sapply(adult.na, function(x) sum(as.integer(is.na(ppl0[[ x ]]))))

adult.na0 <- sapply(adult.na, function(x) is.na(ppl0[[x]]), simplify="matrix", USE.NAMES = FALSE)

## All NA
adult.na1 <- which(apply(adult.na0, 1, all))

ppl0 <- ppl0[ - adult.na1, ]

adult.na1 <- which(apply(adult.na0, 1, function(x) { sum(as.integer(x)) >= 2 }))

ppl0 <- ppl0[ - adult.na1, ]

save(ppl0, file="ppl0.dat")

adult.na1 <- which(apply(adult.na0, 1, function(x) { sum(as.integer(x)) > 0 }))

ppl0 <- ppl0[ - adult.na1, ]

save(ppl0, file="ppl0na.dat")



