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

## Fiddly way of getting the classes out. Use class not typeof and you don't get the factors.

x1 <- as.data.frame(as.matrix(sapply(flight, class)))

flight.num <- flight[,names(x1[which(x1$V1 %in% c("numeric", "integer")),])]

flight.nzv <- nearZeroVar(flight.num, saveMetrics = TRUE)
flight.nzv

flight.cor <- cor(flight.num, use = "pairwise.complete.obs")

highlyCorDescr <- findCorrelation(flight.cor, cutoff = .75, verbose=TRUE)

# Which tells me that row 1, column is very highly correlated to AVGSQ. 

flight[order(flight$SDEPHR), c("SDEPHR", "AVGSQ")]

corrplot::corrplot(flight.cor,
                   method="number")
