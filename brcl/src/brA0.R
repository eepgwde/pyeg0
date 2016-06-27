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

## More re-classing.
## http://scg.sdsu.edu/dataset-adult_r/
## Set a low value for not-working

adult.workclass <- function(wclass) {
    wclass <- as.character(wclass)
    wclass <- gsub("^Federal-gov","Federal-Govt",wclass)
    wclass <- gsub("^Local-gov","Other-Govt",wclass)
    wclass <- gsub("^State-gov","Other-Govt",wclass)
    wclass <- gsub("^Private","Private",wclass)
    wclass <- gsub("^Self-emp-inc","Self-Employed",wclass)
    wclass <- gsub("^Self-emp-not-inc","Self-Employed",wclass)
    wclass <- gsub("^Without-pay","Not-Working",wclass)
    wclass <- gsub("^Never-worked","Not-Working",wclass)

    wclass <- ordered(as.factor(wclass), 
                      levels = c("Not-Working", "Self-Employed", "Private", "Other-Govt", "Federal-Govt"))
    
    return(wclass)
}

adult.occupation <- function(occ) {
    occ <- as.character(occ)
    occ <- gsub("^Adm-clerical","Admin",occ)
    occ <- gsub("^Armed-Forces","Military",occ)
    occ <- gsub("^Craft-repair","Blue-Collar",occ)
    occ <- gsub("^Exec-managerial","White-Collar",occ)
    occ <- gsub("^Farming-fishing","Blue-Collar",occ)
    occ <- gsub("^Handlers-cleaners","Blue-Collar",occ)
    occ <- gsub("^Machine-op-inspct","Blue-Collar",occ)
    occ <- gsub("^Other-service","Service",occ)
    occ <- gsub("^Priv-house-serv","Service",occ)
    occ <- gsub("^Prof-specialty","Professional",occ)
    occ <- gsub("^Protective-serv","Other-Occupations",occ)
    occ <- gsub("^Sales","Sales",occ)
    occ <- gsub("^Tech-support","Other-Occupations",occ)
    occ <- gsub("^Transport-moving","Blue-Collar",occ)

    occ <- ordered(as.factor(occ), 
                      levels = c("Blue-Collar", "Service", "Admin", "Military", "Sales", "Other-Occupations", "White-Collar", "Professional"))
    
    return(occ)
}

adult.country <- function(country) {

data$country[data$country=="Cambodia"] = "SE-Asia"
data$country[data$country=="Canada"] = "British-Commonwealth"    
data$country[data$country=="China"] = "China"       
data$country[data$country=="Columbia"] = "South-America"    
data$country[data$country=="Cuba"] = "Other"        
data$country[data$country=="Dominican-Republic"] = "Latin-America"
data$country[data$country=="Ecuador"] = "South-America"     
data$country[data$country=="El-Salvador"] = "South-America" 
data$country[data$country=="England"] = "British-Commonwealth"
data$country[data$country=="France"] = "Euro_1"
data$country[data$country=="Germany"] = "Euro_1"
data$country[data$country=="Greece"] = "Euro_2"
data$country[data$country=="Guatemala"] = "Latin-America"
data$country[data$country=="Haiti"] = "Latin-America"
data$country[data$country=="Holand-Netherlands"] = "Euro_1"
data$country[data$country=="Honduras"] = "Latin-America"
data$country[data$country=="Hong"] = "China"
data$country[data$country=="Hungary"] = "Euro_2"
data$country[data$country=="India"] = "British-Commonwealth"
data$country[data$country=="Iran"] = "Other"
data$country[data$country=="Ireland"] = "British-Commonwealth"
data$country[data$country=="Italy"] = "Euro_1"
data$country[data$country=="Jamaica"] = "Latin-America"
data$country[data$country=="Japan"] = "Other"
data$country[data$country=="Laos"] = "SE-Asia"
data$country[data$country=="Mexico"] = "Latin-America"
data$country[data$country=="Nicaragua"] = "Latin-America"
data$country[data$country=="Outlying-US(Guam-USVI-etc)"] = "Latin-America"
data$country[data$country=="Peru"] = "South-America"
data$country[data$country=="Philippines"] = "SE-Asia"
data$country[data$country=="Poland"] = "Euro_2"
data$country[data$country=="Portugal"] = "Euro_2"
data$country[data$country=="Puerto-Rico"] = "Latin-America"
data$country[data$country=="Scotland"] = "British-Commonwealth"
data$country[data$country=="South"] = "Euro_2"
data$country[data$country=="Taiwan"] = "China"
data$country[data$country=="Thailand"] = "SE-Asia"
data$country[data$country=="Trinadad&Tobago"] = "Latin-America"
data$country[data$country=="United-States"] = "United-States"
data$country[data$country=="Vietnam"] = "SE-Asia"
    data$country[data$country=="Yugoslavia"] = "Euro_2"

    

    return(country)

}
