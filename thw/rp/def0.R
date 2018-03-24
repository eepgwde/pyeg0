## weaves

## Instead of repeatedly running the query use the file tbl00.dat

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}
gc()

library(rkdb)
library(Rweaves1)
library(cluster)
library(corrplot)

options(useFancyQuotes = FALSE) 

## Load up the target given on the command line.

x.args = commandArgs(trailingOnly=TRUE)

if (length(x.args) <= 0) {
    x.args = c("localhost:5000")
}

src0 <- "localhost:5000"
if (length(x.args) >= 1) {
    src0 <- x.args[1]
}

## Connect to q/kdb+

x.qkdb <- unlist(strsplit(src0, ":", fixed=TRUE))
stopifnot(length(x.qkdb) == 2)

h <- open_connection(host=x.qkdb[1], port=x.qkdb[2])

cnv1 <- execute(h, "cnv1")

rownames(cnv1) <- cnv1$id0
cnv1$id0 <- NULL

cnv1$xyz0 <- as.factor(cnv1$xyz0)
cnv1$fb0 <- as.factor(cnv1$fb0)
cnv1$age <- as.factor(cnv1$age)
cnv1$gender <- as.factor(cnv1$gender)

cnv1$sccs0 <- factor(cnv1$acnv0 > 0, labels=c("nosale", "sale"))

## Clustering suggests the top numbers are more important
## cnv1$interest <- as.factor(cnv1$interest)

cnv1$impr0 <- bins.log(cnv1$impressions) # log value doesn't correlate well

cnv1 <- cnv1[ order(cnv1$impressions), ]

hist(cnv1$impr0)

cnv1 <- cnv1[ order(-cnv1$acnv0), ]

clicks <- cnv1[ !is.na(cnv1$clicks), ]
noclicks <- cnv1[ is.na(cnv1$clicks), ]

## Groups of features

frd0 <- list()

frd0[["seed"]] <- 369

x <- list()

x[["nums"]] <- c("impr0", "age0", "male0", "tcnv0", "acnv0", "spent", "interest", "clicks")

x[["clicks"]] <- c("impressions", "tcnv0", "acnv0", "spent", "clicks")

x[["clicksl"]] <- c("impr0", "tcnv0", "acnv0", "spent", "clicks")

x[["noclicks"]] <- c("impressions", "tcnv0", "acnv0")

x[["classes"]] <- c("age", "gender", "interest")

x[["discard"]] <- c("acnv0")

x[["outcomen"]] <- c("sccs0")

frd0[["ftres"]] <- x

## Correlations - clicks only ie. facebook

df1 <- cnv1[ !is.na(cnv1$clicks), ]
corr1 <- cor(as.matrix(df1[, colnames(df1) %in% frd0$ftres$clicks]))
corrplot::corrplot(corr1, method="number", order="hclust")

df1 <- cnv1[ is.na(cnv1$clicks), ]
corr1 <- cor(as.matrix(df1[, colnames(df1) %in% frd0$ftres$noclicks]))
corrplot::corrplot(corr1, method="number", order="hclust")


## Try logging down the data and using zero.
df1 <- cnv1[ !is.na(cnv1$clicks), ]
df1 <- df1[, colnames(df1) %in% frd0$ftres$noclicks]
x0 <- lapply(colnames(df1), function(x) df1[[x]] <<- bins.log(df1[[x]]))
x0 <- lapply(colnames(df1), function(x) {
    idx <- is.na(df1[[x]]); df1[[x]][which(idx)] <<- 0
    })

corr1 <- cor(as.matrix(df1))
corrplot::corrplot(corr1, method="number", order="hclust")

## Cluster plot

### Try this subset. Their advertising that has an actual conversion.

c0 <- unique(union(frd0$ftres$noclicks, frd0$ftres$classes))
x.cnv1 <- subset(noclicks, noclicks$acnv0 > 0, select=c0 )
x.cnv1$acnv0 <- NULL
x.cnv1$tcnv0 <- NULL

## As one

x0 <- cluster.make0(x.cnv1)
pdf <- x0[["source"]]

clusplot(pdf, pdf$cluster, color=TRUE, shade=TRUE, labels=3, lines=0)

pdf <- pdf[ order(pdf$cluster), ]

pdf1 <- x0[["best"]]
pdf1 <- pdf1[ order(pdf1$cluster), ]

## And save

x.flnm <- file.path(".", "thw0.dat")

save(clicks, noclicks, frd0, file=x.flnm)
