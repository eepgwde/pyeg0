
# ## SMAVA
# 
# Test exercise - Question 1

# In[1]:


## weaves
## smava

getwd()

## load in packages
library(Hmisc)

library(ranger)
library(MASS)
library(tidyverse)
library(e1071)

library(rpart)
library(rpart.plot)
library(ipred)
library(mlbench)
library(pROC)
library(gbm)
library(dplyr)
library(caret)

library(doMC)

registerDoMC(cores = detectCores(all.tests = FALSE, logical = TRUE))

options(useFancyQuotes = TRUE)


# In[2]:


## Data sets

load("bak/in/train.rdata")
load("bak/in/test.rdata")

train0 <- data.frame(train) # a local copy.

# Carry some configuration data
smava0 <- list()

# See some summaries.
sapply(train, class)
sapply(train, summary)

## Order to highlight NA pattern.

## The outcome variable accepted is balanced. So need to upsample.

## customerNumber has 15000 unique.

## NA's on interestRate, and x2. x2 is specific to customer.

## interestRate is for regression analysis later

fnas <- function(x) sum(as.integer(is.na(train[[x]])))
fnas("x2")
fnas("interestRate")

## interestRate is only given for accepted
train[(train$accepted == "NO") & !is.na(train$interestRate), c("accepted", "interestRate")]


# In[3]:


## No obvious rule
## sapply(train[is.na(train$x2),], summary)
## sapply(train[!is.na(train$x2),], summary)

## x2 is blank for a type of customer.

train1 <- train[order(train$customerNumber, train$bank),]
outcomes <- (train1$accepted == "YES") * 1
## store the outcomes as numerics.
train1$outcomes <- outcomes

smava0$outcomes <- outcomes

idx <- as.vector(sapply(train1, class, USE.NAMES=FALSE) == "factor")
smava0$cs <- colnames(train1)[idx]

for(c in smava0$cs) {
  train1[[c]] <- as.numeric(train1[[c]])
}

train2 <- train1 %>% dplyr::select(customerNumber, x2) %>% 
group_by(customerNumber) %>% summarise(n = n(), na0 = sum(is.na(x2))) 


# In[4]:


## And is all NA at all banks for a set of customers.

### Sanity check

## This is an empty set. For all those records where n is not equal to the number of nas in x2 for
## that customer.
train2[ (train2$n != train2$na0) && (train2$na0 > 0),]
## TODO
## I should check the bank hits too.
## NOTE
## It isn't easy to impute with this.

## capture those customers who have x2 at NA.

smava0$"null-customer" <- train2[train2$na0 > 0, "customerNumber"][["customerNumber"]]
length(smava0$"null-customer")


# In[5]:


## store some colnames sets.

col0 <- colnames(train1)
smava0$results <- train1[c("accepted", "interestRate")]
smava0$ctl <- train1[c("customerNumber", "bank")]
smava0$nullcols <- c("x2")
## outcomes comes in as a feature.
smava0$ft0 <- setdiff(col0, union(colnames(smava0$results), colnames(smava0$ctl)))
smava0$ft0 <- c(smava0$ft0, "bank")
##

save(train1, smava0, file="smava0.dat")


# In[6]:


## Correlations dataset.
## The same record may fail or succeed depending on the bank.
## I haven't encoded the bank, because you would hope banks follow similar policies.
## So we may have records that are identical but fall once and succeed at another bank.
## This just for correlations.

## Let's add a boolean for when x2 is null and assign the mean of x2 as the value.

load("smava0.dat", envir=.GlobalEnv)

train1$x2na <- 0
train1[ is.na(train1$x2), "x2na" ] <- 1
smava0$x2impute <- as.vector(summary(train1$x2)['Mean'])
train1[ is.na(train1$x2), "x2" ] <- smava0$x2impute


# In[7]:


## Pair-plot
train1p <- train1[, c(smava0$ft0, "x2na") ]


# In[8]:


nm0.fspec <- paste("smava0", "pp", "-%03d.jpeg", sep ="")

jpeg(width=1024, height=768, filename= nm0.fspec)
plot(train1p)
dev.off()


# In[ ]:


## correlations

smava0$cor <- cor(train1p)

jpeg(filename=paste("smava0", "cc", "-%03d.jpeg", sep=""),
     width=1024, height=768)

corrplot::corrplot(smava0$cor, method="number", order="hclust")

dev.off()

ihcor <- findCorrelation(smava0$cor, cutoff = .75, verbose = FALSE)
smava0$hcor <- colnames(train1p)[ihcor]

## This is encouraging. x3 is -0.98 with x10 and x10 is -0.21 with outcomes.
## Let's discard x3 because it duplicates x10

## Near Zero Variables

nzv0 <- nearZeroVar(train1p, saveMetrics = TRUE, allowParallel=TRUE, freqCut =95/5, uniqueCut=10)
all(!nzv0$nzv)
all(!nzv0$zeroVar)

## So good distributions.


# In[15]:


## Dataset 1

## Remove x3, remove all blank x2, leave bank in.
## Try a fast GBM using all cores.

train1n <- data.frame(train1p)

## because I've used outcomes as a numerical column. I now convert it back to labels.
## It must be a valid R variable name, so convert the numbers to a factor, and relabel the
## the levels.
outcomes <- as.factor(train1n$outcomes)
outcomes <- factor(outcomes, levels = c("0", "1"), labels = c("No", "Yes"))

## Center and scale

xcols <- union(smava0$hcor, "outcomes")
cols <- setdiff(colnames(train1n), xcols)
smava0$ft1 <- cols
train1n <- train1n[,smava0$ft1]

## Store this prepro
smava0$pp <- preProcess(train1n, method = c("center", "scale"))

df0 <- predict(smava0$pp, train1n)

## simple controls

fitControl <- trainControl(
    method = "repeatedcv",
    number = 5,
    ## repeated a few times
    repeats = 3,
    summaryFunction = twoClassSummary,
  classProbs = TRUE)

gbmGrid <- expand.grid(interaction.depth = c(1, 2, 3),
                       n.trees = (1:20)*10,
                       shrinkage = 0.1,
                       n.minobsinnode = 20)


# In[16]:


fit0 <- train(df0, outcomes, method = "gbm", 
              trControl = fitControl,
              tuneGrid = gbmGrid,
              metric = "ROC",
              verbose = FALSE)

smava0$gbm <- fit0

trainPred <- predict(fit0, df0)
# postResample(testPred, testClass)

conf0 <- confusionMatrix(trainPred, outcomes, positive = "Yes")
conf0

## Only 65% accurate on the whole set!

nvars <- floor(length(colnames(df0)) * 2/3)

jpeg(filename=paste("smava0", "mf", "-%03d.jpeg", sep=""), 
     width=1024, height=768)

modelImp <- varImp(fit0, scale = FALSE)
plot(modelImp, top = min(dim(modelImp$importance)[1], nvars) )

## Get a density and a ROC
## You need twoClassSummary for this

x.p <- predict(fit0, df0, type = "prob")[2]

test.df <- data.frame(true0=x.p[[ "Yes" ]], Obs=outcomes)
test.roc <- roc(Obs ~ true0, test.df)

densityplot(~test.df$true0, groups = test.df$Obs, auto.key = TRUE)

plot.roc(test.roc)

dev.off()


# In[32]:


## Write out our training data.

save(df0, outcomes, smava0, file = "smava00-fit.dat")


# In[29]:


## Make a prediction using test.

## Apply the same data pre-processing and predict.

## Don't do the order.

test0 <- data.frame(test) # just an backup to use in the interpreter.
test1 <- data.frame(test)

for(c in intersect(smava0$cs, colnames(test))) {
  test1[[c]] <- as.numeric(test1[[c]])
}


# In[ ]:


## Impute with Hmisc

#load data
data("iris")

#seed missing values ( 10% )
iris.mis <- prodNA(iris, noNA = 0.1)
summary(iris.mis)

# impute with mean value
iris.mis$imputed_age <- with(iris.mis, impute(Sepal.Length, mean))

# impute with random value
iris.mis$imputed_age2 <- with(iris.mis, impute(Sepal.Length, 'random'))

#similarly you can use min, max, median to impute missing value

#using argImpute
impute_arg <- aregImpute(~ Sepal.Length + Sepal.Width + Petal.Length + Petal.Width +Species, data = iris.mis, n.impute = 5) 


# In[30]:


test1$x2na <- 0
test1[ is.na(test1$x2), "x2na" ] <- 1
test1[ is.na(test1$x2), "x2" ] <- smava0$x2impute

test1n <- test1[, smava0$ft1]

## pre-process
df0 <- predict(smava0$pp, test1n)

testPred <- predict(smava0$gbm, df0)

predictions <- data.frame(test)
predictions$predictionAccepted <- testPred

save(predictions, file="predictions.rdata")


# In[31]:


head(predictions)


# ## More transformations
# 
# spatialSign

# In[7]:


spatialSign(rnorm(5))

spatialSign(matrix(rnorm(12), ncol = 3))

# should fail since the fifth column is a factor
try(spatialSign(iris), silent = TRUE)

trellis.par.set(caretTheme())

featurePlot(iris[,-5], iris[,5], "pairs")
featurePlot(spatialSign(scale(iris[,-5])), iris[,5], "pairs")


# In[ ]:




