### weaves
## Load some WDI 

## See wip for how they're found.

library(WDI)

wdi = list()

wdi$gdp <- WDI(indicator="NY.GDP.MKTP.CD", country=c('ID', 'CN', 'JP'), start=2005, end=2016)

WDIsearch('gdp')

wdi$tpop <- WDI(indicator="SP.POP.TOTL", country=c('ID'), start=2005, end=2016)
wdi$upop <- WDI(indicator="SP.URB.TOTL.IN.ZS", country=c('ID'), start=2005, end=2016)

x0 <- "SI.POV.GINI"            
x1 <- WDI(indicator=x0, country=c('ID'), start=2005, end=2016)
wdi$pgini <- x1

x0 <- "CPTOTSAXN"
x1 <- WDI(indicator=x0, country=c('ID'), start=2005, end=2016)
wdi$cpi <- x1

