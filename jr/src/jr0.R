## weaves
##
## Data analysis: look and feel

folios.list <- read.csv("folios0.csv", 
                        stringsAsFactors=FALSE, 
                        header=TRUE)



folio.fname <- folios.list[sample(1:dim(folios.list)[1], 1), 1]
folio.fname
folio.name <- substring(folio.fname, 1, 3)

folios.df <- read.csv(folio.fname)
folios.df$in0 <- as.logical(folios.df$in0)

names.base <- c("dt0", "r00", "dr00", "m5r00")

c0 <- colnames(folios.df)

### Simpler table: just to check, the metrics.

c0.idx <- which(grepl("^x[0-9]{2}$", c0))

names.x <- c0[c0.idx]

## In-sample
folios.in <- folios.df[folios.df$in0, c(names.base, names.x)]

## A smaller one still, for prototyping
folios.in0 <- tail(folios.in, n=40)

## Source the scripts for plotting.

source("plot0.R")
source("plot1.R")

## Some time-series plots

names.idxes <- t(array(1:length(names.x), dim=c(6,4)))

ts0.tbl <- head(folios.in, n=40)
ts0.folio(ts0.tbl)

ts0.tbl <- folios.in[200:300, ]
ts0.folio(ts0.tbl)

ts0.tbl <- tail(folios.in, n=40)
ts0.folio(ts0.tbl)

## A short set of {A,PA,C}CF, this function uses globals.

lapply(names.x, function(x) grph.set0(folios.in, x, jpeg0=TRUE))

## Pairwise we will look at ccf wrt a few to see that they are too
## similiar

names.xXX <- sample(names.x, 1)
lapply(names.x, function(x) grph.set0(folios.in, x, 
                                      ref0=names.xXX, jpeg0=TRUE))
