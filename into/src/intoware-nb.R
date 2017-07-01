### weaves

## These are my notes.
## I mostly keep visual elements in here.
## And I protype using a live and loaded R (one that has run flight0.R)

## weaves

## annoying NA should be gone.

m0 <- scale(as.matrix(w[['n']]))


cor <- cor(m0)
c1 <- cor[upper.tri(cor)]

corrplot(cor, method="circle", type="upper")


cor <- cor(m0, use = "pairwise.complete.obs")

df <- w[['n']]

clss <- class.columns(df, cls0="(factor|logical|integer)")

clss <- class.columns(df, cls0="factor")

df <- caret.numeric(w)

## Generic caret support

w.clss <- class.columns(w.w, cls0="(factor|numeric|logical|integer)")

w.x <- w.w[, colnames(w.w)[w.clss]]

w.nzv <- nearZeroVar(w.x, saveMetrics = TRUE)

w.zv <- rownames(w.nzv[w.nzv$zeroVar,])
m.names <- setdiff(colnames(w.w), w.zv)

w.w <- w.w[, m.names]

w.clss <- class.columns(w.w, cls0="(factor|numeric|logical|integer)")

w.x <- w.w[, colnames(w.w)[w.clss]]

## Things you notice. 

## AVGSKDAVAIL is related to AVAILBUCKET, but AVAILBUCKET is complete

## AVGLOFATC is zero at times? Must mean direct flight?

## Definitely a strong correlation to time of day, just by eye.

## I think this is time series data! departure < arrive unless
## hangared for the night or a very short flight.

## For the big data set, we have only 41 flights that arrive before
## they leave, some are very short flights, aargh! three types in all.

flight.raw <- read.csv("../bak/flight.csv")

library(corrplot)

library(Rweaves1)

cinto0 <- cor(into0)

corrplot(cinto0)

dim(flight.raw[which(flight.raw$SARRHR < flight.raw$SDEPHR), 
             c("SARRHR", "SDEPHR")])

## The flight duration is not related to AVGLOFATC, eg. Rio to Sao
## Paulo is less than an hour, ISTR, but it would be translantic from
## London

flight.raw[which(flight.raw$SARRHR == flight.raw$SDEPHR), 
         c("SARRHR", "SDEPHR", "AVGLOFATC")]

## For the probit, visual check.

plot(src.probit)

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

## It fitted fairly well, but slowly (1 min) on a small dataset.

## Some test code.

ses <- rbind(head(flight), tail(flight))

ses$LEGTYPE <- "Strong"

ses[which(ses$D00 <= src.55), "LEGTYPE" ] <- "Weak"

ses$LEGTYPE <- factor(ses$LEGTYPE)

## Post-check

src.l55 <- all(flight[ flight$D00 <= src.55, c("LEGTYPE")] == "Weak")
src.l55n <- any(flight[ flight$D00 > src.55, c("LEGTYPE")] == "Weak")

paste(src.l55, !src.l55n)

## More prototyping

grep("((STA|EQP)$)|(^x)", tr.cols)

## More prototyping for results.

x.p <- predict(gbmFit1, testDescr, type = "prob")[2]
test.df <- data.frame(Weak=x.p$Weak, Obs=testClass)
test.roc <- roc(Obs ~ Weak, test.df)

densityplot(~test.df$Weak, groups = test.df$Obs, auto.key = TRUE)

plot.roc(test.roc)
