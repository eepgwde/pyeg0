## weaves
##
## Data analysis: look and feel

folios.list <- read.csv("folios0.csv", 
                        stringsAsFactors=FALSE, 
                        header=TRUE)

folio.fname <- folios.list[1,1]
folio.fname

folios.df <- read.csv(folio.fname)
folios.df$in0 <- as.logical(folios.df$in0)

names.base <- c("dt0", "r00", "dr00", "m5r00")

c0 <- colnames(folios.df)

## Simple set: just to check

c0.idx <- which(grepl("^x[0-9]{2}$", c0))

names.x <- c0[c0.idx]

folios.in <- folios.df[folios.df$in0, c(names.base, names.x)]

folios.in0 <- tail(folios.in, n=40)

## Quick time-series plot

names.xr <- append(names.x, "r00")

ts.plot(folios.in0[, names.xr],
             gpars=list(xlab="day", ylab="metric", 
                        lty=c(1:length(names.xr)) ))
legend("bottomleft", names.xr, col=1:length(names.xr), lty=, cex=.65)


## A short set

folios.df1 <- tail(folios.df, n=40)

lapply(names.x, function(x) grph.set0(x, jpeg0=TRUE))

