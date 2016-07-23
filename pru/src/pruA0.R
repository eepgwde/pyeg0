## weaves

library(ineq)

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

## WDI delta

## Make a time-series object
wdi.ts <- function(x0) {
    ts0 <- ts(x0[, setdiff(colnames(x0), "year") ], 
              start=x0$year[1], 
              end=x0$year[length(x0$year)])
    return(ts0)
}

wdi.delta <- function(tbl, m0) {
    x0 <- tbl$values[, union("year", m0) ]
    dt <- wdi.ts(x0)
    # This adds a prefix
    dt <- dt / lag(dt, -1) - 1

    lapply(colnames(dt), function(x) { x0[[ x ]] <<- c(NA, as.numeric(dt[,x])) })

    return(x0)
}

## Extract only the delta values and return as a time-series
wdi.deltas <- function(df) {
    dts <- colnames(df)[grepl("^dt\\..*", colnames(df))]
    return(wdi.ts(df[, union("year", dts)]))
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

    x0 <- WDIsearch(tag)
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

## Many of these figure are too sparse
## Also we checked for 2016, so we expect one to be blank for all
wdi.filter0 <- function(w0) {
    x0 <- w0
    i0 <- x0$indicators[ x0$indicators$valid, "indicator" ]

    f0 <- function(x) {
        return( sum( !is.na(x0$values[ x ] )))
    }
        
    c0 <- sapply(i0, f0, simplify=TRUE, USE.NAMES = FALSE)

    x0$indicators$n0 <- 0
    x0$indicators[ x0$indicators$valid, "n0"] <-  c0

    return(x0)
}

## Write the whole WDI indicators structure to a CSV file.
## @param w1 is the top-level wdi structure.
wdi.csv <- function(w1) {
    n0 <- names(w1)

    f0 <- function(x) {
        t0 <- w1[[ x ]]
        t0 <- t0$indicators
        write.csv(t0, file=paste(x, "csv", sep="."), na="", row.names=FALSE)
        return(nrow(t0))
    }
    
    r0 <- sapply(n0, f0)
    return(r0)
}

## Calculate some Gini
## tbl <- folios.in[ folios.in$type0 == "h" & folios.in$cls == "lower", ]

ts.gini0 <-  function(x1) {
    x2 <- ts(x1)

    v0 <- sapply(1:nrow(x2), 
                 function(x) { return(ineq(x2[x,], type="Gini")) }, 
                 simplify=TRUE, USE.NAMES=FALSE)

    x1$gini <- v0
    return(data.frame(x1))
}

## A Gini for each year for each category.
## ds1 table only "h"
ds.gini0 <- function(x0, c0="Alcoholic") {
    x1 <- unstack(x0[ x0$Categories == c0, c("X", "decile", "time") ], X ~ decile)
    x2 <- ts.gini0(x1)
    x2 <- data.frame(gini=x2$gini, Categories=c0)
    x2$Categories <- c0
    x2$time <- unique(x0[ x0$Categories == c0, c("time")])
    return(x2)
}

ds.gini1 <- function(y0) {
    l0 <- lapply(levels(y0$Categories), function(x) { return(ds.gini0(y0, c0=x)) })

    l1 <- l0[[1]]

    lapply(2:length(l0), function(x) { l1 <<- rbind(l1, l0[[x]]) } )

    l1$Categories <- factor(l1$Categories, levels(y0$Categories), labels = levels(y0$Categories))
    
    return(l1)
}

library(grid)
library(ggplot2)

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
