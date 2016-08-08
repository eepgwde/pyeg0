## weaves
##
## Visual validation of q/kdb+ generated technicals.
##
## @note Lags
## The q/kdb+ data has been lagged. And the trading signals derived
## from that.
## 
## @note Technicals and trading signals
## From the lagged data, q/kdb+ has generated technicals and RSI
## trading strategy signals.

## No longer used, but you can use it to get a portfolio name.
folios.list <- read.csv("folios0.csv", 
                        stringsAsFactors=FALSE, 
                        header=TRUE)

## Clear all away: very important if you re-use names in
## functions.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

source("plot0.R")
source("plot1.R")

### Write to local binary disk.

## Samples: various kdb loads
kdb.url <- "http://localhost:5000/q.csv?select from data0 where folio0 = `KF"
kdb.url <- "http://localhost:5000/q.csv?select from data0 where in0"

## Out-of-sample
kdb.url <- "http://localhost:5000/q.csv?select from data1 where not in0"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE, stringsAsFactors=TRUE)

folios.out <- tbl.factorize(folios.in, null0=TRUE)

save(folios.out, file="folios-out.dat")

## All-sample
kdb.url <- "http://localhost:5000/q.csv?select from data1"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE, stringsAsFactors=TRUE)

folios.all <- tbl.factorize(folios.in, null0=TRUE)

save(folios.all, file="folios-all.dat")

## In-sample
kdb.url <- "http://localhost:5000/q.csv?select from data1 where in0"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE, stringsAsFactors=TRUE)

folios.in <- tbl.factorize(folios.in, null0=TRUE)

save(folios.in, file="folios-in.dat")

### Graphics displays
## Load the a mix of the in-sample and out-of-sample set.

rm(folios.in, folios.out, folios.all)

load("folios-all.dat", envir=.GlobalEnv)
ml0 = list()
ml0$lastin <- folios.all[tail(which(folios.all$in0 == 1), n=1), "dt0"]
ml0$range <- c(ml0$lastin - 90, ml0$lastin + 30)

x.range <- (folios.all$dt0 >= ml0$range[1]) & (folios.all$dt0 <= ml0$range[2])
folios.in <- folios.all[x.range, ]

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
rm("jpeg.short")
# jpeg.short <- TRUE

xtra.folio <- NULL
if (any(grepl("KA\\..+", colnames(folios.ustk0)))) {
    xtra.folio <- "KA"
}

if (exists("jpeg.short")) {

    jpeg.ustk(folios.ustk0, xtra0=xtra.folio)

    jpeg.ustk(folios.ustk0, metric0="r00", xtra0=NULL)
    jpeg.ustk(folios.ustk0, metric0="s05", xtra0=NULL)
    jpeg.ustk(folios.ustk0, metric0="s20", xtra0=NULL)

    jpeg.ustk(folios.ustk0, metric0="r05", xtra0=NULL)
    jpeg.ustk(folios.ustk0, metric0="r20", xtra0=NULL)

}

### Full set

if (!exists("jpeg.short")) {

    jpeg.ustk(folios.ustk, xtra0=xtra.folio)

    jpeg.ustk(folios.ustk, metric0="s20", xtra0=NULL)

    ## KF is the folio I chose for the synthetics, it is a less volatile
    ## stock and KC (KF twice) is more stable than KA (all equally
    ## weighted).

    xx.patt <- "^K[A-C]\\.s20$"
    xx.mnames <- sort(ustk.patt(folios.ustk, patt=xx.patt))
    jpeg.ustk(folios.ustk, mnames=xx.mnames, names.cols = 3,
              xtra0=NULL, metric0=NULL, tag0="s20")

}

## MACD - you need to up close.

xx.patt <- "^K[F-Z]\\.[er][0-9]{2}$"
xx.mnames <- sort(ustk.patt(folios.ustk0, patt=xx.patt))
jpeg.ustk(folios.ustk0, mnames=xx.mnames, names.cols = 5,
          xtra0=NULL, metric0=NULL, tag0="macd")

save(folios.ustk, file="folios-ustk.dat")
