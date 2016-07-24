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


xin <- as.matrix(x3[, left])
yout <- as.matrix(x3[, right])

xdf <- data.frame(I(yout), I(xin))

xpls <- plsr(yout ~ xin, data = xdf, scale = FALSE)
xpls

plot(RMSEP(xpls), legendpos="topright")

xin1 <- as.matrix(as.matrix(th$test))

pred <- predict(xpls, newdata = I(xin1))

## Take the last ncomps value
t0 <- sapply(1:dim(pred)[3], 
             function(x) { return(as.data.frame.pls.pred(pred, i0=x)) })

t0 <- as.data.frame(t0)

e0 <- sapply(t0, function(x) { return(err.rmser(x, th$test0[, th$classes])) })
e1 <- as.integer(which(min(e0) == e0))

print(sprintf("min-error: %5.2f%% ; ncomps: %d", 100 * as.numeric(e0[e1]), e1))
