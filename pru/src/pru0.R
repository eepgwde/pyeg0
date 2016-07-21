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

## Totals
## Can show keying errors, we keep those.

inc0 <- inc

## Longitudinal shaping
inc <- reshape(inc0, direction="long", varying = 4:15, sep = "")

ds <- list()

## Correct rounding error
ds$h <- inc[ inc$type0 == "h", ]
ds$h[is.na(ds$h$decile), "X"] <- ds$h[is.na(ds$h$decile), "X"] * 10
inc.ds0(ds$h)

## Correct miskey - only one in Clothing
ds$t <- inc[ inc$type0 == "t", ]
inc.ds0(ds$t)

inc["10.2005", "X" ] <- inc["10.2005", "X"] + max(inc.ds0(ds$t))

ds$t <- inc[ inc$type0 == "t", ]
inc.ds0(ds$t)

## Save as CSV and perform proportions and deltas

ds <- rbind(ds$h, ds$t)

write.csv(ds, file="hexp-065.csv1", na = "", row.names = FALSE)

## Get WDI dataset

wdi <- list()

wdi$income <- wdi.search0('income')

wdi$gdp <- wdi.search0('gdp')

wdi$exp <- wdi.search0('expenditure')

wdi$price <- wdi.search0('price')

wdi$gini <- wdi.search0('gini')

wdi$popn <- wdi.search0('population')

save(wdi, file="wdi.Rdata")

