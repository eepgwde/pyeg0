## weaves
##
## Data analysis: look and feel
## Similar to the AdultUCI data set.


library("arules")

source("brA0.R")

data("AdultUCI")

## Preparation: save as CSV from XL
## sed -e 's/," /,"/g'
## to remove leading spaces in text fields.

ppl00 <- read.csv("../bak/CustomerData1.csv", 
                stringsAsFactors=TRUE, strip.white=TRUE,
                header=TRUE, na.strings=c("?"))

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

## More simplification

cnames <- colnames(ppl0)
cnames <- gsub("^capital-", "c.", cnames)
cnames <- gsub("^native-", "", cnames)
cnames <- gsub("-per-week", "", cnames)
cnames <- gsub("-", ".", cnames)

colnames(ppl0) <- cnames

ppl0$workclass <- adult.workclass(ppl0$workclass)

ppl0$occupation <- adult.occupation(ppl0$occupation)




## Source the scripts support scripts.

source("brA1.R")

## 


