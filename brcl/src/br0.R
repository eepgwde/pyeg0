## weaves
##
## Data analysis: look and feel
## Similar to the AdultUCI data set.


library("arules")

source("brA0.R")

data("AdultUCI")

df0 <- adult.class0(AdultUCI)

AdultUCI[["fnlwgt"]] <- NULL
AdultUCI[["education-num"]] <- NULL

AdultUCI[[ "age"]] <- ordered(cut(AdultUCI[[ "age"]], c(15,25,45,65,100)),
                              labels = c("Young", "Middle-aged", "Senior", "Old"))

AdultUCI[[ "hours-per-week"]] <- ordered(cut(AdultUCI[[ "hours-per-week"]],
                                             c(0,25,40,60,168)),
                                         labels = c("Part-time", "Full-time", "Over-time", "Workaholic"))

AdultUCI[[ "capital-gain"]] <- ordered(cut(AdultUCI[[ "capital-gain"]],
                                           c(-Inf,0,median(AdultUCI[[ "capital-gain"]][AdultUCI[[ "capital-gain"]]>0]),Inf)),
                                       labels = c("None", "Low", "High"))

AdultUCI[[ "capital-loss"]] <- ordered(cut(AdultUCI[[ "capital-loss"]],
                                           c(-Inf,0,
                                             median(AdultUCI[[ "capital-loss"]][AdultUCI[[ "capital-loss"]]>0]),Inf)),
                                       labels = c("none", "low", "high"))

## Preparation: save as CSV from XL
## sed -e 's/," /,"/g'
## to remove leading spaces in text fields.

ppl <- read.csv("../bak/CustomerData1.csv", 
                stringsAsFactors=TRUE, strip.white=TRUE,
                header=TRUE, na.strings=c("?"))

ppl0 <- ppl

colnames(ppl) <- colnames(AdultUCI)
ppl$income <- AdultUCI$income

ppl$education <- ordered(ppl$education, levels(AdultUCI$education))

ppl[[ "age"]] <- ordered(cut(ppl[[ "age"]], c(15,25,45,65,100)),
                              labels = c("Young", "Middle-aged", "Senior", "Old"))

ppl[[ "hours-per-week"]] <- ordered(cut(ppl[[ "hours-per-week"]],
                                             c(0,25,40,60,168)),
                                         labels = c("Part-time", "Full-time", "Over-time", "Workaholic"))

ppl[[ "capital-gain"]] <- ordered(cut(ppl[[ "capital-gain"]],
                                           c(-Inf,0,median(ppl[[ "capital-gain"]][ppl[[ "capital-gain"]]>0]),Inf)),
                                       labels = c("None", "Low", "High"))

ppl[[ "capital-loss"]] <- ordered(cut(ppl[[ "capital-loss"]],
                                           c(-Inf,0,
                                             median(ppl[[ "capital-loss"]][ppl[[ "capital-loss"]]>0]),Inf)),
                                       labels = c("none", "low", "high"))




all.equal(ppl, AdultUCI)
    

## Refactoring

levels(ppl$ed)

levels(ppl$wclass)

levels(ppl$ed)

"Preschool"    
"1st-4th"
"5th-6th"
"7th-8th"
"9th"
"10th"
"11th"
"12th"
"HS-grad"
"Assoc-voc"
"Assoc-acdm"
"Some-college"
"Bachelors"   
"Masters"
"Prof-school" 
"Doctorate"    

## Source the scripts support scripts.

source("brA1.R")

## 


