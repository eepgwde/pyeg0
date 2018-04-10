## weaves
##
## Statistical testing examples
## http://rcompanion.org/handbook/D_01.html

rm(list=ls())
gc()

library(Rweaves)

## ANOVA method artificial blocks

## Scenario: fast food: 3 new menu items trialled at 6 restaurants.

## The null hypothesis is that the mean sales volume of the new menu
## items are all equal, ie. no one item is preferred over another.

## The blocking factor here is the restaurant. It shouldn't influence
## whether the new menu items are important.

## The theory is that we use the covariance 

## Var(X-Y) = Var(X) + Var(Y) - 2 Cov(X, Y)

## To minimize the variance of the difference (and maximize precision)
## by maximising the covariance (or correlation) between X and Y.

raw0 <- "Item1 Item2 Item3 
    31    27    24 
    31    28    31 
    45    29    46 
    21    18    48 
    42    36    46 
    32    17    40"

con <- textConnection(raw0)
df2 <- read.table(con, header=TRUE)
close(con)

r <- c(t(as.matrix(df2))) # response data 
f <- colnames(df2)        # treatment levels: menu items
k <- ncol(df2)            # treatment levels: count
n <- nrow(df2)            # control blocks: restaurants: count

## Generate levels for the menu items
tm <- gl(k, 1, n*k, factor(f))

## Blocking factors

blk <- gl(n, k, k*n)

## Use an ANOVA model

df3 <- data.frame(r, tm, blk)

av <- aov(r ~ tm + blk, data=df3)

## Note the starred term is tm, this gives the p-value of 0.0319
summary(av)

## Reject: the null hypothesis: the mean sales volume of the new menu
## items are all equal.

## Binomial proportion
## This uses the Clopper-Pearson method to produce confidence intervals.

raw0 <- "Experience   Count
Yes           7
No           14"

con <- textConnection(raw0)
df2 <- read.table(con, header=TRUE)
close(con)

p0 <- 1 / length(unique(df2$Experience))

binom.test(sum(df2$Count[ df2$Experience == "Yes"]), sum(df2$Count), 
           p0, alternative="two.sided", conf.level=0.95)


## The DescTools library provides BinomCI and other utilities

library(DescTools)

BinomCI(df2$Count, sum(df2$Count), 
        conf.level = 0.95,
        method = "clopper-pearson")


raw0 <- "Sex          Count
Female       10
Male          9
Other         1
No-answer     1"

con <- textConnection(raw0)
df2 <- read.table(con, header=TRUE)
close(con)


MultinomCI(df2$Count, conf.level = 0.95, method = "sisonglaz")

## PropCIs has 

library(PropCIs)

exactci(7, 21, conf.level=0.95)
blakerci(7, 21, conf.level=0.95)

## And can calculate Confidence Intervals for differences

7/21 - 13/17
diffscoreci(7, 21, 13, 17, conf.level=0.95)

## 



