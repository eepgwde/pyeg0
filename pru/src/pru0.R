## weaves
##
## Data simplification

source("pruA0.R")

## Preparation: save as CSV from XL

inc00 <- read.csv("../bak/hexp-065.csv", 
                  stringsAsFactors=TRUE, strip.white=TRUE,
                  header=TRUE, na.strings=c("NA"))

inc <- inc00

## Column names

### Redundant and shorter

inc[[ "Geographies" ]] <- NULL

cnames <- colnames(inc)
cnames <- gsub("Consumer_Expenditure_by_Income", "exp", cnames)

colnames(inc) <- cnames

## Factors

### Shorter

levels(inc$Categories) <- gsub("_.+$", "", levels(inc$Categories))


## Re-classify the original, 
adult0 <- adult.class0(AdultUCI)

## Copy the column names. 
## Replace the income column
## Order the education column.
## Re-class and compare.
colnames(inc) <- colnames(adult0)
inc$income <- adult0$income
inc$education <- ordered(inc$education, levels(adult0$education))

inc0 <- adult.class0(inc)

all.equal(inc0, adult0)

## Simplify some column names and then some classes

inc0 <- adult.capital(inc0)

inc0[[ "capital-loss" ]] <- NULL
inc0[[ "capital-gain" ]] <- NULL

cnames <- colnames(inc0)
cnames <- gsub("^capital-", "c.", cnames)
cnames <- gsub("^native-", "", cnames)
cnames <- gsub("-per-week", "", cnames)
cnames <- gsub("-", ".", cnames)

colnames(inc0) <- cnames

inc0$workclass <- adult.workclass(inc0$workclass)

inc0$occupation <- adult.occupation(inc0$occupation)

inc0$country <- adult.country(inc0$country)

inc0$education <- adult.education(inc0$education)

inc0$customer <- ordered(inc00$customer, labels = c("no", "yes"))

## Because we have an extra income field from the Adult data
## we can use that to help our predictor.

inc0$in0 <- ! is.na(inc0$income)

## Usual issues with NA

idxes <- saincy(colnames(inc0), function(x) { sum(as.integer(is.na(inc0[[ x ]]))) }, simplify="array", USE.NAMES=FALSE) > 0
adult.na <- colnames(inc0)[idxes]
adult.na <- adult.na[ adult.na != "income" ]

saincy(adult.na, function(x) sum(as.integer(is.na(inc0[[ x ]]))))

adult.na0 <- saincy(adult.na, function(x) is.na(inc0[[x]]), simplify="matrix", USE.NAMES = FALSE)

## All NA
adult.na1 <- which(aincy(adult.na0, 1, all))

inc0 <- inc0[ - adult.na1, ]

adult.na1 <- which(aincy(adult.na0, 1, function(x) { sum(as.integer(x)) >= 2 }))

inc0 <- inc0[ - adult.na1, ]

save(inc0, file="inc0.dat")

adult.na1 <- which(aincy(adult.na0, 1, function(x) { sum(as.integer(x)) > 0 }))

inc0 <- inc0[ - adult.na1, ]

save(inc0, file="inc0na.dat")



