## weaves
## Using an Isolated Forest

## From the command line, you can run the ShinyR app.
## R -e 'library(shiny); runApp(appDir="/home/share/R/site-library/isofor/shiny-examples/isofor-demo", launch.browser=FALSE)'

library(isofor)

## create dummy data
## a thousand samples at mean of 0 and little variance
## then and 5% added where mean is -1.5 (for x), +1.5 for y
N = 1e3
x = c(rnorm(N, 0, 0.25), rnorm(N*0.05, -1.5, 1))
y = c(rnorm(N, 0, 0.25), rnorm(N*0.05, 1.5, 1))

## The 5% will be marked differently
## Make a list of point shape markers for the plot for the (x,y) pairs.
## The +2 is to use two types of pch marker
pch = c(rep(0, N), rep(1, (0.05*N))) + 2

## Training data
d = data.frame(x, y)

## From those, build some data-points for a contour plot.
## Get the range for each column (x,y)
rngs = lapply(d, range)
## build 1 + 20 x points for each of the 1 + 20 y, ie. 21 * 21 = 441 in all
ex = do.call(expand.grid, lapply(rngs, function(x) seq(x[1], x[2], diff(x)/20)))

## Set some input parameters
input <- list()
input$ntree <- 100
input$depth <- 5
input$threshold <- 0.6

## create isolation forest model on the training data.
mod <- iForest(d, as.integer(input$ntree), phi=2^as.integer(input$depth))

## Calculate the anomaly scores, high is more anomalous
## nodes = TRUE returns a count of observations for each tree.
p <- predict(mod, d, n.cores=4L, nodes = FALSE)
## Plot with outliers coloured in red.
col = ifelse(p > input$threshold, "red", "blue")
plot(d, col = col, pch = pch, cex=2)
title("Dummy Data with Outliers")

## Build a contour plot, use the 
p = predict(mod, ex, iterative=TRUE)
plt = cbind(ex, z=p)
lattice::contourplot(z~x+y, plt, cuts=10, labels=TRUE, region=TRUE)
