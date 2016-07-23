## weaves
##
## Elasticities (or propensities or indifferences) from kdb - totals only
##

library(ggplot2)

## Clear all away: very important if you re-use names in
## functions.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

load("wdi.Rdata", .GlobalEnv)

### Get data from q/kdb+ an write to local binary disk.

kdb.url <- "http://m1:5000/q.csv?select from hexpt0"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE, stringsAsFactors=TRUE)

save(folios.in, file="folios-in.dat")

## We can just look at the household data.

x0 <- folios.in[ folios.in$type0 == "h", ]

plot.ts(unstack(x0, r1 ~ Categories)[, 1:6], plot.type = "single")

plot.ts(unstack(x0, r1 ~ Categories)[, 7:12], plot.type = "single")

## Try a ggplot

x1 <- x0[, c("Categories", "time", "r1")]

jpeg(width=1024, height=768, filename = "fig-%03d.jpeg")

ggplot(data = x1, aes(x=time, y=r1)) + 
    geom_line(aes(linetype=Categories, colour=Categories))

dev.off()

### Now for the two classes

kdb.url <- "http://m1:5000/q.csv?select from hexp2"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE, stringsAsFactors=TRUE)

save(folios.in, file="folios-ul.dat")

## We can just look at the household data.

x0 <- folios.in[ folios.in$type0 == "h" & folios.in$cls == "upper", ]

plot.ts(unstack(x0, r1 ~ Categories)[, 1:6], plot.type = "single")

plot.ts(unstack(x0, r1 ~ Categories)[, 7:12], plot.type = "single")

## Try a ggplot of upper to lower

x0 <- folios.in[ folios.in$type0 == "h", ]
x1 <- x0[, c("Categories", "time", "r1", "cls")]

jpeg(width=1024, height=768, filename = "fig-%03d.jpeg")

ggplot(data = x1, aes(x=time, y=r1)) + 
    geom_line(aes(linetype=cls, colour=Categories))

dev.off()

## Macroeconomy: figures
