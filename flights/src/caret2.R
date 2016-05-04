### weaves
## See caret1.R

library(earth)

data(etitanic)
head(model.matrix(survived ~ ., data = etitanic))

dummies <- dummyVars(survived ~ ., data = etitanic)
head(predict(dummies, newdata = etitanic))

data(mdrr)

data.frame(table(mdrrDescr$nR11))

nzv <- nearZeroVar(mdrrDescr, saveMetrics= TRUE)
nzv[nzv$nzv,][1:10,]
