## weaves
##
## Visual validation using Recursive Partition Trees.
##
## @note
## Uses older version of R, so no caret.

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}
gc()

library(rkdb)

library(quantmod)

h <- open_connection('j1', 4444)

fxs <- execute(h, ".htl.subcurrencies")

from <- c("CAD", "JPY", "USD")
to <- c("USD", "USD", "EUR")

x0 <- paste0(from, to, "=X")

getQuote(x0)

// These fail: TRY ADM KWD GEL
// Turkish lira, Armenian dram, Kuwaiti dinar, Georgian lari

idx <- grepl("ADM", fxs)

fxs[which(idx)] <- "AMD"

x0 <- unique(paste0(fxs, "USD", "=X"))

## Can't ask for all at once, limit to 8

x <- x0
n <- 5
chunk <- function(x,n) split(x, factor(sort(rank(x)%%n)))

fxs1 <- lapply(chunk(x,n), getQuote)

t0 <- NULL
for (x in fxs1) {
    t0 <- rbind(t0, x)
}

save(t0, file="fx0.dat")

load("fx0.dat")

rownames(t0) <- gsub("USD=X.*$", "", rownames(t0))

bookings <- execute(h, "bookings")
