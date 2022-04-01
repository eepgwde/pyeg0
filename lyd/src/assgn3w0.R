## Load packages

library(readxl)
library(emmeans)
library(dplyr)
library(ggpubr)

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

## Looking at the counts, no obvious differences: there is an man of 80 years, woman is 74.

## Number of men and women
table(mydata$sex)
## Number of ugly to not ugly
table(mydata$ugly)

## Use a Chi-squared on gender and ugly
table(mydata$sex, mydata$ugly)

## Use factors
mydata$gender <- factor(mydata$sex, levels = c(FALSE, TRUE), labels = c("M", "W"))
mydata$ugly2 <- factor(mydata$ugly, levels = c(FALSE, TRUE), labels = c("pretty", "ugly"))
mydata$steep2 <- factor(mydata$steep, levels = c(FALSE, TRUE), labels = c("modest", "steep"))

## note: ugly2 has numeric values 1 and 2 for pretty and ugly

## Check reasonable with aggregate

aggregate(. ~ ugly2 + gender, data = mydata, mean)
aggregate(. ~ ugly2 + gender, data = mydata, sd)


t0 <- table(mydata$gender, mydata$ugly2)
t0

test1 <- list()

test1$Xsq <- chisq.test(t0)

test1$Xsq

test1$Xsq$expected

jpeg(file="t0.jpeg")
mosaicplot(t0, color = TRUE)
dev.off()

test1$f <- fisher.test(t0, alternative = "greater")
test1$f

## = Q1.1 slight bias by men to ugly vegetables.

## age and gender distribution 
group_by(mydata, gender) %>%
  summarise(
    count = n(),
    mean = mean(age, na.rm = TRUE),
    sd = sd(age, na.rm = TRUE)
  )

ggboxplot(mydata,
  x = "gender", y = "age",
  color = "gender", palette = c("#00AFBB", "#E7B800"),
  ylab = "age", xlab = "Groups"
  )

## test for normality
with(mydata, shapiro.test(age[gender == "M"]))
with(mydata, shapiro.test(age[gender == "W"]))

## test for heteroskedasticity - different variances p-value < 0.05 means they are different
var.test(age ~ gender, data = mydata)

## variances are similar, so use t-test, again p-value < 0.05 means they are different
t.test(age ~ gender, data = mydata, var.equal = TRUE, alternative = "two.sided")
t.test(age ~ gender, data = mydata, var.equal = TRUE, alternative = "greater")
t.test(age ~ gender, data = mydata, var.equal = TRUE, alternative = "less")

## age distribution ugly and not ugly
group_by(filter(mydata, ugly), gender) %>%
  summarise(
    count = n(),
    mean = mean(age, na.rm = TRUE),
    sd = sd(age, na.rm = TRUE)
  )

ggboxplot(filter(mydata, ugly),
  x = "gender", y = "age",
  color = "gender", palette = c("#00AFBB", "#E7B800"),
  ylab = "age", xlab = "Groups"
)

group_by(filter(mydata, !ugly), gender) %>%
  summarise(
    count = n(),
    mean = mean(age, na.rm = TRUE),
    sd = sd(age, na.rm = TRUE)
  )

ggboxplot(filter(mydata, !ugly),
  x = "gender", y = "age",
  color = "gender", palette = c("#00AFBB", "#E7B800"),
  ylab = "age", xlab = "Groups"
  )

## older men choose pretty?

test1.aov <- aov(age ~ ugly2 + gender, data = mydata)
summary(test1.aov)

TukeyHSD(test1.aov)

## Try logistic regression to guess at whether they choose ugly
test1.logit <- glm(ugly ~ age + gender, family = binomial(link = "logit"), mydata)
summary(test1.logit)

predict(test1.logit, newdata = list(age = 40, gender = "W"), type = "response")
predict(test1.logit, newdata = list(age = 40, gender = "M"), type = "response")

test1.logit <- glm(ugly2 ~ age + gender, family = binomial(link = "logit"), mydata)
summary(test1.logit)

predict(test1.logit, newdata = list(age = 40, gender = "W"), type = "response")
predict(test1.logit, newdata = list(age = 40, gender = "M"), type = "response")


## check we can bias this by adding 10 to the age of people who choose ugly2

mydata1 <- mydata
mydata1[mydata1$ugly2 == "ugly", "age"] <- mydata1[mydata1$ugly2 == "ugly", "age"] + 10

test1.logit <- glm(ugly2 ~ age + gender, family = binomial(link = "logit"), mydata1)
summary(test1.logit)

predict(test1.logit, newdata = list(age = 60, gender = "W"), type = "response")
predict(test1.logit, newdata = list(age = 60, gender = "M"), type = "response")


## H1: “Ugly” labeling (vs. no specific label) increases the likelihood that consumers purchase
## unattractive produce
## H2: The positive effect of “ugly” labeling on purchase is moderated by the depth of price discount,
## such that “ugly” labeling is most effective when associated with a moderate (vs. steep) discount
## H3: The positive effect of “ugly” labeling on purchase is moderated by vegetable consumption
## frequency, such that “ugly” labeling is most effective when vegetable consumption frequency is high
## (vs. low)

## Q2. Test H1 and report the results consistent with the result section in the corresponding lecture

## "the likelihood" here, refers to the column in the table. The customers opinion of the vegetable boxes
## So it is a conditional relationship: given they purchased "ugly" vegetables, what score did they assign
## to the boxes.

test2.aov <- aov(likelihood ~ ugly2, data = mydata)
summary(test2.aov)

## alternative hypothesis, because Pr(>F) << 0.05
## This seems rational

## Q3. Test H2 and report the results consistent with the result section in the corresponding lecture

## when a moderate discount is applied, shoppers buy ugly, but not with a steep discount

t3 <- table(mydata$ugly2, mydata$steep2)

test3.aov <- aov(ugly2 ~ steep2, data = mydata)
summary(test3.aov)



## Q4. Test H3 and report the results consistent with the result section in the corresponding lecture
