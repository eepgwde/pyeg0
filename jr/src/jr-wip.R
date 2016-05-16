### weaves
## Protyping code.
## May no longer work. Most recent at the top

### Check price to moving average in jr3.R to see we have like to like.

df <- ustk.xfolio(train.ustk2, folio="KG", metric="fc20")



grph.pair0(train.ustk2, x=NULL, y1="KF.p00", y2="KF.e20")
grph.pair0(train.ustk2, x=NULL, y1="KF.p00", y2="KF.s20")
grph.pair0(train.ustk2, x=NULL, y1="KG.p00", y2="KG.s20")
grph.pair0(train.ustk2, x=NULL, y1="KG.p00", y2="KG.e20")

### Convert to factor

ustk.factors <- colnames(folios.ustk0)[which(as.logical(sapply(folios.ustk0, is.character, USE.NAMES=FALSE)))]

lapply(ustk.factors, function(x) folios.ustk0[, x] <<- as.factor(folios.ustk0[, x]))

## Plotting

ts0.tbl <- head(folios.ustk, n=180)

jpeg.ustk(ts0.tbl)

### Data frame merging on rownames - very easy!

t0 <- ustck.folio1(folios.in)
colnames(t0)

folios.r00 <- ustck.folio(folios.in, 
                          folios.metric="r00")

folios.x00 <- data.frame(folios.ustk, folios.r00)

x0.all <- colnames(folios.in)
x0.metrics <- x0.all[grepl("[a-z]+[0-9]{2}$", x0)]

### More attempts with ggplot

ggplot(subset(folios.in0, folio0 %in% c("KF", "KG"),
              aes(x=dt0, y=p00, color=folio0)) +
       geom_line())

## Check kdb

kdb.url <- "http://m1:5000/q.csv?datar"

kdb.url <- "http://m1:5000/q.csv?select from data0 where folio0 = `KF"
kdb.url <- URLencode(kdb.url)

df <- read.csv(kdb.url, header=TRUE)


## Plot time-series - too many to see clearly

names.idxes <- t(array(1:length(names.x), dim=c(6,4)))

ts0.tbl <- head(folios.in, n=40)
ts0.folio(ts0.tbl)

ts0.tbl <- folios.in[200:300, ]
ts0.folio(ts0.tbl)

ts0.tbl <- tail(folios.in, n=40)
ts0.folio(ts0.tbl)

nm0.tag <- folio.name
nm0.marks <- folio.marks0(ts0.tbl)
nm0.fspec <- paste(nm0.tag, nm0.marks, "-%03d.jpeg", sep ="")

jpeg(width=1024, height=768, filename = nm0.fspec)

lapply(1:dim(names.idxes)[1], 
       function(y) ts0.plot(ts0.tbl, 
                            names.x[names.idxes[y,]], 
                            fname=folio.name))

dev.off()

ts0.tbl <- head(folios.df)

nm0.tag <- folio.name
nm0.fspec <- paste(nm0.tag, "-%03d.jpeg", sep ="")

jpeg(width=1024, height=768, filename = nm0.fspec)

lapply(1:dim(names.idxes)[1], 
       function(y) ts0.plot(ts0.tbl, 
                            names.x[names.idxes[y,]], 
                            fname=folio.name))

dev.off()


## nm0.fspec <- paste(nm0.tag, "-%03d.jpeg", sep ="")

## jpeg(width=1024, height=768, filename = nm0)

grph.set0(folios.in, "x01")

grph.set0(folios.in, "x01", ref0="x02")

grph.set0(folios.in, "x01", jpeg0=TRUE)

grph.set0(folios.in, "x01", ref0="x02", jpeg0=TRUE)

## dev.off()

names.xr <- append(names.x, "r00")

ts.plot(folios.in0[, names.xr],
             gpars=list(xlab="day", ylab="metric", 
                        lty=c(1:length(names.xr))))

### Check some auto-correlations on the returns
## Check the result and the delta.
## Can indicate AR process.

# Plot a metric against time.

a0.p1 <- aes(dt0, r00)
a0.p2 <- aes_(x = as.name("dt0"), y = as.name("x01"))

grid.draw(grph.pair(folios.df1, a0.p1, a0.p2))


## Short-set

acf(folios.df1$r00)

acf(folios.df1$dr00)                    # something on the 5

pacf(folios.df1$r00)                    # nothing but the first

pacf(folios.df1$dr00)                   # nothing at all!

## Full-set

acf(folios.df$r00)
## touch on the second, usual profit taking

acf(folios.df$dr00)

pacf(folios.df$r00)                     # 14 day cycle

pacf(folios.df$dr00)                    # really nothing

### EWMA

library(zoo)

ewma <- function(x,lambda = 1, init = x[1]) {

    rval<-filter(lambda * coredata(x),
                 filter=(1-lambda),method="recursive",
                 init=init)
    rval<-zoo(coredata(rval),index(x))
    rval
}

sprintf("%.5f", ewma(xin,x.lambda))

library(fTrading)

x.lambda <- 0.60
xin <- c(1,rep(0, 20))

sprintf("%.5f", EWMA(xin, x.lambda, startup=1) )

x.lambda <- 0.60
xin <- c(1,rep(1, 20))

sprintf("%.5f", EWMA(xin, x.lambda, startup=1) )
