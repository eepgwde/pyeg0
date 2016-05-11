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
if (!is.null(dev.list())) {
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

## There can be as much as a 30 second time-lag writing these to the
## disk.

### Short set analysis

jpeg.ustk(folios.ustk0)

jpeg.ustk(folios.ustk0, metric0="r00", xtra0=NULL)
jpeg.ustk(folios.ustk0, metric0="s05", xtra0=NULL)
jpeg.ustk(folios.ustk0, metric0="s20", xtra0=NULL)

jpeg.ustk(folios.ustk0, metric0="r05", xtra0=NULL)
jpeg.ustk(folios.ustk0, metric0="r20", xtra0=NULL)


## MACD

xx.patt <- "^KF\\.r[0-9]{2}$"
xx.mnames <- ustk.patt(folios.ustk0, patt=xx.patt)
ts0.plot(folios.ustk0, xx.mnames, 
         xtra=NULL, fname="KF0", ylab0="MACD:0,5,20")

xx.patt <- "^K[B-Z]\\.r[0-9]{2}$"
xx.mnames <- sort(ustk.patt(folios.ustk0, patt=xx.patt))
jpeg.ustk(folios.ustk0, mnames=xx.mnames, names.cols = 3,
          xtra0=NULL, metric0=NULL, tag0="macd")

### Full set

jpeg.ustk(folios.ustk)

jpeg.ustk(folios.ustk, metric0="s20", xtra0=NULL)

## KF is the folio I chose for the synthetics, it is a less volatile
## stock and KC (KF twice) is more stable than KA (all equally
## weighted).

xx.patt <- "^K[A-C]\\.s20$"
xx.mnames <- sort(ustk.patt(folios.ustk0, patt=xx.patt))
jpeg.ustk(folios.ustk, mnames=xx.mnames, names.cols = 3,
          xtra0=NULL, metric0=NULL, tag0="s20")
