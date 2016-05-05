### weaves

## 

## I'm supposed to improve on the probit model of D00
## but I'm relying on that to define LEGTYPE - to check my model.

## (In the notes, it did say the 80th percentile was defined
## wrt to the top eighty destinations.) That may have been a typo because
## D00 was defined over all 300 or so destinations.

## I'm going to fit the probit and find the D00 value for the 55th percentile.

## The raw data was sorted on D00 by Excel, I use this now.

is.between <- function(x, l, u) {
    x >= l & x <= u
}

src.probit <- ecdf(flight.raw$D00)

plot(src.probit)

## from the source data, their methodology is to use D80THPCTL
## ie. the 20th percentile.
src.80 <- 0.590909091
is.between(src.probit(src.80), 0.19, 0.21)

# Bottom 20% - a count
src.n0 <- sum(as.integer(
    is.between(src.probit(flight.raw$D00), 0, src.probit(src.80))
))

# Logic checks
src.l80 <- all(flight.raw[ flight.raw$D00 <= src.80, c("LEGTYPE")] == "Weak")
src.l80n <- any(flight.raw[ flight.raw$D00 > src.80, c("LEGTYPE")] == "Weak")

stopifnot(src.l80)
stopifnot(!src.l80n)

# By numbers, let n80 be the count of those under 20th percentile
src.n80 <- dim(flight.raw[ flight.raw$D00 <= src.80,])[1]

src.N <- dim(flight.raw)[1]

src.n80 / src.N

stopifnot(src.n80 == src.n)

## They saw an improvement to 45% detection ie. at src.55 ==  0.6969697
## I'm only to use an existing value and hope

src.i55 <- max(which(is.between(src.probit(flight.raw$D00), 0, 0.45)))
src.55 <- flight.raw$D00[src.i55]

src.n55 <-dim(flight.raw[ flight.raw$D00 <= src.v55, ])[1]

stopifnot(src.n55 > src.n)
