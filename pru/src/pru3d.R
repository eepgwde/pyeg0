### weaves
## 
## Partial Least Squares - multi-variate input and output
## Fast, accurate and stable.

require(plsdepot)
require(pls)
require(parallel)

## This is some quite inventive data modelling. We use a data.frame() with duplicate column
## names to represent the Predictors and Responses for a multi-variate output PLS system.
## It doesn't do any predicting, but it's okay.
## 
## The idea is a state-machine. We column join x0 (the unstacked data-frame) with itself lagged.

## Predictors: add some rownames.

x0 <- th$train

## Responses: take all the years after the first and only take the expenditure classes.
## Decrement the rownames (you don't use them, but they help if you get lost.)

x1 <- x0[2:nrow(x0), th$classes]

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

## @note
## plsreg2 cannot predict, so we use the pls package and the same data structure.

xin <- as.matrix(x3[, left])            # ie. with GDP and other WDI
yout <- as.matrix(x3[, right])          # only the expenditures, but from next year

## Note the use of the protect I() operator, it loads the whole matrix
## as one entity into the data frame

xdf <- data.frame(I(yout), I(xin))

## Parallel
pls.options(parallel = 4)               # use mclapply

## Then ask it to apply a formula
xpls <- plsr(yout ~ xin, data = xdf, scale = FALSE, validation = "CV")
xpls

jpeg(width=1024, height=768, filename = "pls-%03d.jpeg")

plot(RMSEP(xpls), legendpos="topright")

## @todo
## Variable importance

dev.off()

## Predict
## Take the test data-set - our best guess for 2016

xin1 <- as.matrix(th$test)

## Note again the use of the protect operator I()
pred <- predict(xpls, newdata = I(xin1))

## Go through the ncomps predictions
t0 <- sapply(1:dim(pred)[3], 
             function(x) { return(as.data.frame.pls.pred(pred, i0=x)) })

t0 <- as.data.frame(t0)

## Find the one with the least error relative to their predictions

e0 <- sapply(t0, function(x) { return(err.rmser(x, th$test0[, th$classes])) })
e1 <- as.integer(which(min(e0) == e0))

fmt0 <- "Min Root Mean Square Ratio: %5.2f%% ; ncomps: %d"
print(sprintf(fmt0, 100 * as.numeric(e0[e1]), e1))
