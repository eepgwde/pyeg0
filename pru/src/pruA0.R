## weaves

inc.ds0 <- function(df) {
    df0 <- df[ is.na(df$decile), ]
    df1 <- df[ !is.na(df$decile), ]

    df0 <- reshape(df0, direction="wide")
    df1 <- reshape(df1, direction="wide")

    df01 <-  sapply(df0[, 5:16], sum)
    df11 <-  sapply(df1[, 5:16], sum)
    return(df01 - df11)
}

