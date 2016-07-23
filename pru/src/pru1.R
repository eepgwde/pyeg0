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

## This annotates the indicators and adds some counts

wdi$income <- wdi.filter0(wdi$income)

wdi$gdp <- wdi.filter0(wdi$gdp)
wdi$exp <- wdi.filter0(wdi$exp)
wdi$price <- wdi.filter0(wdi$price)
wdi$gini <- wdi.filter0(wdi$gini)
wdi$popn <- wdi.filter0(wdi$popn)

## Later additions

wdi$hh <- wdi.search0('household')

wdi$hh <- wdi.filter0(wdi$hh)

wdi$demog <- wdi.search0('(birth|death|life)')

wdi$demog <- wdi.filter0(wdi$demog)

wdi$struc <- wdi.search0('quintile')

wdi$struc <- wdi.filter0(wdi$struc)

## Write to CSV for browsing
wdi.csv(wdi)

## Archive to disk, check with a reload

save(wdi, file="wdi.Rdata")

wdi0 <- wdi

rm(wdi)

## In another part of the system, use this to load the data.
load(file="wdi.Rdata", .GlobalEnv)

## Our Case study totals.
## See total expenditure and then per capita

plot.ts(ts(data = wdi$hh$values[, c("NE.CON.PETC.KD", "NE.CON.PRVT.PC.KD") ]), plot.type=c("multiple"))

names(wdi)


jpeg(width=1024, height=768, filename = "ind-%03d.jpeg")

## HFCE
m0 <- c("NE.CON.PETC.CD", "NE.CON.PRVT.PP.CD")
plot.ts(wdi$hh$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$hh, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

## comment: slow exponential, GDPpc unaffected by financial because
## population growth increased to compensate.

## Income

## Imports and exports
m0 <- c("BM.GSR.TOTL.CD","BX.GSR.TOTL.CD")
plot.ts(wdi$income$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$income, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

## Income: payments (imports), net, receipts (exports)

m0 <- c("BM.GSR.FCTY.CD","BN.GSR.FCTY.CD","BX.GSR.FCTY.CD")
plot.ts(wdi$income$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$income, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

## comment: exports starting to lag imports => manufacturing

## Debt: all % of exports, external, short-term, interest, total debt serviced
m0 <- c("DT.DOD.DECT.EX.ZS","DT.DOD.DSTC.XP.ZS","DT.INT.DECT.EX.ZS","DT.TDS.DECT.EX.ZS")
plot.ts(wdi$income$values[, m0], plot.type="multiple")

## comment: debt is increasing from 2008

## Income: net, net 2000, growth, Gross domestic income, Net from abroad US$ LCU

m0 <- c("NY.ADJ.NNTY.CD","NY.ADJ.NNTY.KD","NY.ADJ.NNTY.KD.ZG","NY.GDY.TOTL.KN","NY.GSR.NFCY.CD", "NY.GSR.NFCY.CN")
plot.ts(wdi$income$values[, m0], plot.type="multiple")
## comment: [KD series more up-to-date, but is 2000 US$ so currency/valuation fluctuations.]
## less income from abroad

## Income: delta: net, GDI, from abroad - local
m0 <- c("NY.ADJ.NNTY.CD","NY.GDY.TOTL.KN","NY.GSR.NFCY.CN")
x1 <- wdi.delta(wdi$income, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")
## comment: income from abroad spiked into GDI in 2011. Typhoon year?

## Merchandise: from G9 %, imports and exports
m0 <- c("TM.VAL.MRCH.HI.ZS","TX.VAL.MRCH.HI.ZS")
plot.ts(wdi$income$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$income, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")
## comment: export led recovery in 2013, crisis of 2008 saw large imports.

## Population: total, rural, urban, 15-24 year-olds entering work, total, female, male
m0 <- c("SP.POP.TOTL", "SP.RUR.TOTL", "SP.URB.TOTL", "SL.TLF.ACTI.1524.ZS", "SL.TLF.ACTI.1524.FE.ZS", "SL.TLF.ACTI.1524.MA.ZS")
plot.ts(wdi$popn$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$popn, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

## comment: move to the city, rural movement stopped after crisis.
## proportionally more young women in workplace. women replaced men during crisis.

## Price indices: CPI, CPI yoy, CPI@2005, inflation, Wholesale Price Index.

m0 <- c("CPTOTSAXN","CPTOTSAXNZGY","FP.CPI.TOTL","FP.CPI.TOTL.ZG","FP.WPI.TOTL")
plot.ts(wdi$price$values[, m0], plot.type="multiple")

m0 <- c("CPTOTSAXN", "FP.WPI.TOTL")
x1 <- wdi.delta(wdi$price, m0)

plot.ts(wdi.deltas(x1), plot.type = "single")

## comment: [CPI@2005 is shorter than CPI], WPI shows economy downturn in 2008


## Demographics
##

## AIDS estimated deaths (UNAIDS estimates)
## Mortality rate, under-5 (per 1,000 live births)
## Mortality rate, neonatal (per 1,000 live births)
## Number of maternal deaths
## Lifetime risk of maternal death (1 in: rate varies by country)
## Lifetime risk of maternal death (%)
## Maternal mortality ratio (modeled estimate, per 100,000 live births)
## Tuberculosis death rate (per 100,000 people)
## Adolescent fertility rate (births per 1,000 women ages 15-19)
## Birth rate, crude (per 1,000 people)
## Death rate, crude (per 1,000 people)
## Mortality rate, infant (per 1,000 live births)
## Life expectancy at birth, female (years)
## Life expectancy at birth, total (years)
## Life expectancy at birth, male (years)
## Fertility rate, total (births per woman)

if (exists("demog.check")) {
    m0 <- c("SH.DYN.AIDS.DH","SH.DYN.MORT","SH.DYN.NMRT","SH.MMR.DTHS","SH.MMR.RISK","SH.MMR.RISK.ZS","SH.STA.MMRT","SH.TBS.MORT","SP.ADO.TFRT","SP.DYN.CBRT.IN","SP.DYN.CDRT.IN","SP.DYN.IMRT.IN","SP.DYN.LE00.FE.IN","SP.DYN.LE00.IN","SP.DYN.LE00.MA.IN","SP.DYN.TFRT.IN")

    m1 <- split(m0, ceiling(seq_along(m0)/6))
    length(m1)

    plot.ts(wdi$demog$values[, m1[[1]]], plot.type="multiple")

    plot.ts(wdi$demog$values[, m1[[2]]], plot.type="multiple")

    plot.ts(wdi$demog$values[, m1[[3]]], plot.type="multiple")
}

## Birth and Death: Birth, Death and Infant Mortality
## comment: interesting! birth rate down, death rate plateau, note that population growth is slowing
## Very dramatic over last few years.
m0 <- c("SP.DYN.CBRT.IN","SP.DYN.CDRT.IN","SP.DYN.IMRT.IN")
plot.ts(wdi$demog$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$demog, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

## Life quality: AIDS, Tuberculosis
## comment: more people surviving, strange glitch in TB.
m0 <- c("SH.DYN.AIDS.DH","SH.TBS.MORT")
plot.ts(wdi$demog$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$demog, m0)
plot.ts(wdi.deltas(x1), plot.type = "single")

## Life quality: infant/maternal mortality: under-5, neonatal,
## maternal: 1 in N risk, % risk, lifetime, per 100,000
## comment: more people surviving
m0 <- c("SH.DYN.MORT","SH.DYN.NMRT","SH.MMR.DTHS","SH.MMR.RISK","SH.MMR.RISK.ZS","SH.STA.MMRT")
plot.ts(wdi$demog$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$demog, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

## Fertility
## comment: less children
m0 <- c("SP.ADO.TFRT","SP.DYN.TFRT.IN")
plot.ts(wdi$demog$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$demog, m0)
plot.ts(wdi.deltas(x1), plot.type = "single")

## Life expectancy
## comment: all continuing to live longer; rates of improvement: men's
## were improving, women's were declining.

m0 <- c("SP.DYN.LE00.FE.IN","SP.DYN.LE00.IN","SP.DYN.LE00.MA.IN")
plot.ts(wdi$demog$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$demog, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

## Women in working population (not only until 2014)
## comment: beware scaling! women are continuing to take more employment from men.
## People still being employed.

m0 <- c("SP.POP.TOTL", "SP.POP.TOTL.FE.ZS", "SL.EMP.TOTL.SP.FE.ZS", "SL.EMP.TOTL.SP.MA.ZS", "SL.EMP.TOTL.SP.ZS")
plot.ts(wdi$popn$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$popn, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

## Poverty
## comment: beginning to increase after last bust

m0 <- c("SI.POV.NAHC", "SI.POV.RUHC", "SI.POV.URHC")
plot.ts(wdi$popn$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$popn, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

## Employment by education
## comment:

## lower secondary is now YoY going down and flat at 0.0% growth

## But secondary is now flat growth - peaked in 2012

## upper secondary increasing, is now YoY plateau
## More skilled people in workplace and more women than men.

m0 <- c("SP.SEC.LTOT.FE.IN","SP.SEC.LTOT.IN","SP.SEC.LTOT.MA.IN")
plot.ts(wdi$popn$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$popn, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

m0 <- c("SP.SEC.TOTL.FE.IN","SP.SEC.TOTL.IN","SP.SEC.TOTL.MA.IN")
plot.ts(wdi$popn$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$popn, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

m0 <- c("SP.SEC.UTOT.FE.IN","SP.SEC.UTOT.IN","SP.SEC.UTOT.MA.IN")
plot.ts(wdi$popn$values[, m0], plot.type="multiple")

x1 <- wdi.delta(wdi$popn, m0)
plot.ts(wdi.deltas(x1), plot.type = "multiple")

dev.off()
