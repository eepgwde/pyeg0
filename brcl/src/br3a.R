## weaves
##
## Machine learning preparation: common
##
## This script is a sub-script and finds the Near-Zero Variance
## and highly correlated variables.

library("ipred")

## Center, scale, remove any NA using nearest neighbours.
## PCA as "pca" is useful here.
ml0.imputer <- preProcess(df0, verbose = FALSE, na.remove = TRUE, 
                          method=c("center", "scale", "bagImpute"))

## Apply the imputations.
df1 <- predict(ml0.imputer, df0)

### Near zero-vars and correlations
## PCA would find these, but for this iteration, we want to validate
## If any at all possible.

err.trainDescr <- list()

nzv <- nearZeroVar(df1, saveMetrics = TRUE)
if (any(nzv$nzv)) {
    ml0$nzv <- colnames(df1)[nzv$nzv]
    warning("overfitting: near-zero var: err.trainDescr: ", 
            paste(ml0$nzv, collapse = ", ") )
    err.trainDescr <- append(err.trainDescr, df1)
    df1 <- df1[, !nzv$nzv ]
}

# It's imputed and behaves well, no need for this.
# descrCorr <- cor(scale(trainDescr), use = "pairwise.complete.obs")

descrCorr <- cor(scale(df1))

## This cut-off should be under src.adjust control.
## There should be many of these. Because all derived from r00.
highCorr <- findCorrelation(descrCorr, cutoff = .75, verbose = FALSE)

colnames(df1)[highCorr]

descr.ncol0 <- ncol(df1)

# And remove the very highly correlated.
if (length(highCorr) > 0) {
    ml0$corrs <- colnames(df1)[highCorr]
    warning("overfitting: correlations: err.trainDescr: ", paste(ml0$corrs, collapse = ", ") )
    err.trainDescr <- append(err.trainDescr, df1)
    df1 <- df1[,-highCorr]
}

descr.ncol1 <- ncol(df1)

paste("Dropped: ", as.character(descr.ncol0 - descr.ncol1))

descrCorr <- cor(df1)
summary(descrCorr[upper.tri(df1)])

