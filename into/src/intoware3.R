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

library(Rweaves1)

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

print(sprintf("outcome: %s", w[['outcome-name']]))

## Check feature plotting

cols <- colnames(w[['df']])
c0 <- grepl("(viscosity|filter|^tlo|paint|temperature|pressure|precip|thinners)", cols, ignore.case=TRUE)
c0 <- cols[c0]
c1 <- !grepl("^na\\.", c0, ignore.case=TRUE)

c0 <- c0[c1]

c1 <- list.split(c0, k=3)
print(length(c1))
idx <- 0

feat0 <- function(x) {
    transparentTheme(trans = .4)
    x <- append(x, "thi")
    featurePlot(x = w[['df']][, x],
                y = as.character(w[['outcome']]),
                plot = "pairs",
                ## Add a key at the top
                auto.key = list(columns = (length(x) - 1) ))
}

if (exists("m.img")) jpeg(width=1024, height=1024, filename = "feat-%02d.jpg")

lapply(c1, feat0)

if (exists("m.img")) dev.off()

