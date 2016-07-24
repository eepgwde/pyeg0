### weaves
## 
## Partial Least Squares - multi-variate output
## Unfortunately, there is no predictor for this.

library(plsdepot)

## This is some quite inventive data modelling. We use a data.frame() with duplicate column
## names to represent the Predictors and Responses for a multi-variate output PLS system.
## It doesn't do any predicting, but it's okay.
## 
## The idea is a state-machine. We column join x0 (the unstacked data-frame) with itself lagged.

## Predictors: add some rownames.

rownames(x0) <- as.character(2005:2016)

## Responses: take all the years after the first an only take the expenditure classes.
## Decrement the rownames (you don't use them, but they help if you get lost.)

x1 <- x0[2:nrow(x0), th$classes]
rownames(x1) <- as.character(as.integer(rownames(x1)) - 1)

## Drop the last row from the Predictors
x2 <- x0[1:(nrow(x0)-1),]

## Bind by column - allows duplicate columns.
x3 <- cbind(x2, x1)

## Responses are on the Right
right <- (ncol(x3) - length(th$classes) + 1):ncol(x3)

## Predictors are on the left.
left <- 1:(head(right, 1) - 1)

## Invoke plsreg2
p1 <- plsreg2(x3[, left], x3[, right], comps=2, crosval=FALSE)

## Plot the circle of correlations.
jpeg(width=1024, height=768, filename = "plsreg2-%03d.jpeg")

plot(p1)

dev.off()
