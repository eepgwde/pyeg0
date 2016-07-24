## weaves
##
## Machine learning preparation.
##
## This script is a sub-script and finds the Near-Zero Variance
## and highly correlated variables.
##
## It receives df0, the training dataset with the target removed.
##
### Near zero-vars and correlations
## PCA would find these, but for this iteration, we want to validate
## If any at all possible.

err.train <- list()

### Near zero-vars, very unlikely to find anything with this highly numeric data.
nzv <- nearZeroVar(df0, saveMetrics = TRUE)

if (any(nzv$nzv)) {
    err.train$nzv0 <- colnames(df0)[nzv$nzv]
    warning("overfitting: near-zero var: err.trainDescr: ", 
            paste(err.train$nzv0, collapse = ", ") )
    df0 <- df0[, !nzv$nzv ]
}

### Correlation - very likely
descrCorr <- cor(scale(df0))

## This cut-off should be under src.adjust control.
## There should be many of these. 
highCorr <- findCorrelation(descrCorr, cutoff = 0.75, verbose = FALSE)

colnames(df0)[highCorr]

descr.ncol0 <- ncol(df0)

# And remove the very highly correlated.
if (length(highCorr) > 0) {
    err.train$corrs <- colnames(df0)[highCorr]
    warning("overfitting: correlations: err.trainDescr: ", paste(err.train$corrs, collapse = ", ") )
    df0 <- df0[,-highCorr]
}

descr.ncol1 <- ncol(df0)

paste("Dropped: ", as.character(descr.ncol0 - descr.ncol1))

descrCorr <- cor(df0)
summary(descrCorr[upper.tri(df0)])

