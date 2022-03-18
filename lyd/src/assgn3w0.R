## Load packages

library(readxl)
library(emmeans)
library(dplyr)

## Set working directory (see video on CANVAS)
# setwd("C:/Users/lydkd/OneDrive/Documents/subject/foo")

## Load the database
database <- read_excel("cache/Assignment3_data.xlsx")

## Take a sample using birthday
mydata <- database[which(database$birthday4=='1'),]

## now drop all birthday columns
cols = names(mydata)
ncols = cols[!grepl("birthday", cols)]

mydata <- mydata[ncols]

## Q1. Test whether age and gender differ between the “ugly” labeling and no labeling conditions

## type conversion. Mostly logical except age and veggie_freq.
## sex when true is female.
## steep is large discount offered

## veggie_freq is -5 to 5 where -5 is never eats veg.
## likelihood is 1 to 5 to buy ugly: 1 is the pretty box, 5 is the ugly box.

mydata <- mydata %>% mutate(ugly = as.logical(ugly), steep = as.logical(steep), sex = as.logical(sex),
                            age = as.integer(age), veggie_freq = as.integer(veggie_freq),
                            likelihood = as.integer(likelihood))

## Looking at the averages, no obvious differences: there is an man of 80 years, woman is 74.

## Number of men and women
table(mydata$sex)
## Number of ugly to not ugly
table(mydata$ugly)

## Use a Chi-squared on gender and ugly
table(mydata$sex, mydata$ugly)

## Use factors
mydata$gender <- factor(mydata$sex, levels = c(TRUE, FALSE), labels = c("W", "M"))
mydata$ugly2 <- factor(mydata$ugply, levels = c(TRUE, FALSE), labels = c("ugly", "pretty"))

t0 <- table(mydata$gender, mydata$ugly2)
t0

test1 <- chisq.test(t0)

test1$statistic
test1$p.value

mosaicplot(t0, color = TRUE, xlab = "gender", ylab = "ugly")

attr(test)

vs = list()
summary(mydata$age)
summary(filter(mydata, sex)$age)
summary(filter(mydata, !sex)$age)
summary(filter(mydata, ugly)$age)
summary(filter(mydata, !ugly)$age)

vs = list()
vs = append(vs, list(mydata$age))
vs = append(vs, list(filter(mydata, sex)$age))
vs = append(vs, list(filter(mydata, !sex)$age))
vs = append(vs, list(filter(mydata, ugly)$age))
vs = append(vs, list(filter(mydata, !ugly)$age))

par(mfrow = c(1, length(vs)))
invisible(lapply(1:length(vs), function(i) boxplot(vs[i])))

table(mydata$sex, mydata$ugly)



step_1 <- select(mydata, ugly, sex, age)
ugly <- filter (step_1, ugly == "1")
not_ugly<- filter (step_1, ugly == "0")
age_ugly <- mean(ugly$age)
age_not_ugly <- mean(not_ugly$age)

##there is a slight age difference between the ugly and no labeling conditions.
gender_ugly <- mean(ugly$sex)
gender_not_ugly <- mean(not_ugly$sex)


##there are slightly more females in the "not ugly" label.
## Q2. Test H1 and report the results consistent with the result section in the corresponding lecture
##H1: “Ugly” labeling (vs. no specific label) increases the likelihood that consumers purchase unattractive produce
##ugly= binary categorical, likelyhood to purchase is binary quantitative, meaning that anova test is nesecary
mydata$ugly <-factor(mydata$ugly, labels = c("non_ugly", "ugly"))
aggregate(likelihood ~ ugly, mydata, mean)
anova_H1 <- aov(likelihood ~ ugly, data=mydata)
summary(anova_H1)
## Q3. Test H2 and report the results consistent with the result section in the corresponding lecture


## Q4. Test H3 and report the results consistent with the result section in the corresponding lecture
