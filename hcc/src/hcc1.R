## weaves
##
## Data analysis
## Herts Carriageways. 

## Get started with a load and save to binary.

require(zoo)

args = commandArgs(trailingOnly=TRUE)

tgt0 <- "out/xncas1.csv"
if (length(args) >= 1) {
    tgt0 <- args[1]
}

scls0 <- "ncas1"


hcc00 <- read.csv(tgt0, 
                  stringsAsFactors=FALSE, strip.white=TRUE,
                  header=TRUE, na.strings=c(""))

hcc00$dt0 <- as.Date(hcc00$dt0)

hcc00$mm0 <- as.factor(hcc00$mm0)

x.remove <- c("superseded", "unsuperseded", "mm0")

hcc <- hcc00[, !(colnames(hcc00) %in% x.remove) ]

m1 <- as.matrix(hcc[, !(colnames(hcc) %in% "dt0") ])

ccf0 <- function(tbl, pairs) {
    ccf(tbl[, pairs[1]], tbl[, pairs[2]], main=paste(pairs, collapse=" "), na.action=na.pass)
}

jpeg(filename=paste(scls0, "-%03d.jpeg", sep=""), 
     width=1024, height=768)

## Basic correlations
corr1 <- cor(m1)

corrplot::corrplot(corr1, method="number", title="monthly absolute")

## hope: repudiations lead claims

x.pairs <- rev(c("claims", "repudns"))
ccf0(hcc, x.pairs)

z0 <- zoo(hcc[, x.pairs])
          
## Try the deltas

z1 <- z0/lag(z0, -1) - 1
z2 <- cbind(z0, z1)

## Deltas are good
x.pairs <- rev(c("claims.z1", "repudns.z1"))
ccf0(z2, x.pairs)

## Not delta to absolute
x.pairs <- rev(c("claims.z0", "repudns.z1"))
ccf0(z2, x.pairs)

## Not a bad correlations
corr1 <- cor(as.matrix(z2), use="pairwise.complete.obs")
corrplot::corrplot(corr1, method="number", title="monthly absolutes and delta")

### enqs to repudns

x.pairs <- c("enqs", "repudns")
z0 <- zoo(hcc[, x.pairs])
          
ccf0(z0, x.pairs)

z1 <- z0/lag(z0, -1) - 1
z2 <- cbind(z0, z1)

x.pairs <- c("enqs.z1", "repudns.z1")
ccf0(z2, x.pairs)

## Not delta to absolute
x.pairs <- rev(c("repudns.z0", "enqs.z1"))
ccf0(z2, x.pairs)

## Not bad.
corr1 <- cor(as.matrix(z2), use="pairwise.complete.obs")
corrplot::corrplot(corr1, method="number", title="monthly absolutes and delta")

dev.off()

save(hcc, file="hcc00.dat")


