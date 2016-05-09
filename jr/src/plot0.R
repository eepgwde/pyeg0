## weaves

library(ggplot2)
library(gtable)
library(grid)

grph.pair <- function(x, p1, p2) {

    p1 <- ggplot(x, p1) + 
        geom_line(colour = "blue") + theme_bw()
    p2 <- ggplot(x, p2) + geom_line(colour = "red") + 
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

### Check some auto-correlations on the returns
## Check the result and the delta.
## Can indicate AR process.

## Short-set

acf(folios.df1$r00)

acf(folios.df1$dr00)                    # something on the 5

pacf(folios.df1$r00)                    # nothing but the first

pacf(folios.df1$dr00)                   # nothing at all!

## Full-set

acf(folios.df$r00)
## touch on the second, usual profit taking

acf(folios.df$dr00)

pacf(folios.df$r00)                     # 14 day cycle

pacf(folios.df$dr00)                    # really nothing

