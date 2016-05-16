## weaves

library(ggplot2)
library(gtable)
library(grid)

## weaves
##
## Not easy to plot overlay charts. (ie. different y-axis scaling)
##
## I have a colouring scheme, the most derived varible is blue
## R O Y G B I V
## but just red for the X and blue for the result/return
##
## But! I don't need it. All the given x?? r?? metrics are around 0.
grph.pair <- function(x, ref1, other1) {

    p1 <- ggplot(x, other1) + 
        geom_line(colour = "red") + theme_bw()
    p2 <- ggplot(x, ref1) + geom_line(colour = "blue") + 
        theme_bw() %+replace% theme(panel.background = element_rect(fill = NA))

    ## extract gtable
    g1 <- ggplot_gtable(ggplot_build(p1))
    g2 <- ggplot_gtable(ggplot_build(p2))

    ## overlap the panel of 2nd plot on that of 1st plot
    pp <- c(subset(g1$layout, name == "panel", se = t:r))
    g <- gtable_add_grob(g1, 
                         g2$grobs[[which(g2$layout$name == "panel")]], 
                         pp$t,
                         pp$l, pp$b, pp$l)

    ## axis tweaks
    ia <- which(g2$layout$name == "axis-l")
    ga <- g2$grobs[[ia]]
    ax <- ga$children[[2]]
    ax$widths <- rev(ax$widths)
    ax$grobs <- rev(ax$grobs)
    ax$grobs[[1]]$x <- ax$grobs[[1]]$x - unit(1, "npc") + unit(0.15, "cm")
    g <- gtable_add_cols(g, g2$widths[g2$layout[ia, ]$l], length(g$widths) - 1)
    g <- gtable_add_grob(g, ax, pp$t, length(g$widths) - 1, pp$b)

    ## draw it
    ## grid.draw(g)
    return(g)
}

### Overlay plot
## Pair the column names as strings.
grph.pair0 <- function(df, x = NULL, y1=NULL, y2=NULL) {
    if (is.null(y1)) {
        y1 <- colnames(df)[1]
    }
    
    if (is.null(y2)) {
        y2 <- colnames(df)[2]
    }
    
    if (is.null(x)) {
        df0 <- data.frame(df);
        x <- "index"
        df0[, x] <- rownames(df0)
        df <- df0
    }
    
    par(mar=c(5,4,4,5)+.1)
    plot(df[, x], df[, y1], type="l",col="red", xlab="", ylab=y1)
    par(new=TRUE)
    plot(df[, x], df[, y2], type="l",col="blue", xaxt="n",yaxt="n",xlab="",ylab="")
    axis(4)
    mtext(y2,side=4,line=3)
    legend("topleft",col=c("red","blue"),lty=1,legend=c(y1, y2))
}

