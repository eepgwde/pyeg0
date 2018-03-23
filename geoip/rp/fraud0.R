## csilvestre

## Instead of repeatedly running the query use the file file tbl00.dat

library(DBI)

con <- dbConnect(odbc::odbc(), "leafdb")

qstr <- 'select s.*, t.remote_addr, c.*  from 
 stripe_charges as s join transactions as t on s.description = t.trans_id
 inner join trans_flattened_purchases as c on c.trans_id = t.trans_id
where s.created_time > \'2017-03-01\'
'

tbl <- dbGetQuery(con, qstr)

tbl00 <- tbl # make a backup to this - to avoid re-running query.

save(tbl00, file="tbl00.dat")

load("tbl00.dat", envir=.GlobalEnv)

# to re-run code start from here, no need to re-run query.

tbl <- tbl00 

colnames(tbl)


f.logbin <- function(x, n=2) {
  x1 <- log10(x)
  m <- floor(x1)
  e0 <- x1 - m
  e0 <- round(e0, n)
  return(m+e0)
}

## Add the outcome feature and clean input features
tbl$isfraud <- tbl$dispute_reason == 'fraudulent'

tbl$month0 <- format(tbl$purchase_localtime, format="%Y-%m")

tbl$source_address_zip_check <- as.factor(tbl$source_address_zip_check)

tbl$refunded <- as.logical(tbl$refunded)

tbl$amount <- round(tbl$amount / 100, 2)

# we aleady have this data in our view of the database.
tbl$meta_data <- NULL

tbl$ddays <- as.numeric((as.Date(tbl$perf_localtime) - as.Date(tbl$purchase_localtime)))

tbl$ddaysl <- floor(10^f.logbin(tbl$ddays))

tbl$avgprice <- tbl$amount/tbl$total_no_of_seats


# Check

aggregate(isfraud ~ tbl$month0, data = tbl, FUN=sum)

# simplify send_desc.

tbl$collect0 <- grepl("(Collect|Ophalen|Hold|Cobo)", tbl$send_desc, ignore.case=TRUE)
tbl$print0 <- grepl("(E-ticket|print|PDF|email)", tbl$send_desc, ignore.case=TRUE)
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

save(smpls, frd0, file="frd0.Rdat")
