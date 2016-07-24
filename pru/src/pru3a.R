## weaves
##
## Machine learning preparation: WDI data
##

## I'll just use the deltas and fill-back.

## @note
## The demographic data does help, halves my var1 estimate in the main script.
## But, so far, one must fill forward and back.
if (exists("x.demog")) {

    ## Some demographic data, added as deltas, this is relatively
    ## stable and we can fill forward
    ## @note
    ## These are not so important.
    m0 <- c("SP.ADO.TFRT","SP.DYN.TFRT.IN")
    x1 <- wdi.filled(wdi0=wdi$demog$values, metrics0=m0, zero0=x.demog)

    stopifnot(nrow(x0) == nrow(x1))
    x1$year <- NULL                     # I kept the year in for debugging.

    x0 <- cbind(x0, x1)                 # add the columns

    ## Some more about male/female in population
    ## These are important.
    ## The data isn't very complete.
    m0 <- c("SP.POP.TOTL", "SP.POP.TOTL.FE.ZS", "SL.EMP.TOTL.SP.FE.ZS", "SL.EMP.TOTL.SP.MA.ZS", "SL.EMP.TOTL.SP.ZS")

    ## @note
    ## These might slow it down.
    if (TRUE) {
        m1 <- c("SP.RUR.TOTL", "SP.URB.TOTL", "SL.TLF.ACTI.1524.ZS", "SL.TLF.ACTI.1524.FE.ZS", "SL.TLF.ACTI.1524.MA.ZS")
        m0 <- c(m0, m1)
    }

    x1 <- wdi.filled(wdi0=wdi$popn$values, metrics0=m0, zero0=x.demog)

    stopifnot(nrow(x0) == nrow(x1))
    x1$year <- NULL                     

    x0 <- cbind(x0, x1)
}

## @note
## The pricing data makes no change
if (exists("x.price")) {

    ## CPI and Wholesale, wholesale is a very short set, so I've set it equal to CPI.
    m0 <- c("CPTOTSAXN", "FP.WPI.TOTL")
    x1 <- wdi.filled(wdi0=wdi$price$values, metrics0=m0, zero0=x.price)
    x1[((nrow(x1)-2):nrow(x1)),2] <- x1[((nrow(x1)-2):nrow(x1)),1] # short set kludge

    stopifnot(nrow(x0) == nrow(x1))
    x1$year <- NULL                     # I kept the year in for debugging.

    x0 <- cbind(x0, x1)                 # add the columns
}

if (exists("x.fx")) {

    ## CPI and Wholesale, wholesale is a very short set, so I've set it equal to CPI.
    m0 <- c("DPANUSSPB", "PA.NUS.PPPC.RF")
    x1 <- wdi.filled(wdi0=wdi$fx$values, metrics0=m0, zero0=x.price)

    stopifnot(nrow(x0) == nrow(x1))
    x1$year <- NULL                     # I kept the year in for debugging.

    x0 <- cbind(x0, x1)                 # add the columns
}

## The GDP data is nearly complete, we add an industry estimate
## So different from the stable demographics.
## @todo
## I've had to add a second GDP metric to make my code work.
m0 <- c("NY.GDP.PCAP.PP.CD","SL.GDP.PCAP.EM.KD")
x2 <- wdi.filled(wdi0=wdi$gdp$values, metrics0=m0)

## Use just one prediction from above 
gdp <- gdp.predictions$gdp[1]

## Copy a blank row, make a scaling factor and apply it
x3 <- x2[nrow(x2)-1,]
f0 <- gdp/x3[1,1]                   # just a scaling factor
x3 <- f0 * x3

x2[nrow(x2),] <- x3
x2 <- x2[, c(1,3)]                  # get rid of the superfluous column

stopifnot(nrow(x0) == nrow(x2))
x2$year <- NULL

x0 <- cbind(x0, x2)

