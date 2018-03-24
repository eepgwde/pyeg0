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

## Clustering suggests the top numbers are more important
## cnv1$interest <- as.factor(cnv1$interest)

cnv1$impr0 <- bins.log(cnv1$impressions)

cnv1 <- cnv1[ order(cnv1$impressions), ]

hist(cnv1$impr0)

## Groups of features

frd0 <- list()

frd0[["seed"]] <- 369

x <- list()

x[["nums"]] <- c("impr0", "age0", "male0", "tcnv0", "acnv0", "spent", "interest", "clicks")

x[["classes"]] <- c("age", "gender", "interest")

x[["discard"]] <- c("impressions")

frd0[["ftres"]] <- x

## Cluster plot

c0 <- setdiff(c(frd0$ftres[["nums"]]), c("clicks", "spent"))
x.cnv1 <- subset(cnv1, is.na(cnv1$clicks), select=c0 )

cnv2 <- scale(factor.numeric(x.cnv1))

wss <- (nrow(cnv2)-1)*sum(apply(cnv2,2,var))

kmeans0 <- function(x, idx) {
    return(kmeans(x, centers=i, iter.max=100, nstart=2))
}

for (i in 2:15) wss[i] <- sum(kmeans0(cnv2, i)$withinss)

plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

x0 <- mean(wss) - 0.5 * sd(wss)
x0 <- (which(wss <= x0))[1]

## K-Means Cluster Analysis
fit <- kmeans0(cnv2, x0) #

x.cnv1$cluster <- fit$cluster

clusplot(x.cnv1, x.cnv1$cluster, color=TRUE, shade=TRUE, labels=3, lines=0)


x1 <- sort(table(x.cnv1$cluster), decreasing=TRUE)
x1 <- cumsum(x1)

cl0 <- x1[ which(!x1 > dim(x.cnv1)[1] / 2) ]
cl0 <- as.integer(names(cl0))

x.cnv1[ x.cnv1$cluster %in% cl0, ]

## As one

x0 <- cluster.make0(x.cnv1)
pdf <- x0[["source"]]

clusplot(pdf, pdf$cluster, color=TRUE, shade=TRUE, labels=3, lines=0)

pdf1 <- x0[["best"]]

## And save

x.flnm <- file.path(dirname(src0), "frd0.dat")

save(smpls, frd0, file=x.flnm)
