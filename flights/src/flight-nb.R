### weaves

## Things you notice. 

## AVGSKDAVAIL is related to AVAILBUCKET, but AVAILBUCKET is complete

## AVGLOFATC is zero at times? Must mean direct flight?

## Definitely a strong correlation to time of day, just by eye.

## I think this is time series data! departure < arrive unless
## hangared for the night or a very short flight.

## For the big data set, we have only 41 flights that arrive before
## they leave, some are very short flights, aargh! three types in all.

flight.raw <- read.csv("../bak/flight.csv")

dim(flight.raw[which(flight.raw$SARRHR < flight.raw$SDEPHR), 
             c("SARRHR", "SDEPHR")])

## The flight duration is not related to AVGLOFATC, eg. Rio to Sao
## Paulo is less than an hour, ISTR, but it would be translantic from
## London

flight.raw[which(flight.raw$SARRHR == flight.raw$SDEPHR), 
         c("SARRHR", "SDEPHR", "AVGLOFATC")]

## Flights and routes


### Interpreter paste-ins for file 

## jpeg(width = 640, height = 640)
## plot())
## dev.off()

## Look at some plots for the numeric performance metrics AVG and, by
## chance I chose, AVAILBUCKET, which is at the end.

## This is more data validation. D00 must partition all parameters
## cleanly.

t.cols <- colnames(flight)

t.cols0 <- t.cols[grep("^AV.)*", t.cols)]
t.cols0 <- append("D00", t.cols0)

featurePlot(x = flight[, t.cols0],
            y = flight$LEGTYPE,
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = length(t.cols0) - 1))

## see d00vsAV

## See some density plots.
t.cols1 <- head(t.cols0, -1)
transparentTheme(trans = .9)
featurePlot(x = flight[, t.cols1],
            y = flight$LEGTYPE,
            plot = "density",
            scales = list(x = list(relation="free"),
                          y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            layout = c(length(t.cols1), 1),
            auto.key = list(columns = length(t.cols1)-1))

## Not very distinct partitioning. AVGSQ is most distinct.

## Correlations are not good for this subset.
library(corrgram)
corrgram(flight[, t.cols1], 
         abs = TRUE, 
         lower.panel=panel.shade, upper.panel=panel.pie,
         diag.panel=panel.minmax, text.panel=panel.txt)

corrplot::corrplot(cor(flight[, t.cols1],
                       use="pairwise.complete.obs"),
                   method="number")

## But very difficult: too many airports, too many aircraft.

plot(table(flight00$SKDDEPSTA))

plot(table(flight00$SKDARRSTA))

plot(density(as.numeric(flight00$SKDARRSTA)))

plot(table(flight00$SKDEQP))

str(flight)

## See if the numerics are near-zero or correlated.

flight.nzv

flight.cor <- cor(flight.num, use = "pairwise.complete.obs")

highlyCorDescr <- findCorrelation(flight.cor, cutoff = .75, verbose=TRUE)

# Which tells me that departure hour is very highly correlated to AVGSQ. 

flight[order(flight$SDEPHR), c("SDEPHR", "AVGSQ")]

corrplot::corrplot(flight.cor, method="number")

### Impute this AVGSKDAVAIL it's nearly the same as AVAILBUCKET
## we can't use as.numeric, so some string manipulation.

flight.na <- flight[, c("AVGSKDAVAIL", "xAVAILBUCKET")]

preProcValues <- preProcess(flight.na, method = c("knnImpute"))

## See a trainer

trellis.par.set(caretTheme())
plot(gbmFit1)

head(twoClassSummary)

trellis.par.set(caretTheme())
plot(gbmFit1, metric = "Kappa")

trellis.par.set(caretTheme())
plot(gbmFit1, metric = "ROC")

## It fitted very badly

## I'm supposed to improve on the probit model of D00
## but I'm relying on that to define LEGTYPE.
## In the notes, it did say the 80th percentile was defined
## wrt to the top eighty destinations that may be how the probit
## was defined, but D00 was defined over all 300 or so destinations.

is.between <- function(x, l, u) {
    x >= l & x <= u
}

src.probit <- ecdf(flight.raw$D00)

plot(src.probit)

## from the source data, their methodology is
src.80 <- 0.590909091
is.between(src.probit(src.80), 0.19, 0.21)

# Bottom 20% - a count
src.n0 <- sum(as.integer(
    is.between(src.probit(flight.raw$D00), 0, src.probit(src.80))
))

# Logic checks
all(flight.raw[ flight.raw$D00 <= src.80, c("LEGTYPE")] == "Weak")
any(flight.raw[ flight.raw$D00 > src.80, c("LEGTYPE")] == "Weak")

# By numbers, let n80 be the count of those under 20th percentile
src.n80 <-dim(flight.raw[ flight.raw$D00 <= src.80,])[1]

src.N <- dim(flight.raw)[1]

src.n80 / src.N

stopifnot(src.n80 == src.n)

## They saw an improvement to 45% detection ie. at src.55 ==  0.6969697

src.i55 <- max(which(is.between(src.probit(flight.raw$D00), 0, 0.45)))
src.55 <- flight.raw$D00[src.i55]

src.n55 <-dim(flight.raw[ flight.raw$D00 <= src.v55, ])[1]

stopifnot(src.n55 > src.n)
