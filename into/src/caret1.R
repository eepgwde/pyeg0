### weaves
##
## R code from http://topepo.github.io/caret/visualizations.html
## and pROC


###################################################
### 
###################################################

library(MASS)
library(caret)
library(mlbench)
library(pROC)
library(pls)

library(AppliedPredictiveModeling)

options(useFancyQuotes = FALSE) 

getInfo <- function(what = "Suggests")
{
  text <- packageDescription("caret")[what][[1]]
  text <- gsub("\n", ", ", text, fixed = TRUE)
  text <- gsub(">=", "$\\\\ge$", text, fixed = TRUE)
  eachPkg <- strsplit(text, ", ", fixed = TRUE)[[1]]
  eachPkg <- gsub(",", "", eachPkg, fixed = TRUE)
  #out <- paste("\\\\pkg{", eachPkg[order(tolower(eachPkg))], "}", sep = "")
  #paste(out, collapse = ", ")
  length(eachPkg)
}

load("w.RData", .GlobalEnv)

## Check feature plotting

cols <- colnames(w[['df']])
c0 <- grepl("(paint|temperature|pressure|thinners)", cols, ignore.case=TRUE)
c0 <- cols[c0]
c1 <- !grepl("^na\\.", c0, ignore.case=TRUE)

c0 <- c0[c1]

c1 <- list.split(c0, k=3)
print(length(c1))
idx <- 0

feat0 <- function(x) {
    transparentTheme(trans = .4)
    featurePlot(x = w[['df']][, x],
                y = as.character(w[['outcome']]),
                plot = "pairs",
                ## Add a key at the top
                auto.key = list(columns = (length(x) - 1) ))
}

if (exists("m.img")) jpeg(width=1024, height=1024, filename = "feat-%02d.jpg")


idx <- idx + 1
c0 <- c1[[idx]]

feat0(c0)

transparentTheme(trans = .4)
featurePlot(x = w[['df']][, c0],
            y = as.character(w[['outcome']]),
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = (length(c0) - 1) ))

idx <- idx + 1
c0 <- c1[[idx]]
transparentTheme(trans = .4)
featurePlot(x = w[['df']][, c0],
            y = as.character(w[['outcome']]),
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = (length(c0) - 1) ))

idx <- idx + 1
c0 <- c1[[idx]]
transparentTheme(trans = .4)
featurePlot(x = w[['df']][, c0],
            y = as.character(w[['outcome']]),
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = (length(c0) - 1) ))

idx <- idx + 1
c0 <- c1[[idx]]
transparentTheme(trans = .4)
featurePlot(x = w[['df']][, c0],
            y = as.character(w[['outcome']]),
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = (length(c0) - 1) ))

if (exists("m.img")) dev.off()



transparentTheme(trans = .4)
featurePlot(x = iris[, 1:4],
            y = iris$Species,
            plot = "pairs",
            ## Add a key at the top
            auto.key = list(columns = 3))

transparentTheme(trans = .9)
featurePlot(x = iris[, 1:4],
            y = iris$Species,
            plot = "density",
            ## Pass in options to xyplot() to 
            ## make it prettier
            scales = list(x = list(relation="free"),
                          y = list(relation="free")),
            adjust = 1.5,
            pch = "|",
            layout = c(4, 1),
            auto.key = list(columns = 3))

## Regression

data(BostonHousing)
regVar <- c("age", "lstat", "tax")
str(BostonHousing[, regVar])

theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 2
trellis.par.set(theme1)
featurePlot(x = BostonHousing[, regVar],
            y = BostonHousing$medv,
            plot = "scatter",
            layout = c(3, 1))

## with added smoothed line.
featurePlot(x = BostonHousing[, regVar],
            y = BostonHousing$medv,
            plot = "scatter",
            type = c("p", "smooth"),
            span = .5,
            layout = c(3, 1))

## Check pROC and it's charting.

data(aSAH)

plot.roc(aSAH$outcome, aSAH$s100b, # data
         percent=TRUE, # show all values in percent
         partial.auc=c(100, 90), partial.auc.correct=TRUE, # define a partial AUC (pAUC)
         print.auc=TRUE, #display pAUC value on the plot with following options:
         print.auc.pattern="Corrected pAUC (100-90%% SP):\n%.1f%%", print.auc.col="#1c61b6",
         auc.polygon=TRUE, auc.polygon.col="#1c61b6", # show pAUC as a polygon
         max.auc.polygon=TRUE, max.auc.polygon.col="#1c61b622", # also show the 100% polygon
         main="Partial AUC (pAUC)")

plot.roc(aSAH$outcome, aSAH$s100b,
         percent=TRUE, add=TRUE, type="n", # add to plot, but don't re-add the ROC itself (useless)
         partial.auc=c(100, 90), partial.auc.correct=TRUE,
         partial.auc.focus="se", # focus pAUC on the sensitivity
         print.auc=TRUE, print.auc.pattern="Corrected pAUC (100-90%% SE):\n%.1f%%", print.auc.col="#008600",
         print.auc.y=40, # do not print auc over the previous one
         auc.polygon=TRUE, auc.polygon.col="#008600",
         max.auc.polygon=TRUE, max.auc.polygon.col="#00860022")

## adabag

library(adabag)

iris.adaboost <- boosting(Species~., data=w[['df']], boos=TRUE,
                          mfinal=6)

iris.adaboost <- boosting(Species~., data=iris, boos=TRUE,
                          mfinal=6)
importanceplot(iris.adaboost)
sub <- c(sample(1:50, 35), sample(51:100, 35), sample(101:150, 35))
iris.bagging <- bagging(Species ~ ., data=iris[sub,], mfinal=10)
                                        #Predicting with labeled data
iris.predbagging <-predict.bagging(iris.bagging, newdata=iris[-sub,])
iris.predbagging
                                        #Predicting with unlabeled data
iris.predbagging <- predict.bagging(iris.bagging, newdata=iris[-sub,-5])
iris.predbagging

