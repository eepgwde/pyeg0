df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),
                 y = rnorm(30))
## Compute sample mean and standard deviation in each group
ds <- plyr::ddply(df, "gp", plyr::summarise, mean = mean(y), sd = sd(y))

## Declare the data frame and common aesthetics.
## The summary data frame ds is used to plot
## larger red points in a second geom_point() layer.
## If the data = argument is not specified, it uses the
## declared data frame from ggplot(); ditto for the aesthetics.
ggplot(df, aes(x = gp, y = y)) +
    geom_point() +
    geom_point(data = ds, aes(y = mean),
               colour = 'red', size = 3)


## Same plot as above, declaring only the data frame in ggplot().
## Note how the x and y aesthetics must now be declared in
## each geom_point() layer.
ggplot(df) +
    geom_point(aes(x = gp, y = y)) +
    geom_point(data = ds, aes(x = gp, y = mean),
               colour = 'red', size = 3)

## Set up a skeleton ggplot object and add layers:
ggplot() +
    geom_point(data = df, aes(x = gp, y = y)) +
    geom_point(data = ds, aes(x = gp, y = mean),
               colour = 'red', size = 3) +
    geom_errorbar(data = ds, aes(x = gp, y = mean,
                                 ymin = mean - sd, ymax = mean + sd),
                  colour = 'red', width = 0.4)


library(ggplot2)
library(gtable)
library(grid)

grid.newpage()

## two plots
p1 <- ggplot(mtcars, aes(mpg, disp)) + geom_line(colour = "blue") + theme_bw()
p2 <- ggplot(mtcars, aes(mpg, drat)) + geom_line(colour = "red") + theme_bw() %+replace% 
    theme(panel.background = element_rect(fill = NA))

## extract gtable
g1 <- ggplot_gtable(ggplot_build(p1))
g2 <- ggplot_gtable(ggplot_build(p2))

## overlap the panel of 2nd plot on that of 1st plot
pp <- c(subset(g1$layout, name == "panel", se = t:r))
g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, 
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
grid.draw(g)


p1 <- ggplot(mtcars, aes(mpg, disp)) + geom_line(colour = "blue") + theme_bw()
p2 <- ggplot(mtcars, aes(mpg, drat)) + geom_line(colour = "red") + theme_bw() %+replace% 
    theme(panel.background = element_rect(fill = NA))

## extract gtable
g1 <- ggplot_gtable(ggplot_build(p1))
g2 <- ggplot_gtable(ggplot_build(p2))

## overlap the panel of 2nd plot on that of 1st plot
pp <- c(subset(g1$layout, name == "panel", se = t:r))
g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, 
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
grid.draw(g)
