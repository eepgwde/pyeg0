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

## Correct rounding error
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

## Get WDI datasets and put them into Excel.
## Need about 20 useful ones.
## "Useful" means don't need to impute too much.
## Their 2016 numbers are probably estimates.
## 'exp' contains the grand total we have in detail:
## NE.CON.PETC.CD - household final at current US $

wdi <- list()

wdi$income <- wdi.search0('income')

wdi$gdp <- wdi.search0('gdp')

wdi$exp <- wdi.search0('expenditure')

wdi$price <- wdi.search0('price')

wdi$gini <- wdi.search0('gini')

wdi$popn <- wdi.search0('population')


wdi$income <- wdi.filter0(wdi$income)

wdi$gdp <- wdi.filter0(wdi$gdp)
wdi$exp <- wdi.filter0(wdi$exp)
wdi$price <- wdi.filter0(wdi$price)
wdi$gini <- wdi.filter0(wdi$gini)
wdi$popn <- wdi.filter0(wdi$popn)


save(wdi, file="wdi.Rdata")

wdi0 <- wdi

rm(wdi)

load(file="wdi.Rdata", .GlobalEnv)

names(wdi)

