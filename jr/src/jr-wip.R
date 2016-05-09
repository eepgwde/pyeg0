### weaves
## Protyping code.
## May no longer work.


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

grph.set0("x01")

grph.set0("x01", jpeg0=TRUE)

## dev.off()

names.xr <- append(names.x, "r00")

ts.plot(folios.in0[, names.xr],
             gpars=list(xlab="day", ylab="metric", 
                        lty=c(1:length(names.xr))))

### Check some auto-correlations on the returns
## Check the result and the delta.
## Can indicate AR process.

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

