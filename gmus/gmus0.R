## weaves

## Load JSON files from Google Music.
## 

library(jsonlite)

songs <- list()

songs$x0 <- fromJSON("songs.json", flatten=TRUE)

colnames(songs$x0)

## The timestamps are very long - extra microseconds.
songs$pdate <- as.POSIXct(as.integer(substr(songs$x0$creationTimestamp[1], 1, 10)), origin="1970-01-01")
songs$date0 <- as.Date(songs$pdate)

as.Date(as.POSIXct(as.long(songs$x0$creationTimestamp[1]), origin="1970-01-01"))
        

songs$all <- fromJSON("all-songs.json", flatten=TRUE)


