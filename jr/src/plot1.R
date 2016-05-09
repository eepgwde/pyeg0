### weaves
## A plotting script
## quick eye-ball of the variables.

### Some sample plots

a0.p1 <- aes(dt0, r00)

a0.p2 <- aes_(x = as.name("dt0"), y = as.name(a0.nm))

grid.draw(grph.pair(folios.df1, a0.p1, a0.p2))

## x01 clearly lags.

### Try a ccf with the name

ccf(folios.df1$r00, folios.df1[, a0.nm])

## Full-set

ccf(folios.df$r00, folios.df[, a0.nm])

## x01 clearly lags by one or two days.
