### weaves
## 
## Partial Least Squares - multi-variate input and output
## Fast, accurate and stable unlike Vector Auto-Regressive Models - arima() and others.
## 

require(pls)                            # This is for fitting
require(plsdepot)                       # This has a very good chart.
require(parallel)                       # This speeds up cross-validation.

## This is some quite inventive data modelling. We use a data.frame()
## with duplicate column names to represent the Predictors and
## Responses for a multi-variate output PLS system.  This is for the
## plsdepot chart, but it is re-used to produce the fitting predictors
## and responses. 
## 
## The idea is the same as finite state-machine, ie.
##
## next-state <- fsm(current-state); then
## current-state <- next-state.
##
## For the training the Responses (on the Right) are the lead of the Predictors (on the left).
## 
## The Predictors are therefore last year's Responses together with GDP and demographics.
##
## plsdepot uses this a single data-frame for both.

## predictors
prdrs <- th$train

## responses: take all the years after the first and only take the expenditure classes.
resps <- prdrs[2:nrow(prdrs), th$classes]

## Now remove the last year from the predictors
prdrs <- prdrs[-nrow(prdrs),]

## predictors to responses
## Bind by column - allows duplicate columns.
p2r <- cbind(prdrs, resps)

## Remember which columns belong to what

## Responses are on the Right
right <- (ncol(p2r) - length(th$classes) + 1):ncol(p2r)

## Predictors are on the left.
left <- 1:(head(right, 1) - 1)

## Invoke plsreg2
p1 <- plsreg2(p2r[, left], p2r[, right], comps=2, crosval=FALSE)

## Plot the circle of correlations.
jpeg(width=1024, height=768, filename = "plsreg2-%03d.jpeg")

plot(p1)

dev.off()

## @note plsreg2 cannot predict, so we use the pls package and the
## same data structure is re-used.

prdrs1 <- as.matrix(p2r[, left])           # ie. with GDP and other WDI
resps1 <- as.matrix(p2r[, right])          # only the expenditures, but from next year

## @note
##
## The use of the protect I() operator, it loads the whole matrix as
## one entity into the data frame

p2r1 <- data.frame(I(resps1), I(prdrs1))

## Parallel
pls.options(parallel = 4)               # use mclapply

## Then ask it to apply a formula
x.pls <- plsr(resps1 ~ prdrs1, data = p2r1, scale = FALSE, validation = "CV")
x.pls

jpeg(width=1024, height=768, filename = "pls-%03d.jpeg")

plot(RMSEP(x.pls), legendpos="topright")

## @todo
## Variable importance

dev.off()

## Predict
## Take the test data-set. The 2015 consumption are used with the demographics
## to produce 2016.

prdrs2 <- as.matrix(th$test)

## Note again the use of the protect operator I()
pred <- predict(x.pls, newdata = I(prdrs2))

## More data presentation work.
## Go through the ncomps predictions
preds <- lapply(1:dim(pred)[3], 
             function(x) { return(as.data.frame.pls.pred(pred, i0=x)) })

th$preds <- preds[[1]]

lapply(2:length(preds), function(x) { th$preds <<- rbind(th$preds, preds[[x]]) })

preds <- NULL
rm("preds")

