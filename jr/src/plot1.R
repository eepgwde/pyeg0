### weaves
## A plotting script
## quick eye-ball of the variables.

### ACF and others 

grph.set0 <- function(data0, nm0, jpeg0=NULL, 
                      idx0="dt0", ref0="r00", ntail=60) {
    
    if (!is.null(jpeg0)) {
        nm0.tag <- nm0
        nm0.fspec <- paste(nm0.tag, "-%03d.jpeg", sep ="")
        jpeg(width=1024, height=768, filename = nm0.fspec)
    }

    a0.p1 <- aes_(x = as.name(idx0), y = as.name(ref0))
    a0.p2 <- aes_(x = as.name(idx0), y = as.name(nm0))

    data1 <- tail(data0, n = ntail)

    grid.draw(grph.pair(data1, a0.p1, a0.p2))

### Auto-correlations
    
    acf(data1[, nm0], main=paste("acf: tail: ", nm0))
    acf(data0[, nm0], main=paste("acf: full: ", nm0))

    pacf(data1[, nm0], main=paste("pacf: tail: ", nm0))
    pacf(data0[, nm0], main=paste("pacf: full: ", nm0))

### Try a ccf with the name

    ccf(data1[, ref0], data1[, nm0], 
        main=paste("ccf: tail: ", ref0, nm0))

    ## Full-set

    ccf(data0[, ref0], data0[, nm0],
        main=paste("ccf: full: ", ref0, nm0))

    ## x01 clearly lags by one or two days.
    if (!is.null(jpeg0)) {
        dev.off()
    }
}

## Plots time-series
##
## Try and adapt this for the unstacked dataset.
ts0.plot <- function(tbl, names0, xtra="r00", 
                     fname="XX0", 
                     ylab0="metric") {
    names.xr <- names0
    if (!is.null(xtra)) {
        names.xr <- append(xtra, names0)
    }

    ts.gpars=list(xlab="day", ylab=ylab0, main=fname,
                  lty=1:4, col=1:length(names.xr) )

    ts.plot(tbl[, names.xr], gpars=ts.gpars)
    legend("topleft", names.xr, lty=ts.gpars$lty, col=ts.gpars$col)
}

folio.marks0 <- function(tbl) {
    s0 <- paste(as.character(c(head(tbl$dt0, 1), 
                               tail(tbl$dt0, 1))), collapse="-")
    return(s0)
}

## Plots to JPEG
##
## Uses globals.
## Specifically for jr0.R

ts0.folio <- function(tbl) {
    nm0.tag <- folio.name
    nm0.marks <- folio.marks0(tbl)
    nm0.fspec <- paste(nm0.tag, nm0.marks, "-%03d.jpeg", sep ="")

    jpeg(width=1024, height=768, filename = nm0.fspec)

    lapply(1:dim(names.idxes)[1], 
           function(y) ts0.plot(tbl, 
                                names.x[names.idxes[y,]], 
                                fname=folio.name))

    dev.off()
}

## Plots to JPEG
##
## Doesn't use globals.
##
## names.idxes is a matrix of indices into the column names.

ts1.folio <- function(tbl, names.idxes, 
                      tag0="folios", xtra0=NULL,
                      names.x=NULL, ylab0="metric") {

    nm0.tag <- tag0
    rs <- rownames(tbl)
    nm0.marks <- paste(rs[1], rs[length(rs)], sep="-")
    nm0.fspec <- paste(nm0.tag, nm0.marks, "-%03d.jpeg", sep ="")

    if (is.null(names.x)) {
        names.x <- colnames(tbl)
    }

    jpeg(width=1024, height=768, filename = nm0.fspec)

    lapply(1:dim(names.idxes)[1], 
           function(y) ts0.plot(tbl, 
                                unique(append(xtra0, names.x[names.idxes[y,]])),
                                ylab0=ylab0,
                                fname=tag0, xtra=NULL))

    dev.off()
}

## tbl <- folios.ustk0
## tag0 <- "folios"

## nm0.tag <- tag0
## rs <- rownames(tbl)
## nm0.marks <- paste(rs[1], rs[length(rs)], sep="-")
## nm0.fspec <- paste(nm0.tag, nm0.marks, "-%03d.jpeg", sep ="")

## rm("tbl", "tag0", "rs")

ustck.folio <- function(tbl,
                        folios.metric="p00") {

    folios.forml <- as.formula(paste(folios.metric, "~", "folio0"))

    ## unstack and find a way of plotting.
    folios.ustk <- unstack(tbl, folios.forml)
    return(folios.ustk)
}

