### weaves
## Protyping code.
## May no longer work. Most recent at the top

## Try Gini and Lorentz

x0 <- folios.in[ folios.in$type0 == "h" & folios.in$cls == "lower", ]

x1 <- unstack(x0, x2tp ~ Categories)

x2 <- ts(x1)

sapply(1:nrow(x2), function(x) { return(ineq(x2[x,], type="Gini")) }, simplify=TRUE, USE.NAMES=FALSE)

ineq(x2[1,], type="Gini")
ineq(x2[2,], type="Gini")

plot(Lc(x2[1,]))

plot(Lc(x2[2,]))


##

View(WDI(indicator="NY.GDY.TOTL.KN", country=c('ID'), start=2005, end=2016))

##

r0 <- data.frame(year=2005:2016)

r1 <- merge(r0, m1[[1]], all=TRUE)

start0 <- 2005
end0 <- 2016

setdiff(colnames(r1), 

##

library(WDI)

wdi = list()

wdi$gdp <- WDI(indicator="NY.GDP.MKTP.CD", country=c('ID', 'CN', 'JP'), start=2005, end=2016)

WDIsearch('income')

wdi$tpop <- WDI(indicator="SP.POP.TOTL", country=c('ID'), start=2005, end=2016)
wdi$upop <- WDI(indicator="SP.URB.TOTL.IN.ZS", country=c('ID'), start=2005, end=2016)

x0 <- "SI.POV.GINI"            
x1 <- WDI(indicator=x0, country=c('ID'), start=2005, end=2016)
wdi$pgini <- x1

x0 <- "CPTOTSAXN"
x1 <- WDI(indicator=x0, country=c('ID'), start=2005, end=2016)
wdi$cpi <- x1



folios.all[tail(which(folios.all$in0 == 1), n=1), "dt0"]

## Time-series and lag: zoo is very nearly a data-frame

ts.zoo <- zoo(df)
ts.zoo1 <- lag(ts.zoo, k=1)

ts.zoo1 <- ts.zoo[, c("fv05", "fp05")]

colnames(ts.zoo)

## sweep is a drag

A <- array(1:24, dim = 4:2)

## no warnings in normal use
sweep(A, 1, 5)

(A.min <- apply(A, 1, min))  # == 1:4
sweep(A, 1, A.min)

sweep(A, 1:2, apply(A, 1:2, median))


### Useful trick to see the generic method.

m <- methods(class = class(modelImp))
> print(m)
[1] plot  print
see '?methods' for accessing help and source code
> print(attr(m, "info"))
                   visible                from generic  isS4
plot.varImp.train    FALSE registered S3method    plot FALSE
print.varImp.train   FALSE registered S3method   print FALSE
  

### The acid test is dissapointing, but I've seen worse.

testPred <- predict(modelFit1, testDescr)
postResample(testPred, testClass)

confusionMatrix(testPred, testClass, positive = "profit")

### Get a density and a ROC

x.p <- predict(modelFit1, df1, type = "prob")[2]
test.df <- data.frame(profit=x.p$profit, Obs=ml0$outcomes)
test.roc <- roc(Obs ~ profit, test.df)

densityplot(~test.df$profit, groups = test.df$Obs, auto.key = TRUE)

plot.roc(test.roc)

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
