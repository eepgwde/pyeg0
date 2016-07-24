## vars: Rcode-1-1.R


set.seed(123456)
y <- arima.sim(n = 100, list(ar = 0.9), innov=rnorm(100))
op <- par(no.readonly=TRUE)
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow=TRUE))
plot.ts(y, ylab='')
acf(y, main='Autocorrelations', ylab='',
    ylim=c(-1, 1), ci.col = "black")
pacf(y, main='Partial Autocorrelations', ylab='',
     ylim=c(-1, 1), ci.col = "black")
par(op)


## vars: Rcode-1-2.R


series <-  rnorm(1000)
y.st <- filter(series, filter=c(0.6, -0.28),
               method='recursive')
ar2.st <- arima(y.st, c(2, 0, 0), include.mean=FALSE,
                transform.pars=FALSE, method="ML")
ar2.st$coef
polyroot(c(1, -ar2.st$coef))
Mod(polyroot(c(1, -ar2.st$coef)))
root.comp <- Im(polyroot(c(1, -ar2.st$coef)))
root.real <- Re(polyroot(c(1, -ar2.st$coef)))

## Plotting the roots in a unit circle

x <- seq(-1, 1, length = 1000)
y1 <- sqrt(1- x^2)
y2 <- -sqrt(1- x^2)
plot(c(x, x), c(y1, y2), xlab='Real part',
     ylab='Complex part', type='l',
     main='Unit Circle', ylim=c(-2, 2), xlim=c(-2, 2))
abline(h=0)
abline(v=0)
points(Re(polyroot(c(1, -ar2.st$coef))),
       Im(polyroot(c(1, -ar2.st$coef))), pch=19)
legend(-1.5, -1.5, legend="Roots of AR(2)", pch=19)


## vars: Rcode-1-3.R


library(urca)
data(npext)
npext
y <- ts(na.omit(npext$unemploy), start=1890, end=1988,
        frequency=1)
op <- par(no.readonly=TRUE)
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow=TRUE))
plot(y, ylab="unemployment rate (logarithm)")
acf(y, main='Autocorrelations', ylab='', ylim=c(-1, 1))
pacf(y, main='Partial Autocorrelations', ylab='',
     ylim=c(-1, 1))
par(op)

## tentative ARMA(2,0)

arma20 <- arima(y, order=c(2, 0, 0))
ll20 <- logLik(arma20)
aic20 <- arma20$aic
res20 <- residuals(arma20)
Box.test(res20, lag = 20, type =  "Ljung-Box")
shapiro.test(res20)

## alternative specifications


## ARMA(3,0)

arma30 <- arima(y, order=c(3, 0, 0))
ll30 <- logLik(arma30)
aic30 <- arma30$aic
lrtest <- as.numeric(2*(ll30 - ll20))
chi.pval <- pchisq(lrtest, df = 1, lower.tail = FALSE)

## ARMA(1,1)

arma11 <- arima(y, order = c(1, 0, 1))
ll11 <- logLik(arma11)
aic11 <- arma11$aic
tsdiag(arma11)
res11 <- residuals(arma11)
Box.test(res11, lag = 20, type =  "Ljung-Box")
shapiro.test(res11)
tsdiag(arma11)

## Using auto.arima()

library(forecast)
auto.arima(y, max.p = 3, max.q = 3, start.p = 1,
           start.q = 1, ic = "aic")


## vars: Rcode-1-4.R



## Forecasts

arma11.pred <- predict(arma11, n.ahead = 10)
predict <- ts(c(rep(NA, length(y) - 1), y[length(y)],
                arma11.pred$pred), start = 1909,
              frequency = 1)
upper <- ts(c(rep(NA, length(y) - 1), y[length(y)],
              arma11.pred$pred + 2 * arma11.pred$se),
            start = 1909, frequency = 1)
lower <- ts(c(rep(NA, length(y) - 1), y[length(y)],
              arma11.pred$pred - 2 * arma11.pred$se),
            start = 1909, frequency = 1)
observed <- ts(c(y, rep(NA, 10)), start=1909,
               frequency = 1)

## Plot of actual and forecasted values

plot(observed, type = "l",
     ylab = "Actual and predicted values", xlab = "")
lines(predict, col = "blue", lty = 2)
lines(lower, col = "red", lty = 5)
lines(upper, col = "red", lty = 5)
abline(v = 1988, col = "gray", lty = 3)


## vars: Rcode-2-1.R



## Simulate VAR(2)-data

library(dse1)
library(vars)

## Setting the lag-polynomial A(L)

Apoly   <- array(c(1.0, -0.5, 0.3, 0,
                   0.2, 0.1, 0, -0.2,
                   0.7, 1, 0.5, -0.3) ,
                 c(3, 2, 2))

## Setting Covariance to identity-matrix

B <- diag(2)

## Setting constant term to 5 and 10

TRD <- c(5, 10)

## Generating the VAR(2) model

var2  <- ARMA(A = Apoly, B = B, TREND = TRD)

## Simulating 500 observations

varsim <- simulate(var2, sampleT = 500,
                   noise = list(w = matrix(rnorm(1000),
nrow = 500, ncol = 2)), rng = list(seed = c(123456))) 

## Obtaining the generated series

vardat <- matrix(varsim$output, nrow = 500, ncol = 2)
colnames(vardat) <- c("y1", "y2")

## Plotting the series

plot.ts(vardat, main = "", xlab = "")

## Determining an appropriate lag-order

infocrit <- VARselect(vardat, lag.max = 3,
                      type = "const")

## Estimating the model

varsimest <- VAR(vardat, p = 2, type = "const",
                 season = NULL, exogen = NULL)

## Alternatively, selection according to AIC

varsimest <- VAR(vardat, type = "const",
                 lag.max = 3, ic = "SC")

## Checking the roots

roots <- roots(varsimest)


## vars: Rcode-2-2.R



## testing serial correlation

args(serial.test)

## Portmanteau-Test

var2c.serial <- serial.test(varsimest, lags.pt = 16,
                            type = "PT.asymptotic")
var2c.serial
plot(var2c.serial, names = "y1")
plot(var2c.serial, names = "y2")

## testing heteroscedasticity

args(arch.test)
var2c.arch <- arch.test(varsimest, lags.multi = 5,
                        multivariate.only = TRUE)
var2c.arch

## testing for normality

args(normality.test)
var2c.norm <- normality.test(varsimest,
                             multivariate.only = TRUE)
var2c.norm

## class and methods for diganostic tests

class(var2c.serial)
class(var2c.arch)
class(var2c.norm)
methods(class = "varcheck")

## Plot of objects "varcheck"

args(vars:::plot.varcheck)
plot(var2c.serial, names = "y1")


## vars: Rcode-2-3.R


reccusum <- stability(varsimest,
    type = "OLS-CUSUM")
fluctuation <- stability(varsimest,
    type = "fluctuation")


## vars: Rcode-2-4.R



## Causality tests


## Granger and instantaneous causality

var.causal <- causality(varsimest, cause = "y2")


## vars: Rcode-2-5.R



## Forecasting objects of class varest

args(vars:::predict.varest)
predictions <- predict(varsimest, n.ahead = 25,
                       ci = 0.95)
class(predictions)
args(vars:::plot.varprd)

## Plot of predictions for y1

plot(predictions, names = "y1")

## Fanchart for y2

args(fanchart)
fanchart(predictions, names = "y2")


## vars: Rcode-2-6.R



## Impulse response analysis

irf.y1 <- irf(varsimest, impulse = "y1",
              response = "y2", n.ahead = 10,
              ortho = FALSE, cumulative = FALSE,
              boot = FALSE, seed = 12345)
args(vars:::plot.varirf)
plot(irf.y1)
irf.y2 <- irf(varsimest, impulse = "y2",
              response = "y1", n.ahead = 10,
              ortho = TRUE, cumulative = TRUE,
              boot = FALSE, seed = 12345)
plot(irf.y2)


## vars: Rcode-2-7.R



## Forecast error variance decomposition

fevd.var2 <- fevd(varsimest, n.ahead = 10)
args(vars:::plot.varfevd)
plot(fevd.var2, addbars = 2)


## vars: Rcode-2-8.R


library(dse1)
library(vars)

## A-model

Apoly   <- array(c(1.0, -0.5, 0.3, 0.8,
                   0.2, 0.1, -0.7, -0.2,
                   0.7, 1, 0.5, -0.3) ,
                 c(3, 2, 2))

## Setting covariance to identity-matrix

B <- diag(2)

## Generating the VAR(2) model

svarA  <- ARMA(A = Apoly, B = B)

## Simulating 500 observations

svarsim <- simulate(svarA, sampleT = 500,
                    rng = list(seed = c(123456)))

## Obtaining the generated series

svardat <- matrix(svarsim$output, nrow = 500, ncol = 2)
colnames(svardat) <- c("y1", "y2")

## Estimating the VAR

varest <- VAR(svardat, p = 2, type = "none")

## Setting up matrices for A-model

Amat <- diag(2)
Amat[2, 1] <- NA
Amat[1, 2] <- NA

## Estimating the SVAR A-type by direct maximisation


## of the log-likelihood

args(SVAR)
svar.A <- SVAR(varest, estmethod = "direct",
               Amat = Amat, hessian = TRUE)


## vars: Rcode-2-9.R


library(dse1)
library(vars)

## B-model

Apoly   <- array(c(1.0, -0.5, 0.3, 0,
                   0.2, 0.1, 0, -0.2,
                   0.7, 1, 0.5, -0.3) ,
                 c(3, 2, 2))

## Setting covariance to identity-matrix

B <- diag(2)
B[2, 1] <- -0.8

## Generating the VAR(2) model

svarB  <- ARMA(A = Apoly, B = B)

## Simulating 500 observations

svarsim <- simulate(svarB, sampleT = 500,
                    rng = list(seed = c(123456)))
svardat <- matrix(svarsim$output, nrow = 500, ncol = 2)
colnames(svardat) <- c("y1", "y2")
varest <- VAR(svardat, p = 2, type = "none")

## Estimating the SVAR B-type by scoring algorithm


## Setting up the restriction matrix and vector


## for B-model

Bmat <- diag(2)
Bmat[2, 1] <- NA
svar.B <- SVAR(varest, estmethod = "scoring",
               Bmat = Bmat, max.iter = 200)


## vars: Rcode-2-10.R



## Impulse response analysis of SVAR A-type model

args(vars:::irf.svarest)
irf.svara <- irf(svar.A, impulse = "y1",
                 response = "y2", boot = FALSE)
args(vars:::plot.varirf)
plot(irf.svara)


## vars: Rcode-2-11.R



## FEVD analysis of SVAR B-type model

args(vars:::fevd.svarest)
fevd.svarb <- fevd(svar.B, n.ahead = 5)
class(fevd.svarb)
methods(class = "varfevd")
plot(fevd.svarb)


## vars: Rcode-3-1.R


set.seed(123456)
e <- rnorm(500)

## pure random walk

rw.nd <- cumsum(e)

## trend

trd <- 1:500

## random walk with drift

rw.wd <- 0.5*trd + cumsum(e)

## deterministic trend and noise

dt <- e + 0.5*trd

## plotting

par(mar=rep(5,4))
plot.ts(dt, lty=1, ylab='', xlab='')
lines(rw.wd, lty=2)
par(new=T)
plot.ts(rw.nd, lty=3, axes=FALSE)
axis(4, pretty(range(rw.nd)))
lines(rw.nd, lty=3)
legend(10, 18.7, legend=c('det. trend + noise (ls)',
                   'rw drift (ls)', 'rw (rs)'),
       lty=c(1, 2, 3)) 


## vars: Rcode-3-2.R


library(fracdiff)
set.seed(123456)

## ARFIMA(0.4,0.4,0.0)

y1 <- fracdiff.sim(n=1000, ar=0.4, ma=0.0, d=0.4)

## ARIMA(0.4,0.0,0.0)

y2 <- arima.sim(model=list(ar=0.4), n=1000)

## Graphics

op <- par(no.readonly=TRUE)
layout(matrix(1:6, 3, 2, byrow=FALSE))
plot.ts(y1$series,
        main='Time series plot of long memory',
        ylab='')
acf(y1$series, lag.max=100,
    main='Autocorrelations of long memory')
spectrum(y1$series,
         main='Spectral density of long memory')
plot.ts(y2,
        main='Time series plot of short memory', ylab='')
acf(y2, lag.max=100,
    main='Autocorrelations of short memory')
spectrum(y2, main='Spectral density of short memory')
par(op)


## vars: Rcode-3-3.R


library(fracdiff)
set.seed(123456)

## ARFIMA(0.0,0.3,0.0)

y <- fracdiff.sim(n=1000, ar=0.0, ma=0.0, d=0.3)

## Get the data series, demean this if necessary

y.dm <- y$series 
max.y <- max(cumsum(y.dm))
min.y <- min(cumsum(y.dm))
sd.y <- sd(y$series)
RS <- (max.y - min.y)/sd.y 
H <- log(RS)/log(1000)
d <- H - 0.5


## vars: Rcode-3-4.R


library(fracdiff)
set.seed(123456)
y <- fracdiff.sim(n=1000, ar=0.0, ma=0.0, d=0.3)
y.spec <- spectrum(y$series, plot=FALSE)
lhs <- log(y.spec$spec)
rhs <- log(4*(sin(y.spec$freq/2))^2)
gph.reg <- lm(lhs ~ rhs)
gph.sum <- summary(gph.reg)
sqrt(gph.sum$cov.unscaled*pi/6)[2,2]


## vars: Rcode-4-1.R


library(lmtest)
set.seed(123456)
e1 <- rnorm(500)
e2 <- rnorm(500)
trd <- 1:500
y1 <- 0.8*trd + cumsum(e1)
y2 <- 0.6*trd + cumsum(e2)
sr.reg <- lm(y1 ~ y2)
sr.dw <- dwtest(sr.reg)$statistic


## vars: Rcode-4-2.R


set.seed(123456)
e1 <- rnorm(100)
e2 <- rnorm(100)
y1 <- cumsum(e1)
y2 <- 0.6*y1 + e2
lr.reg <- lm(y2 ~ y1)
error <- residuals(lr.reg)
error.lagged <- error[-c(1, 100)]
dy1 <- diff(y1)
dy2 <- diff(y2)
diff.dat <- data.frame(embed(cbind(dy1, dy2), 2))
colnames(diff.dat) <- c('dy1', 'dy2', 'dy1.1', 'dy2.1')
ecm.reg <- lm(dy2 ~ error.lagged + dy1.1 + dy2.1,
              data=diff.dat)


## vars: Rcode-4-3.R


library(urca)
set.seed(12345)
e1 <- rnorm(250, 0, 0.5)
e2 <- rnorm(250, 0, 0.5)
e3 <- rnorm(250, 0, 0.5)
u1.ar1 <- arima.sim(model = list(ar = 0.75),
                    innov = e1, n = 250)
u2.ar1 <- arima.sim(model = list(ar = 0.3),
                    innov = e2, n = 250)
y3 <- cumsum(e3)
y1 <- 0.8 * y3 + u1.ar1
y2 <- -0.3 * y3 + u2.ar1
y.mat <- data.frame(y1, y2, y3)
vecm <- ca.jo(y.mat)
jo.results <- summary(vecm)
vecm.r2 <- cajorls(vecm, r = 2)
class(jo.results)
slotNames(jo.results)





## vars: Rcode-4-4.R


library(vars)
vecm.level <- vec2var(vecm, r = 2)
arch.test(vecm.level)
normality.test(vecm.level)
serial.test(vecm.level)
predict(vecm.level)
irf(vecm.level, boot = FALSE)
fevd(vecm.level)
class(vecm.level)
methods(class = "vec2var")


## vars: Rcode-5-1.R


library(urca)
data(Raotbl3)
attach(Raotbl3)
lc <- ts(lc, start=c(1966,4), end=c(1991,2), frequency=4)
lc.ct <- ur.df(lc, lags=3, type='trend')
plot(lc.ct)
lc.co <- ur.df(lc, lags=3, type='drift')
lc2 <- diff(lc)
lc2.ct <- ur.df(lc2, type='trend', lags=3)


## vars: Rcode-5-2.R


library(urca)
data(Raotbl3)
attach(Raotbl3)
lc <- ts(lc, start=c(1966,4), end=c(1991,2),
         frequency=4)
lc.ct <- ur.pp(lc, type='Z-tau', model='trend',
               lags='long')
lc.co <- ur.pp(lc, type='Z-tau', model='constant',
               lags='long')
lc2 <- diff(lc)
lc2.ct <- ur.pp(lc2, type='Z-tau', model='trend',
                lags='long')


## vars: Rcode-5-3.R


library(urca)
data(nporg)
gnp <- log(na.omit(nporg[, "gnp.r"]))
gnp.d <- diff(gnp)
gnp.ct.df <- ur.ers(gnp, type = "DF-GLS",
                    model = "trend", lag.max = 4)
gnp.ct.pt <- ur.ers(gnp, type = "P-test",
                    model = "trend")
gnp.d.ct.df <- ur.ers(gnp.d, type = "DF-GLS",
                      model = "trend", lag.max = 4)
gnp.d.ct.pt <- ur.ers(gnp.d, type = "P-test",
                      model = "trend")


## vars: Rcode-5-4.R


library(urca)
data(nporg)
gnp <- na.omit(nporg[, "gnp.n"])
gnp.tau.sp <- ur.sp(gnp, type = "tau", pol.deg=2,
                    signif=0.05)
gnp.rho.sp <- ur.sp(gnp, type = "rho", pol.deg=2,
                    signif=0.05)


## vars: Rcode-5-5.R


library(urca)
data(nporg)
ir <- na.omit(nporg[, "bnd"])
wg <- log(na.omit(nporg[, "wg.n"]))
ir.kpss <- ur.kpss(ir, type = "mu", use.lag=8)
wg.kpss <- ur.kpss(wg, type = "tau", use.lag=8)


## vars: Rcode-6-1.R


set.seed(123456)
e <- rnorm(500)

## trend

trd <- 1:500
S <- c(rep(0, 249), rep(1, 251))

## random walk with drift

y1 <- 0.1*trd + cumsum(e)

## random walk with drift and shift

y2 <- 0.1*trd + 10*S + cumsum(e)


## vars: Rcode-6-2.R


library(urca)
data(nporg)
wg.n <- log(na.omit(nporg[, "wg.n"]))
za.wg.n <- ur.za(wg.n, model = "intercept", lag = 7)

## plot(za.wg.n)

wg.r <- log(na.omit(nporg[, "wg.r"]))
za.wg.r <- ur.za(wg.r, model = "both", lag = 8)

## plot(za.wg.r)



## vars: Rcode-6-3.R


library(urca)
library(uroot)
data(UKconinc)
incl <- ts(UKconinc$incl, start = c(1955,1),
           end = c(1984,4), frequency = 4)
HEGY000 <- HEGY.test(wts = incl, itsd = c(0, 0, c(0)),
                     selectlags = list(mode = c(1,4,5)))
HEGY100 <- HEGY.test(wts = incl, itsd = c(1, 0, c(0)),
                     selectlags = list(mode = c(1,4,5)))
HEGY110 <- HEGY.test(wts = incl, itsd = c(1, 1, c(0)),
                     selectlags = list(mode = c(1,4,5)))
HEGY101 <- HEGY.test(wts = incl,
                     itsd = c(1, 0, c(1, 2, 3)),
                     selectlags = list(mode = c(1,4,5)))
HEGY111 <- HEGY.test(wts = incl,
                     itsd = c(1, 1, c(1, 2, 3)),
                     selectlags = list(mode = c(1,4,5)))


## vars: Rcode-7-1.R


library(tseries)
library(urca)
data(Raotbl3)
attach(Raotbl3)
lc <- ts(lc, start=c(1966,4), end=c(1991,2),
         frequency=4)
li <- ts(li, start=c(1966,4), end=c(1991,2),
         frequency=4)
lw <- ts(lw, start=c(1966,4), end=c(1991,2),
         frequency=4)
ukcons <- window(cbind(lc, li, lw), start=c(1967, 2),
                 end=c(1991,2))
lc.eq <- summary(lm(lc ~ li + lw, data=ukcons))
li.eq <- summary(lm(li ~ lc + lw, data=ukcons))
lw.eq <- summary(lm(lw ~ li + lc, data=ukcons))
error.lc <- ts(resid(lc.eq), start=c(1967,2),
               end=c(1991,2), frequency=4)
error.li <- ts(resid(li.eq), start=c(1967,2),
               end=c(1991,2), frequency=4)
error.lw <- ts(resid(lw.eq), start=c(1967,2),
               end=c(1991,2), frequency=4)
ci.lc <- ur.df(error.lc, lags=1, type='none')
ci.li <- ur.df(error.li, lags=1, type='none')
ci.lw <- ur.df(error.lw, lags=1, type='none')
jb.lc <- jarque.bera.test(error.lc)
jb.li <- jarque.bera.test(error.li)
jb.lw <- jarque.bera.test(error.lw)


## vars: Rcode-7-2.R


ukcons2 <- ts(embed(diff(ukcons), dim=2),
              start=c(1967,4), freq=4)
colnames(ukcons2) <- c('lc.d', 'li.d', 'lw.d',
                       'lc.d1', 'li.d1', 'lw.d1')
error.ecm1 <- window(lag(error.lc, k=-1),
                     start=c(1967,4), end=c(1991, 2))
error.ecm2 <- window(lag(error.li, k=-1),
                     start=c(1967,4), end=c(1991, 2))
ecm.eq1 <- lm(lc.d ~ error.ecm1 + lc.d1 + li.d1 + lw.d1,
              data=ukcons2)
ecm.eq2 <- lm(li.d ~ error.ecm2 + lc.d1 + li.d1 + lw.d1,
              data=ukcons2)


## vars: Rcode-7-3.R


library(urca)
data(Raotbl3)
attach(Raotbl3)
lc <- ts(lc, start=c(1966,4), end=c(1991,2),
         frequency=4)
li <- ts(li, start=c(1966,4), end=c(1991,2),
         frequency=4)
lw <- ts(lw, start=c(1966,4), end=c(1991,2),
         frequency=4)
ukcons <- window(cbind(lc, li, lw), start=c(1967, 2),
                 end=c(1991,2))
pu.test <- summary(ca.po(ukcons, demean='const',
                         type='Pu'))
pz.test <- summary(ca.po(ukcons, demean='const',
                         type='Pz'))


## vars: Rcode-8-1.R


library(urca)
data(UKpppuip)
names(UKpppuip)
attach(UKpppuip)
dat1 <- cbind(p1, p2, e12, i1, i2)
dat2 <- cbind(doilp0, doilp1)
args('ca.jo')
H1 <- ca.jo(dat1, type = 'trace', K = 2, season = 4,
            dumvar = dat2)
H1.trace <- summary(ca.jo(dat1, type = 'trace', K = 2,
                          season = 4, dumvar = dat2))
H1.eigen <- summary(ca.jo(dat1, type = 'eigen', K = 2,
                          season = 4, dumvar = dat2))


## vars: Rcode-8-2.R


beta <- H1@V
beta[,2] <- beta[,2]/beta[4,2]
beta[,3] <- beta[,3]/beta[4,3]
alpha <- H1@PI%*%solve(t(beta))
beta1 <- cbind(beta[,1:2], H1@V[,3:5]) 
ci.1 <- ts((H1@x%*%beta1)[-c(1,2),], start=c(1972, 3),
           end=c(1987, 2), frequency=4)
ci.2 <- ts(H1@RK%*%beta1, start=c(1972, 3),
           end=c(1987, 2), frequency=4)


## vars: Rcode-8-3.R


A1 <- matrix(c(1,0,0,0,0, 0,0,1,0,0,
               0,0,0,1,0, 0,0,0,0,1),
             nrow=5, ncol=4)
A2 <- matrix(c(1,0,0,0,0, 0,1,0,0,0,
               0,0,1,0,0, 0,0,0,1,0),
             nrow=5, ncol=4)
H41 <- summary(alrtest(z = H1, A = A1, r = 2))
H42 <- summary(alrtest(z = H1, A = A2, r = 2))


## vars: Rcode-8-4.R


H.31 <- matrix(c(1,-1,-1,0,0, 0,0,0,1,0, 0,0,0,0,1),
               c(5,3))
H.32 <- matrix(c(1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0,
                 0,0,0,1,-1), c(5,4))
H31 <- summary(blrtest(z = H1, H = H.31, r = 2))
H32 <- summary(blrtest(z = H1, H = H.32, r = 2))


## vars: Rcode-8-5.R


H.51 <- c(1, -1, -1, 0, 0)
H.52 <- c(0, 0, 0, 1, -1)
H51 <- summary(bh5lrtest(z = H1, H = H.51, r = 2))
H52 <- summary(bh5lrtest(z = H1, H = H.52, r = 2))


## vars: Rcode-8-6.R


H.6 <- matrix(rbind(diag(3), c(0, 0, 0), c(0, 0, 0)),
              nrow=5, ncol=3)
H6 <- summary(bh6lrtest(z = H1, H = H.6,
                        r = 2, r1 = 1))


## vars: Rcode-8-7.R


data(denmark)
sjd <- denmark[, c("LRM", "LRY", "IBO", "IDE")]
sjd.vecm <- summary(ca.jo(sjd, ecdet = "const",
                          type = "eigen",
                          K = 2,
                          spec = "longrun",
                          season = 4))
lue.vecm <- summary(cajolst(sjd, season=4))


## vars: Rcode-8-8.R


library(vars)
data(Canada)
summary(Canada)
plot(Canada, nc = 2)


## vars: Rcode-8-9.R


summary(ur.df(Canada[, "prod"],
              type = "trend", lags = 2))
summary(ur.df(diff(Canada[, "prod"]),
              type = "drift", lags = 1))
summary(ur.df(Canada[, "e"],
              type = "trend", lags = 2))
summary(ur.df(diff(Canada[, "e"]),
              type = "drift", lags = 1))
summary(ur.df(Canada[, "U"],
              type = "drift", lags = 1))
summary(ur.df(diff(Canada[, "U"]),
              type = "none", lags = 0))
summary(ur.df(Canada[, "rw"],
              type = "trend", lags = 4))
summary(ur.df(diff(Canada[, "rw"]),
              type = "drift", lags = 3))
summary(ur.df(diff(Canada[, "rw"]),
              type = "drift", lags = 0))



## vars: Rcode-8-10.R


VARselect(Canada, lag.max = 8, type = "both")


## vars: Rcode-8-11.R


Canada <- Canada[, c("prod", "e", "U", "rw")]
p1ct <- VAR(Canada, p = 1, type = "both")
p2ct <- VAR(Canada, p = 2, type = "both")
p3ct <- VAR(Canada, p = 3, type = "both")

## Serial

serial.test(p3ct, lags.pt = 16,
            type = "PT.asymptotic")
serial.test(p2ct, lags.pt = 16,
            type = "PT.asymptotic")
serial.test(p1ct, lags.pt = 16,
            type = "PT.asymptotic")
serial.test(p3ct, lags.pt = 16,
            type = "PT.adjusted")
serial.test(p2ct, lags.pt = 16,
            type = "PT.adjusted")
serial.test(p1ct, lags.pt = 16,
            type = "PT.adjusted")

## JB

normality.test(p3ct)
normality.test(p2ct)
normality.test(p1ct)

## ARCH

arch.test(p3ct, lags.multi = 5)
arch.test(p2ct, lags.multi = 5)
arch.test(p1ct, lags.multi = 5)

## Stability (Recursive CUSUM)

plot(stability(p3ct), nc = 2)
plot(stability(p2ct), nc = 2)
plot(stability(p1ct), nc = 2)


## vars: Rcode-8-12.R


summary(ca.jo(Canada, type = "trace",
              ecdet = "trend", K = 3,
              spec = "transitory"))
summary(ca.jo(Canada, type = "trace",
              ecdet = "trend", K = 2,
              spec = "transitory"))


## vars: Rcode-8-13.R


vecm <- ca.jo(Canada[, c("rw", "prod", "e", "U")],
              type = "trace", ecdet = "trend",
              K = 3, spec = "transitory")
vecm.r1 <- cajorls(vecm, r = 1)
alpha <- coef(vecm.r1$rlm)[1, ]
beta <- vecm.r1$beta
resids <- resid(vecm.r1$rlm)
N <- nrow(resids)
sigma <- crossprod(resids) / N

## t-stats for alpha

alpha.se <- sqrt(solve(crossprod(
                 cbind(vecm@ZK %*% beta, vecm@Z1)))
                 [1, 1]* diag(sigma))
alpha.t <- alpha / alpha.se

## t-stats for beta

beta.se <- sqrt(diag(kronecker(solve(
                crossprod(vecm@RK[, -1])),
                solve(t(alpha) %*% solve(sigma)
                %*% alpha))))
beta.t <- c(NA, beta[-1] / beta.se)


## vars: Rcode-8-14.R


vecm <- ca.jo(Canada[, c("prod", "e", "U", "rw")],
              type = "trace", ecdet = "trend",
              K = 3, spec = "transitory")
SR <- matrix(NA, nrow = 4, ncol = 4)
SR[4, 2] <- 0
SR
LR <- matrix(NA, nrow = 4, ncol = 4)
LR[1, 2:4] <- 0
LR[2:4, 4] <- 0
LR
svec <- SVEC(vecm, LR = LR, SR = SR, r = 1,
             lrtest = FALSE,
             boot = TRUE, runs = 100)
svec
svec$SR / svec$SRse
svec$LR / svec$LRse


## vars: Rcode-8-15.R


LR[3, 3] <- 0
LR
svec.oi <- SVEC(vecm, LR = LR, SR = SR, r = 1,
                lrtest = TRUE, boot = FALSE)
svec.oi <- update(svec, LR = LR, lrtest = TRUE,
                  boot = FALSE)
svec.oi$LRover


## vars: Rcode-8-16.R


svec.irf <- irf(svec, response = "U",
                n.ahead = 48, boot = TRUE)
svec.irf
plot(svec.irf)




## vars: Rcode-8-17.R


fevd.U <- fevd(svec, n.ahead = 48)$U


