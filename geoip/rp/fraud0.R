## weaves

## Instead of repeatedly running the query use the file tbl00.dat

rm(list = ls())
if (!is.null(dev.list())) {
    lapply(dev.list(), function(x) dev.off())
}
gc()

library(Rweaves1)

options(useFancyQuotes = FALSE) 

## Load up the target given on the command line.

x.args = commandArgs(trailingOnly=TRUE)

if (length(x.args) <= 0) {
    x.args = c("/cache/baks/11/ingrss0/tbl00.dat", "tbl00", "localhost:4444")
}

src0 <- "tbl00.dat"                       # a default
if (length(x.args) >= 1) {
    src0 <- x.args[1]
}

tgt0 <- "tbl00"                       # a default
if (length(x.args) >= 2) {
    tgt0 <- x.args[2]
}

src1 <- "localhost:5000"                       # a default
if (length(x.args) >= 3) {
    src1 <- x.args[3]
}

## Load file and table

load(src0, envir=.GlobalEnv)

tbl <- get(tgt0)                        # get indirectly
dim(tbl)

colnames(tbl)

## Add the outcome feature and clean input features
tbl$isfraud <- tbl$dispute_reason == 'fraudulent'

tbl$month0 <- format(tbl$purchase_localtime, format="%Y-%m")

tbl$source_address_zip_check <- as.factor(tbl$source_address_zip_check)

tbl$refunded <- as.logical(tbl$refunded)

tbl$amount <- round(tbl$amount / 100, 2)

# we aleady have this data in our view of the database.
tbl$meta_data <- NULL

tbl$ddays <- as.numeric((as.Date(tbl$perf_localtime) - as.Date(tbl$purchase_localtime)))

tbl$ddaysl <- floor(10^bins.log(tbl$ddays))

tbl$avgprice <- tbl$amount/tbl$total_no_of_seats


# Check

aggregate(isfraud ~ tbl$month0, data = tbl, FUN=sum)

# simplify send_desc.

tbl$collect0 <- grepl("(Collect|Ophalen|Hold|Cobo)", tbl$send_desc, ignore.case=TRUE)
tbl$print0 <- grepl("(eTicket|E-ticket|print|PDF|email)", tbl$send_desc, ignore.case=TRUE)
tbl$post0 <- grepl("post", tbl$send_desc, ignore.case=TRUE)
tbl$tcktpln <- grepl("ticketplan", tbl$send_desc, ignore.case=TRUE)

tbl$senddesc1 <- "None"
tbl[ tbl$collect0, "senddesc1"] <- "Collect"
tbl[ tbl$print0, "senddesc1"] <- "Eticket"
tbl[ tbl$post0, "senddesc1"] <- "Post"

tbl$senddesc1 <- as.factor(tbl$senddesc1)

aggregate(isfraud ~ tcktpln + collect0 + print0 + post0, data=tbl, FUN=sum)

tbl[ !tbl$collect0 & !tbl$print0 & !tbl$post0 & !tbl$tcktpln, "send_desc"]

## remove columns: ticketplan

tbl <- tbl[ !tbl$tcktpln, !colnames(tbl) %in% c("tcktpln")]

aggregate(isfraud ~ collect0 + print0 + post0, data=tbl, FUN=sum)

## remove rows (ie. records)

tbl <- tbl[ !tbl$refunded, ] # refunds

# remove where number of days is greater than 100

tbl <- tbl[ tbl$ddays <= 100, ]

## Income features - catalogue>

frd0 <- list()

x <- list()


x[["ticketinfo"]] <-
  c("amount",
    "avgprice",
    "total_no_of_seats",
    "senddesc1")


## This is too detailed
# "seat_ids", 
# "price_band"

x[["datetimes"]] <-
  c("purchase_localtime",
    "perf_localtime",
    "purchase_utc_seconds")

x[["cust0"]] <-
  c(
    "remote_addr",
    "source_address_zip",
    "email_addr"
  )

x[["event0"]] <-
  c("venue_desc_from_backend", "backend_system", "event_id")


## source_fingerprint is an indicator of the number of times the card was used.
x[["paym0"]] <-
  c(
    "amount",
    "source_cvc_check",
    "refunded",
    "amount_refunded",
    "source_address_zip_check",
    "source_brand" ,
    "source_funding"
  )

## Too detailed: 
#    "source_fingerprint",

x[["ptofsale"]] <- c("user_id")

x[["attempt_info"]] <- c("risk_level")

## My selections based on charts

x[["cs1"]] <- c("source_address_zip_check", "source_brand", "total_no_of_seats", "ddaysl", "senddesc1", "avgprice")

x[["outcomen"]] <- c("isfraud")

frd0[["ftres"]] <- x

frd0[["seed"]] <- 369

## Finally simplify the source table to a named table we can pass on.
## and remove all the columns we won't be using.

c0 <- as.character(unlist(frd0$ftres, recursive=TRUE))
smpls <- tbl[ , c0]

x.flnm <- file.path(dirname(src0), "frd0.dat")

save(smpls, frd0, file=x.flnm)
