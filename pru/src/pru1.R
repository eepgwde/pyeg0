## weaves
##
## World Development Indicators
##
## This includes some very time-consuming downloads and querying.
## The data downloaded is written to disk: use that.
## See the load() command below.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

library(WDI)

source('pruA0.R')

## Get WDI datasets and put them into Excel.
## Need about 20 useful ones.
## "Useful" means don't need to impute too much.
## Their 2016 numbers are probably estimates.
## 'exp' contains the grand total we have in detail:
## NE.CON.PETC.CD - household final at current US $

wdi <- list()

## This loads into big data-frames

## wdi$groupname has these sub-names:
## indicators: is those found in a data-frame with description and presence
## values: for those indicators that have values, those values in a data-frame.

wdi$income <- wdi.search0('income')

wdi$gdp <- wdi.search0('gdp')

wdi$exp <- wdi.search0('expenditure')

wdi$price <- wdi.search0('price')

wdi$gini <- wdi.search0('gini')

wdi$popn <- wdi.search0('population')

wdi$hh <- wdi.search0('household')

## This annotates the indicators and adds some counts

wdi$income <- wdi.filter0(wdi$income)

wdi$gdp <- wdi.filter0(wdi$gdp)
wdi$exp <- wdi.filter0(wdi$exp)
wdi$price <- wdi.filter0(wdi$price)
wdi$gini <- wdi.filter0(wdi$gini)
wdi$popn <- wdi.filter0(wdi$popn)
wdi$hh <- wdi.filter0(wdi$hh)

## Archive to disk, check with a reload

save(wdi, file="wdi.Rdata")

wdi0 <- wdi

rm(wdi)

## In another part of the system, use this to load the data.
load(file="wdi.Rdata", .GlobalEnv)

## See total expenditure and then per capita

plot.ts(ts(data = wdi$hh$values[, c("NE.CON.PETC.KD", "NE.CON.PRVT.PC.KD") ]), plot.type=c("multiple"))

names(wdi)
