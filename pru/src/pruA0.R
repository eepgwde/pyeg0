## weaves

## Pru support methods.

## Total checker for the hexp-065.csv data.
inc.ds0 <- function(df) {
    df0 <- df[ is.na(df$decile), ]
    df1 <- df[ !is.na(df$decile), ]

    df0 <- reshape(df0, direction="wide")
    df1 <- reshape(df1, direction="wide")

    df01 <-  sapply(df0[, 5:16], sum)
    df11 <-  sapply(df1[, 5:16], sum)
    return(df01 - df11)
}

## Find a usable income statistics
wdi.search1 <- function(tag) {
    y0 <- WDI(indicator=tag, country=c('ID'), start=2005, end=2016)
    if (is.null(y0)) { return(NULL) }
    
    f0 <- all(is.na(y0[[ tag ]]))
    if (f0) { return(NULL) }
    return(y0)
}

## Find all usable income statistics
wdi.search0 <- function(tag, country=C('ID'), start0=2005, end0=2016) {

    x0 <- WDIsearch('income')
    x1 <- data.frame(x0, stringsAsFactors = FALSE)
    x1$valid <- FALSE

    x2 <- lapply(x1$indicator, wdi.search1)

    x1$valid <- sapply(1:length(x2), function(x) !is.null(x2[[x]]), 
                       simplify=TRUE, USE.NAMES=FALSE)

    x2 <- x2[x1$valid]

    n0 <- x1$indicator[ x1$valid ]
    n0 <- n0[1]

    r0 <- data.frame(year=start0:end0)

    r0 <- merge(r0, x2[[1]], all=TRUE)

    mn <- setdiff(colnames(r0), n0)

    ## Not use of assign to outer-most <<-
    invisible(lapply(2:length(x2), function(x) { r0 <<- merge(r0, x2[[x]], by=mn, all=TRUE) }))

    r1 <- list()
    r1$indicators <- x1
    r1$values <- r0
    
    return(r1)
}
