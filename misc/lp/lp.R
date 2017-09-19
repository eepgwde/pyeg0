
library(Rglpk)

library(xtable)

# c("MPS_fixed", "MPS_free", "CPLEX_LP", "MathProg"), 

fl0 <- "plan.mod"
decimal <- 0

x0 <- Rglpk_read_file(fl0, type = "MathProg", verbose=TRUE)

sol <- Rglpk_solve_LP(x0$objective, x0$constraints[[1]],
                      x0$constraints[[2]], x0$constraints[[3]],
                      x0$bounds, x0$types, x0$maximum)

df <- as.data.frame(sol$solution)
df <- rbind(df, c(sol$optimum))

rownames(df) <- c(attr(x0, " objective_vars_names"), "obj")
colnames(df) <- "Solution"


