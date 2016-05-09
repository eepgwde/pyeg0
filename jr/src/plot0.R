## weaves

library(ggplot2)
library(gtable)
library(grid)

grph.pair <- function(p1, p2) {

    p1 <- ggplot(folios.in, p1) + 
        geom_line(colour = "blue") + theme_bw()
    p2 <- ggplot(folios.in, p2) + geom_line(colour = "red") + 
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

## Some sample plots

a0.p1 <- aes(dt0, m5r00)
a0.p2 <- aes(dt0, m5x01)

grid.draw(grph.pair(a0.p1, a0.p2))
