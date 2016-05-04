### weaves

## Things you notice. 

## AVGSKDAVAIL is related to AVAILBUCKET, but AVAILBUCKET is complete

## AVGLOFATC is zero at times? Must mean direct flight?

## Definitely a strong correlation to time of day, just by eye.

## I think this is time series data! departure < arrive unless
## hangared for the night or a very short flight.

## For the big data set, we have only 41 flights that arrive before
## they leave, some are very short flights, aargh! three types in all.

flight.raw <- read.csv("../bak/flight.csv")

dim(flight.raw[which(flight.raw$SARRHR < flight.raw$SDEPHR), 
             c("SARRHR", "SDEPHR")])

## The flight duration is not related to AVGLOFATC, eg. Rio to Sao
## Paulo is less than an hour, ISTR, but it would be translantic from
## London

flight.raw[which(flight.raw$SARRHR == flight.raw$SDEPHR), 
         c("SARRHR", "SDEPHR", "AVGLOFATC")]
