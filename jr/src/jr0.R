## weaves
##
## Data analysis: look and feel

folios.list <- read.csv("folios0.csv", 
                        stringsAsFactors=FALSE, 
                        header=TRUE)

folio.fname <- folios.list[1,1]

folios.df <- read.csv(folio.fname)
folios.df$in0 <- as.logical(folios.df$in0)

names.base <- c("dt0", "r00", "dr00", "m5r00")

c0 <- colnames(folios.df)

## Take a look 

c0.idx <- which(grepl(".*x01", c0))

names.c <- c0[c0.idx]

folios.in <- folios.df[folios.df$in0, c(names.base, names.c)]

folios.in0 <- tail(folios.in, n=40)
