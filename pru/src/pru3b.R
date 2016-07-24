### weaves
## Fitting

if (!exists("x.folio")) {
    x.folio <- head(th$order0, 1)
}

## Machine learning parameters
## Some tuning needed to minimize - pls is very simple.
ml0 <- list()
ml0$factor0 <- x.folio

ml0$fmla <- as.formula(paste(ml0$factor0, "~ ."))

set.seed(seed.mine)

modelFit <- plsr(ml0$fmla, data=df1, validation="LOO", scale = FALSE)
pred0 <- predict(modelFit, newdata = th$test)

spec.fname <- gsub("\\.", "-", ml0$factor0)
spec.fname <- paste(spec.fname, "%03d.jpeg", sep="-")

jpeg(width=1024, height=768, filename = spec.fname)

plot(RMSEP(modelFit), legendpos = "topright")
plot(modelFit, ncomp = modelFit$ncomp, asp = 1, line = TRUE)

dev.off()

s0 <- pred0[1,1,1]

th$test[[ ml0$factor0 ]] <- s0
th$test[1, th$classes ] <- th$test[1, th$classes] / sum(th$test[1, th$classes])

th$test[1, th$classes ]
