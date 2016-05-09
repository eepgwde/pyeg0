### weaves
## A plotting script
## quick eye-ball of the variables.

### ACF and others 

grph.set0 <- function(nm0, jpeg0=NULL) {
    if (!is.null(jpeg0)) {
        nm0.tag <- nm0
        nm0.fspec <- paste(nm0.tag, "-%03d.jpeg", sep ="")
        jpeg(width=1024, height=768, filename = nm0.fspec)
    }

    a0.p1 <- aes(dt0, r00)

    a0.p2 <- aes_(x = as.name("dt0"), y = as.name(nm0))

    grid.draw(grph.pair(folios.df1, a0.p1, a0.p2))

### Auto-correlations
    
    acf(folios.df1[, nm0], main=paste("acf: tail: ", nm0))
    acf(folios.df[, nm0], main=paste("acf: full: ", nm0))

    pacf(folios.df1[, nm0], main=paste("pacf: tail: ", nm0))
    pacf(folios.df[, nm0], main=paste("pacf: full: ", nm0))

### Try a ccf with the name

    ccf(folios.df1$r00, folios.df1[, nm0], 
        main=paste("ccf: tail: r00:", nm0))

    ## Full-set

    ccf(folios.df$r00, folios.df[, nm0],
        main=paste("ccf: full: r00:", nm0))

    ## x01 clearly lags by one or two days.
    if (!is.null(jpeg0)) {
        dev.off()
    }
}

ts0.plot <- function(tbl, names0, xtra="r00", fname="XX0") {
    names.xr <- append(xtra, names0)

    ts.gpars=list(xlab="day", ylab="metric", main=fname,
                  lty=1:4, col=1:length(names.xr) )

    ts.plot(tbl[, names.xr], gpars=ts.gpars)
    legend("topleft", names.xr, lty=ts.gpars$lty, col=ts.gpars$col)
}

folio.marks0 <- function(tbl) {
    s0 <- paste(as.character(c(head(tbl$dt0, 1), 
                               tail(tbl$dt0, 1))), collapse="-")
    return(s0)
}

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

