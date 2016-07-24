## weaves
##
## Elasticities (or propensities or indifferences) from kdb - totals only
##

library(ggplot2)

## Clear all away: very important if you re-use names in
## functions.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}

load("wdi.Rdata", .GlobalEnv)

### Get data from q/kdb+ an write to local binary disk.

kdb.url <- "http://m1:5000/q.csv?select from hexpt0"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE, stringsAsFactors=TRUE)

save(folios.in, file="folios-in.dat")

## We can just look at the household data.

x0 <- folios.in[ folios.in$type0 == "h", ]

plot.ts(unstack(x0, r1 ~ Categories)[, 1:6], plot.type = "single")

plot.ts(unstack(x0, r1 ~ Categories)[, 7:12], plot.type = "single")

## Try a ggplot

x1 <- x0[, c("Categories", "time", "r1")]

jpeg(width=1024, height=768, filename = "fig-%03d.jpeg")

ggplot(data = x1, aes(x=time, y=r1)) + 
    geom_line(aes(linetype=Categories, colour=Categories))

dev.off()

### Now for the two classes

kdb.url <- "http://m1:5000/q.csv?select from hexp2"

kdb.url <- URLencode(kdb.url)
folios.in <- read.csv(kdb.url, header=TRUE, stringsAsFactors=TRUE)

save(folios.in, file="folios-ul.dat")

rm("folios.in")

load("folios-ul.dat", .GlobalEnv)

## We can just look at the household data.
##
## @todo
##
## When I do this for deciles, I will need to change "decile" to "cls"
## and make it a factor.

## fortunately, lower and upper will be 1 and 2

## Forming samples

## This concatenates for us; ifelse() didn't work.
x.cond0 <- function(x, y) {
    if (is.null(x)) {
        return(y)
    }

    return(rbind(x, y))
}

metric0 <- "x2tp"

r0 <- NULL
i0 <- 0

i0 <- i0+1
t0 <- levels(folios.in$type0)[i0]
left <- hexp.ustk(folios.in, type0=t0)
left1 <- stack(left)
colnames(left1) <- c(metric0, "Categories")
left1$type0 <- t0
r0 <- x.cond0(r0, left1)

i0 <- i0+1
t0 <- levels(folios.in$type0)[i0]
left <- hexp.ustk(folios.in, type0=t0)
left1 <- stack(left)
colnames(left1) <- c(metric0, "Categories")
left1$type0 <- t0
r0 <- x.cond0(r0, left1)

{
    r0$type0 <- as.factor(r0$type0)
    folios.in <- r0
    save(folios.in, file="folios-ul2.dat")
}

load("folios-ul2.dat", .GlobalEnv)

plot.ts(unstack(x0, r1 ~ Categories)[, 1:6], plot.type = "single")

plot.ts(unstack(x0, r1 ~ Categories)[, 7:12], plot.type = "single")

## Try a ggplot of upper to lower

x0 <- folios.in[ folios.in$type0 == "h", ]
x1 <- x0[, c("Categories", "time", "r1", "cls")]

jpeg(width=1024, height=768, filename = "fig-%03d.jpeg")

ggplot(data = x1, aes(x=time, y=r1)) + 
    geom_line(aes(linetype=cls, colour=Categories))

dev.off()

