library(caret)

df2 <- read.csv("coded.csv")

freqCut0 <- 4
unique0 <- 25

nzv0 <- nearZeroVar(df2, saveMetrics = TRUE, allowParallel=TRUE,
                    freqCut =freqCut0, 
                    uniqueCut=unique0)

nzv0

plot(df2)
