### weaves
## A plotting script
## quick eye-ball of the variables.

### Some sample plots

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

# nm0.fspec <- paste(nm0.tag, "-%03d.jpeg", sep ="")

# jpeg(width=1024, height=768, filename = nm0)

grph.set0("x01")

grph.set0("x01", jpeg0=TRUE)

# dev.off()

names.xr <- append(names.x, "r00")

ts.plot(folios.in0[, names.xr],
             gpars=list(xlab="day", ylab="metric", 
                        lty=c(1:length(names.xr))))

