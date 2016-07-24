### weaves
## Fitting

if (!exists("x.folio")) {
    x.folio <- head(th$order0, 1)
}

## Machine learning parameters
## Some tuning needed to minimize
ml0 <- list()
ml0$window0 <- 6
ml0$factor0 <- x.folio

fitControl <- trainControl(             # timeslicing
    initialWindow = ml0$window0,
    horizon = 1,
    fixedWindow = FALSE,
    method = "timeslice",
    savePredictions = TRUE)

## @note
## Weightings: try EWMA
x.samples <- nrow(df1)

x.ewma <- EWMA(c(1, rep(0,x.samples-1)), lambda = 0.050, startup = 1)
x.weights <- rev(x.ewma) / sum(x.ewma)

## For the results accuracy, make the same weighting a bit longer.
x.ewma <- EWMA(c(1, rep(0,x.samples)), lambda = 0.050, startup = 1)
x.rweights <- rev(x.ewma) / sum(x.ewma)
    
## Or just
## x.weights <- rep(1, x.samples)

ml0$fmla <- as.formula(paste(ml0$factor0, "~ ."))

set.seed(seed.mine)
modelFit1 <- train(ml0$fmla, data = df1,
                   method = "pls",
                   preProc = c("center", "scale"),
                   trControl = fitControl)
modelFit1

ml0$model0 <- modelFit1
ml0$preds <- c(predict(modelFit1, df1), predict(modelFit1, th$test))

ml0$modelImp <- varImp(modelFit1, scale = FALSE)

spec.fname <- gsub("\\.", "-", ml0$factor0)
spec.fname <- paste(spec.fname, "%03d.jpeg", sep="-")

jpeg(width=1024, height=768, filename = spec.fname)

plot(modelFit1)

plot(ml0$modelImp, top = min(20, length(colnames(df1))))

plot.ts(ts(data.frame(pred=predict(modelFit1, df1),obs=th$train[[ ml0$factor0 ]])), 
        plot.type="multiple")

dev.off()

## Make up my own exponential accuracy metric and we hope to improve this by adding more
## WDI data.

r0 <- data.frame(pred=ml0$preds, obs = c(th$train[[ ml0$factor0 ]], th$test[[ ml0$factor0 ]]))

ml0$var1 <- sum((r0$pred - r0$obs)^2 * x.rweights)
ml0$var1

## Now we have estimated one expenditure, we put it into the test sample
## renormalize so we can then estimate the next expenditure.

s0 <- tail(ml0$preds, 1)

sum(th$test[, th$classes ])

th$test[[ ml0$factor0 ]] <- s0
th$test[1, th$classes ] <- th$test[1, th$classes] / sum(th$test[1, th$classes])

ml0$factor0
