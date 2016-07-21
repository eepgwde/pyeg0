## weaves
##
## Data simplification

## Preparation: save as CSV from XL, be sure to change number format to remove commas.

rm(list = ls(pattern = "inc*"))

inc00 <- read.csv("../bak/hexp-065.csv", 
                  stringsAsFactors=TRUE, strip.white=TRUE,
                  header=TRUE, na.strings=c("NA"))

inc <- inc00

## Simplify column names

source("pruA0.R")

### Redundant and shorter

inc[[ "Geographies" ]] <- NULL

cnames <- colnames(inc)
cnames <- gsub("Consumer_Expenditure_by_Income", "exp", cnames)

colnames(inc) <- cnames

## Factors

### Shorter

levels(inc$Categories) <- gsub("_.+$", "", levels(inc$Categories))

## Totals
## Can show keying errors, we keep those.

inc0 <- inc

## Longitudinal shaping
inc <- reshape(inc0, direction="long", varying = 4:15, sep = "")

ds <- list()

## Correct error in totals
ds$h <- inc[ inc$type0 == "h", ]
ds$h[is.na(ds$h$decile), "X"] <- ds$h[is.na(ds$h$decile), "X"] * 10
inc.ds0(ds$h)

## Split off total expenditure

ds$t <- inc[ inc$type0 == "t", ]
inc.ds0(ds$t)

## Save as CSV with totals for q/kdb+ (this will perform proportions and deltas)

ds0 <- rbind(data.frame(ds$h), data.frame(ds$t))

write.csv(ds0, file="hexp0-065.csv", na = "", row.names = FALSE)

## Save without totals for Excel Pivot charts.

ds1 <- ds0[ !is.na(ds0$decile), ]
ds1$id <- NULL

write.csv(ds1, file="hexp1-065.csv", na = "", row.names = FALSE)


