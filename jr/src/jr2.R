## weaves
##
## File with q/kdb+ generated technicals.

## No longer used, but knowing me.
folios.list <- read.csv("folios0.csv", 
                        stringsAsFactors=FALSE, 
                        header=TRUE)

## Clear all away: very important if you re-use names in
## functions.

rm(list = ls())
if (!is.null(dev.list()) {
    lapply(dev.list(), function(x) dev.off())
}

## Various kdb loads

kdb.url <- "http://m1:5000/q.csv?select from data0 where folio0 = `KF"
kdb.url <- "http://m1:5000/q.csv?select from data0 where in0"
kdb.url <- "http://m1:5000/q.csv?select from data1 where in0"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE)

folios.in0 <- tail(folios.in, n=60)

source("plot0.R")
source("plot1.R")

### Debug
## debug(ts1.folio.f0)

## Some classifiers: what we want from kdb+ and its name in total
## portfolio.

folios.ustk <- ustk.folio1(folios.in)

## Shorter data set.
folios.ustk0 <- tail(folios.ustk, n = 60)

## Brownians - just like the books.

folios.metric <- "p00"
folios.mnames <- ustk.patt(folios.ustk, metric0=folios.metric)

ts.plot(folios.ustk[, folios.mnames])

ts0.plot(folios.ustk0, folios.mnames,
         xtra=NULL, fname="Folios", ylab0=folios.metric)

## Global pollution
rm("folios.mnames", "folios.metric")

## There's 30 second time-lag writing these to the remote disk.

# jpeg.ustk(folios.ustk)

jpeg.ustk(folios.ustk0)
jpeg.ustk(folios.ustk0, metric0="r00", xtra0=NULL)
jpeg.ustk(folios.ustk0, metric0="s05", xtra0=NULL)


