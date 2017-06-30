### weaves

## Restructure the data.

m.classs <- lapply(into0, class)

into0$Time <- as.character(into0$Time)

into0$dt0 <- strptime(sprintf("%s %s:00", into0$Date, into0$Time), format="%Y-%m-%d %H:%M:%S")

into0$hour <- into0$dt0[['hour']]

into0$yday <- into0$dt0[['yday']]

