## weaves

## weaves
##
## Re-classification of AdultHCI table
adult.class0 <- function(df) {
    df[["fnlwgt"]] <- NULL
    df[["education-num"]] <- NULL

    df[[ "age"]] <- ordered(cut(df[[ "age"]], c(15,25,45,65,100)),
                            labels = c("Young", "Middle-aged", "Senior", "Old"))

    df[[ "hours-per-week"]] <- ordered(cut(df[[ "hours-per-week"]],
                                           c(0,25,40,60,168)),
                                       labels = c("Part-time", "Full-time", "Over-time", "Workaholic"))

    df[[ "capital-gain"]] <- ordered(cut(df[[ "capital-gain"]],
                                         c(-Inf,0,median(df[[ "capital-gain"]][df[[ "capital-gain"]]>0]),Inf)),
                                     labels = c("None", "Low", "High"))

    df[[ "capital-loss"]] <- ordered(cut(df[[ "capital-loss"]],
                                         c(-Inf,0,
                                           median(df[[ "capital-loss"]][df[[ "capital-loss"]]>0]),Inf)),
                                     labels = c("none", "low", "high"))

    
    return(df)
}

