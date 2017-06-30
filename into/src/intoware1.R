### weaves

## Load meteorological data for Manchester for March, April, May and June 2017


met0 <- read.csv("../bak/m15-6.csv0", header=FALSE, skip=1)

colnames(met0) <- c("wday", "m", "dom", "thi", "tlo", "precip-mm", "snow-cm", "ignore0", "thi1", "tlo1")

met0$Date <- as.Date(sprintf("2017-%02d-%02d", met0$m, met0$dom))

met0 <- met0[, c("Date", "thi", "tlo", "precip-mm", "snow-cm")]

into0 <- merge(into0, met0, by="Date")
