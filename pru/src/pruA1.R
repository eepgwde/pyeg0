### weaves
## Load some WDI 

## See wip for how they're found.
## eg. WDIsearch('gdp')

library(WDI)
library(zoo)

wdi = list()

wdi$gdp <- WDI(indicator="NY.GDP.MKTP.CD", country=c('ID', 'CN', 'JP'), start=2005, end=2016)

wdi$tpop <- WDI(indicator="SP.POP.TOTL", country=c('ID'), start=2005, end=2016)
wdi$upop <- WDI(indicator="SP.URB.TOTL.IN.ZS", country=c('ID'), start=2005, end=2016)

x0 <- "SI.POV.GINI"            
x1 <- WDI(indicator=x0, country=c('ID'), start=2005, end=2016)
wdi$pgini <- x1

x0 <- "CPTOTSAXN"
x1 <- WDI(indicator=x0, country=c('ID'), start=2005, end=2016)
wdi$cpi <- x1

## Fixups

wdi$pgini[,3] <- na.locf(wdi$pgini[,3], fromLast=TRUE)

colnames(wdi$gdp)[3] <- "gdp"
colnames(wdi$tpop)[3] <- "tpop"
colnames(wdi$upop)[3] <- "upop"
colnames(wdi$pgini)[3] <- "gini"
colnames(wdi$cpi)[3] <- "cpi"

## Merging by hand

wdi$all <- wdi$tpop

wdi$all$gdp <- wdi$gdp[ wdi$gdp == "ID", 3]

wdi$all$upop <- wdi$upop[,3]
wdi$all$pgini <- wdi$pgini[,3]

wdi$all$cpi <- wdi$cpi[ wdi$cpi$year %in% wdi$tpop$year, 3]

wdi0 <- list()
wdi0$ID <- wdi$all

wdi0$gdp <- wdi$gdp

save(wdi0, file = "wdi0.dat")
