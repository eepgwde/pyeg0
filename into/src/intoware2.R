### weaves

library(lubridate)

## Restructure the data.

## Empty columns

## Remove empty

ncol(into0)
invisible(sapply(colnames(into0), function(x) { into0 <<- empty.col(into0, x) }))
ncol(into0)

## Identifier strings

tag.fs <- c("Batch.Number", "Old.Batch.Number", "New.Batch.Number")

for (tag.f in tag.fs) {
    into0[[ tag.f ]] <- as.character(into0[[ tag.f ]])
}

## Eliminate some probably bad records

if (any(is.na(into0$Number))) into0 <- into0[ -which(is.na(into0$Number)),]

if (any(is.na(into0$Pressure))) into0 <- into0[ -which(is.na(into0$Pressure)),]

## Timestamp, hour of day (local), hour of day (UTC).
## Day of year.

into0$Time0 <- as.character(into0$Time)
into0$Time <- NULL

into0$dt0 <- strptime(sprintf("%s %s:00", into0$Date, into0$Time), 
                      format="%Y-%m-%d %H:%M:%S", tz="Europe/London")

into0$hour <- round(into0$dt0[['hour']] + into0$dt0[['min']] / 60, 1)

into0$yday <- into0$dt0[['yday']]

into0$dt1 <- with_tz(into0$dt0, tzone = "UTC")

into0$hour1 <- round(into0$dt1[['hour']] + into0$dt1[['min']] / 60, 1)

into0$Time0 <- NULL

### Factors and strings

## white space

m.classs <- lapply(into0, class)

m.names <- names(m.classs[grepl("character", m.classs)])

invisible(sapply(m.names, function(x) { into0[, x] <<- trimws(into0[, x]) } ))

m.names <- names(m.classs[grepl("factor", m.classs)])

invisible(sapply(m.names, function(x) { into0[, x] <<- as.factor(trimws(into0[, x])) } ))

## Bad records

into1 <- into0[into0[, "Within.Spec" ] != "", ]

## View(into0[, c("dt0", "dt1", "hour", "hour1")])

## TODO: Has N/A
into0[, "Water.Trap"]

into0[, "Tint.Number"]

tag.f <- "Batch.Number"
into0[, tag.f] <- gsub(",", "", into0[, tag.f ], fixed=TRUE)
into0[, tag.f] <- gsub(" ", "", into0[, tag.f ], fixed=TRUE)
into0[, tag.f] <- gsub("p", "", into0[, tag.f ], fixed=TRUE)
into0[, tag.f] <- gsub("-", "", into0[, tag.f ], fixed=TRUE)


m.lvls <- sapply(colnames(into0), function(x) levels(into0[ , x ]))

into0[, "Reason.2" ]

tag.f <- "Reason.2"
tag.n <- 0
into0 <- col.matchre(into0, "flush", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "filter", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.f <- "Tint.Number"
tag.n <- 0
into0 <- col.matchre(into0, "(^y)|(thinner|1548|1544|ol17|ol 17)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.n <- tag.n + 1
into0 <- col.matchre(into0, "154[84]", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "(ol17|ol 17)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.n <- tag.n + 1
into0 <- col.matchre(into0, "(^t+$|tint)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.n <- tag.n + 1
into0 <- col.matchre(into0, "(ltrs|ltr|lr)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.n <- tag.n + 1
into0 <- col.matchre(into0, "600", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))


tag.f <- "Reason.5"
tag.n <- 0
into0 <- col.matchre(into0, "checked", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "loaded", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.f <- "Reason.6"
tag.n <- 0
into0 <- col.matchre(into0, "ap.+ved", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "high", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "low", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "visc", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))


tag.f <- "Reason.7"
tag.n <- 0
into0 <- col.matchre(into0, "out .+(order|use)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "high", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "low", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "visc", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.f <- "Content.Level"
tag.n <- 0
into0 <- col.matchre(into0, "half", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "three", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- col.matchre(into0, "one", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))


## Make integer columns with NA numeric

m.clss <- class.columns(into0, cls0="integer")
x0 <- sapply(colnames(into0)[m.clss], function(x) sum(as.numeric(is.na(into0[[ x ]]))))
m.names <- which(x0 > 0)
rm("x0", "m.clss")

invisible(sapply(m.names, function(x) { into0[[x]] <<- as.double(into0[[ x ]]) }))

## NA handling

into0 <- fn.columns(into0, FUN=addNA, cls0="factor")

m.names <- colnames(into0)[class.columns(into0, cls0="factor")]
m.names <- m.names[0 < sapply(m.names, function(x) sum(as.numeric(is.na(into0[,x]))))]

m.names <- colnames(into0)[class.columns(into0, cls0="numeric|integer")]
m.names <- m.names[0 < sapply(m.names, function(x) sum(as.numeric(is.na(into0[,x]))))]

sapply(m.names, function(x) table(into0[[ x ]], useNA="ifany"))

### Imputation

## These have nothing of use and are removed.

tag.f <- "New.Viscosity"
into0[, tag.f ] <- NULL
m.names <- setdiff(m.names, tag.f)

tag.f <- "BYK.Mac"
into0[, tag.f ] <- NULL
m.names <- setdiff(m.names, tag.f)

## These are dominated

f <- function(x, na.rm=TRUE) {
    return(-1);
}

tag.f <- "SAVES"
into0 <- col.impute0(into0, tag.f, imputer=f)
m.names <- setdiff(m.names, tag.f)

tag.f <- "Pump.Stroke.Rate"
into0 <- col.impute0(into0, tag.f, imputer=f)
m.names <- setdiff(m.names, tag.f)

## Just a few - use the mean.
tag.f <- "Material.Temperature"
into0 <- col.impute0(into0, tag.f)
m.names <- setdiff(m.names, tag.f)

## These are small linear range, so put the NA at the end.
## TODO: add a boolean isNA field.

rm("tag.f")

for (tag.f in m.names) {
    into0 <- col.impute0(into0, tag.f, transform.f=ordered)
}

m.names <- colnames(into0)[class.columns(into0, cls0="factor|ordered|numeric")]
m.names <- m.names[0 < sapply(m.names, function(x) sum(as.numeric(is.na(into0[,x]))))]
m.names

ncol(into0)

