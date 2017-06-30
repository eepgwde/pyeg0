### weaves

library(lubridate)

## Restructure the data.

## Timestamp, hour of day (local), hour of day (UTC).
## Day of year.

into0$Time0 <- as.character(into0$Time)

into0$dt0 <- strptime(sprintf("%s %s:00", into0$Date, into0$Time), 
                      format="%Y-%m-%d %H:%M:%S", tz="Europe/London")

into0$hour <- into0$dt0[['hour']]

into0$yday <- into0$dt0[['yday']]

into0$Time <- NULL

into0$dt1 <- with_tz(into0$dt0, tzone = "UTC")

into0$hour1 <- into0$dt1[['hour']]

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


m.lvls <- sapply(colnames(into0), function(x) factor.lvls(into0[ , x ]))

into0[, "Reason.2" ]

tag.f <- "Reason.2"
tag.n <- 0
into0 <- factor.matchre(into0, "flush", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "filter", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.f <- "Tint.Number"
tag.n <- 0
into0 <- factor.matchre(into0, "(^y)|(thinner|1548|1544|ol17|ol 17)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "154[84]", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "(ol17|ol 17)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "(^t+$|tint)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "(ltrs|ltr|lr)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "600", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))


tag.f <- "Reason.5"
tag.n <- 0
into0 <- factor.matchre(into0, "checked", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "loaded", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.f <- "Reason.6"
tag.n <- 0
into0 <- factor.matchre(into0, "ap.+ved", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "high", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "low", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "visc", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))


tag.f <- "Reason.7"
tag.n <- 0
into0 <- factor.matchre(into0, "out .+(order|use)", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "high", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "low", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "visc", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))

tag.f <- "Content.Level"
tag.n <- 0
into0 <- factor.matchre(into0, "half", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "three", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))
tag.n <- tag.n + 1
into0 <- factor.matchre(into0, "one", tag.f, to0=sprintf("i%d.%s", tag.n, tag.f))


