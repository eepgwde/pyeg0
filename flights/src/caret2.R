### weaves
## See caret1.R

library(earth)

data(etitanic)
head(model.matrix(survived ~ ., data = etitanic))

dummies <- dummyVars(survived ~ ., data = etitanic)
head(predict(dummies, newdata = etitanic))

head(model.matrix(LEGTYPE ~ ., data = flight))

dummies <- dummyVars(flight.m0 ~ ., data = flight)
head(predict(dummies, newdata = flight))
