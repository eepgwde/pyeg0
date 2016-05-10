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
debug(ts1.folio.f0)

## Various kdb loads

kdb.url <- "http://m1:5000/q.csv?select from data0 where folio0 = `KF"
kdb.url <- "http://m1:5000/q.csv?select from data0 where in0"
kdb.url <- "http://m1:5000/q.csv?select from data1 where in0"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE)

folios.in0 <- tail(folios.in, n=60)

source("plot0.R")
source("plot1.R")

## Some classifiers: what we want from kdb+ and its name in total
## portfolio.

folios.ustk <- ustck.folio1(folios.in)

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

jpeg.ustk(folios.ustk0)

jpeg.ustk(folios.ustk)

jpeg.ustk(folios.ustk0, metric0="r00", xtra0=NULL)

jpeg.ustk(folios.ustk0, metric0="m05", xtra0=NULL)

## change the dim to get no more than 6 on a chart.
names.cols <- 5

names.x <- folios.mnames
names.rows <- length(names.x) %/% names.cols
if ((length(names.x) %% names.cols) != 0) {
    names.rows <- names.rows + 1
}
names.dim <- c(names.cols, names.rows)
names.idxes <- t(array(1:length(names.x), dim=names.dim ))

## The composite folio
folios.xtra0 <- paste("KA", folios.metric, sep=".")

ts0.tbl <- head(folios.ustk, n=180)
ts1.folio(ts0.tbl, names.idxes, ylab0=folios.metric, xtra0=folios.xtra0)

## ts0.tbl <- folios.ustk0[200:300, ]
## ts1.folio(ts0.tbl, names.idxes, ylab0="p00")

ts0.tbl <- tail(folios.ustk, n=180)
ts1.folio(ts0.tbl, names.idxes, ylab0=folios.metric, xtra0=folios.xtra0)

ts0.tbl <- folios.ustk
ts1.folio(ts0.tbl, names.idxes, ylab0=folios.metric, xtra0=folios.xtra0)

