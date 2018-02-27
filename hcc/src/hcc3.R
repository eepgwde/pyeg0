## weaves
##
## Following petolau
## https://github.com/PetoLau/petolau.github.io.git

rm(list=ls())
gc()

## Key library is mgcv

library(mgcv)
library(car)
library(ggplot2)
library(grid)
library(caret)

source("brA0.R")

source("hcc0a.R")

hcc3.data <- data0

## Deltas are no better, tmin and af seem best for enqs
corr1 <- cor(as.matrix(data0[, colnames(data0) %in% c(types, wthrs, dts) ]))

## Not an especially good correlation to weather, but good on month.
corrplot::corrplot(corr1, method="number", order="hclust")

## Let's look at some data chunk of consumption and try do some regression analysis.

stopifnot(any(types == "enqs"))

## Change the name to something generic
c0 <- colnames(data0)
c0[c0 == "enqs"] <- "value"
colnames(data0) <- c0

p1 <- ggplot(data0, aes(dt0, value)) +
  geom_line() +
  theme(panel.border = element_blank(), panel.background = element_blank(), panel.grid.minor = element_line(colour = "grey90"),
        panel.grid.major = element_line(colour = "grey90"), panel.grid.major.x = element_line(colour = "grey90"),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 12, face = "bold")) +
    labs(x = "Date", y = "count")

p2 <- ggplot(data0, aes(dt0, tmin)) +
  geom_line() +
  theme(panel.border = element_blank(), panel.background = element_blank(), panel.grid.minor = element_line(colour = "grey90"),
        panel.grid.major = element_line(colour = "grey90"), panel.grid.major.x = element_line(colour = "grey90"),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 12, face = "bold")) +
    labs(x = "Date", y = "tmin")

p3 <- ggplot(data0, aes(dt0, af)) +
  geom_line() +
  theme(panel.border = element_blank(), panel.background = element_blank(), panel.grid.minor = element_line(colour = "grey90"),
        panel.grid.major = element_line(colour = "grey90"), panel.grid.major.x = element_line(colour = "grey90"),
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 12, face = "bold")) +
    labs(x = "Date", y = "af")

## View three key metrics together
multiplot(p1, p2, p3)


## theory: GLM: Iteratively Re-weighted Least Squares (IRLS)
## theory: GAM: Penalized Iteratively Re-weighted Least Squares (P-IRLS)
## k -> (knots) is upper boundery for EDF...how smooth fitted value will be (more knots more overfit (under smoothed), less more smooth) 
## bs -> basis function..type of smoothing function
## dimension can be fixed by fx = TRUE
## EDF (trace of influence matrix) and lambda (smoothing factor) is estimated (tuned) by GCV, UBRE or REML, we will use the default GCV (Generalized Cross Validation) (more in Woods)
## basis function: I will use "cr" - cubic regression spline or "ps", which is P-spline (more in Woods).
## More options: "cc" cyclic cubic regression spline (good too with our problem), default is "tp" thin plane spline
## family - how response is fitted -> gaussian, log_norm, gamma, log_gamma is our possibilities, but gaussian is most variable in practice because gamma distibution must have only positive values
## gamm - possibility to add autocorrelation for errors

## GAM 1

## TODO - not used
period <- 12
N <- nrow(data0)
window <- N / period # number of days in the train set

family0 <- gaussian
family0 <- ziP                          # locks up
family0 <- Tweedie                      # needs setting

family0 <- poisson(link="identity")
family0 <- gaussian(link="log")

## Store GAMs in here

gs <- list()

## GAM 1

## I've introduced weights hoping to boost later samples

wts <- 1:dim(data0)[1]

## Oddly, these don't need to be reversed. This suggests, the enquiries are
## becoming more independent from the weather.
wts <- ewma(c(1, rep(0, length(wts) - 1)), lambda=1-0.90)
wts <- wts / mean(wts)


tag <- "mm1+tmin+af"
gam0 <- gam(value ~ s(tmin, bs = "ps") +
                s(mm1, bs = "ps") +
                s(tmin, bs = "ps") +
                s(af, bs = "ps"),
            weights = wts,
            data = data0,
            family = family0)

gam0[["name0"]] <- tag
gs[[tag]] <- gam0

hcc.gamS(gam0, force0=TRUE)       # just to start with
hcc.chart(gam0, tbl=data0, ctr0=tag)

## GAM 2 - af is important

if (1==0) {

    tag <- "mm1,tmin"
    gam0 <- gam(value ~ s(mm1, tmin) + s(mm1, af), data = data0, family = family0)

    gam0[["name0"]] <- tag
    gs[[tag]] <- gam0

    hcc.gamS(gam0)
    hcc.chart(gam0)

}

## GAM 3 - try a tensor

tag <- "te: mm1,af"
gam0 <- gam(value ~ te(mm1, tmin, bs = c("cr", "ps")),
            data = data0,
            weights = wts,
            family = family0)

gam0[["name0"]] <- tag
gs[[tag]] <- gam0

hcc.gamS(gam0)
hcc.chart(gam0)

sapply(gs, AIC)

## GAM 3a

## spline the month and tensor the tmin and af

tag <- "mm1 + te: tmin,af"
gam0 <- gam(value ~ s(mm1, bs = c("cr")) + te(tmin, af, bs = c("cr", "ps")),
            data = data0,
            weights = wts,
            family = family0)

gam0[["name0"]] <- tag
gs[[tag]] <- gam0

hcc.gamS(gam0)
hcc.chart(gam0)

sapply(gs, AIC)

## GAM 4

tag <- "t2: mm1, af + t2: mm1, tmin"
gam0 <- gam(value ~ t2(mm1, af, bs = c("cr", "ps")) + 
                t2(mm1, tmin, bs = c("cr", "ps")),
            data = data0,
            weights = wts,
            family = family0)

gam0[["name0"]] <- tag
gs[[tag]] <- gam0

hcc.gamS(gam0)
hcc.chart(gam0)

sapply(gs, AIC)

## Seems gam3 is best
## Look at autocorrelation of residuals

l0 <- sapply(gs, function(x) summary(x)$r.sq)

l0 <- sort(l0, decreasing=TRUE)

gs <- gs[names(l0)]

gam0 <- gs[[1]]

jpeg(filename=paste("hcc3", "-%03d.jpeg", sep=""), 
     width=800, height=600)

## Not an especially good correlation to weather, but good on month.
corrplot::corrplot(corr1, method="number", order="hclust")

lapply(gs, function(x) hcc.chart(x, tbl=NULL, nocoef=TRUE))

layout(matrix(1:2, ncol = 2))
acf(resid(gam0), lag.max = 18, main = "ACF")
pacf(resid(gam0), lag.max = 18, main = "pACF")

## Try out predict()

pdf1 <- data0[, c("value", "dt0", "mm1", "af", "tmin")]
pdf2 <- pdf1

## write out some base values and append to them
if (1==0) {
    write.csv(pdf2, file="pdf2.csv", row.names=FALSE)
}

pdf2 <- read.csv("pdf2.csv")
pdf2 <- tail(pdf2, 10)

pdf2$value <- predict(gam0, pdf2[, c("dt0", "mm1", "af", "tmin")])

if (gam0$family$link == "log") {
    pdf2$value <- exp(pdf2$value)
}

hcc.chart1(pdf1, pdf2, name0=gam0$name)

write.csv(pdf2, file="pdf2r.csv", row.names=FALSE)

wthr2enqs <- pdf2

## End: enquiries from temperature, month and frost

dev.off()

save(gam0, wthr2enqs, file="hcc3.dat")
