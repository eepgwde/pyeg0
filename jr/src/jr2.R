## weaves
##
## File with q/kdb+ generated technicals.

folios.list <- read.csv("folios0.csv", 
                        stringsAsFactors=FALSE, 
                        header=TRUE)

## kdb.url <- "http://m1:5000/q.csv?select from data0 where folio0 = `KF"

kdb.url <- "http://m1:5000/q.csv?select from data0 where in0"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE)

folios.in0 <- tail(folios.in, n=60)

source("plot0.R")

source("plot1.R")

folios.metric <- "r00"
folios.forml <- as.formula(paste(folios.metric, "~", "folio0"))

## Daily prices by folio
## unstack and find a way of plotting.
folios.ustk <- unstack(folios.in, folios.forml)
folios.ustk0 <- tail(folios.ustk, n = 60)

## Brownians - just like the books.
ts.plot(folios.ustk)

ts0.plot(folios.ustk0, colnames(folios.ustk0),
         xtra=NULL, fname="Folios", ylab0=folios.metric)

## change the dim to get no more than 6.
names.x <- colnames(folios.ustk0)
names.idxes <- t(array(1:length(names.x), dim=c(5,4)))

ts0.tbl <- head(folios.ustk, n=180)
ts1.folio(ts0.tbl, names.idxes, ylab0=folios.metric)

## ts0.tbl <- folios.ustk0[200:300, ]
## ts1.folio(ts0.tbl, names.idxes, ylab0="p00")

ts0.tbl <- tail(folios.ustk, n=180)
ts1.folio(ts0.tbl, names.idxes, ylab0=folios.metric)

ts0.tbl <- folios.ustk
ts1.folio(ts0.tbl, names.idxes, ylab0=folios.metric)

