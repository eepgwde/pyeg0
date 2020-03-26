
# ## SMAVA
# 
# Test exercise - Question 1

# In[1]:


## weaves
## smava

rm(list=ls())

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
load("smava00.dat")
load("bak/in/test.rdata")
ls()


# In[3]:


cols <- setdiff(smava0$ft0, c(smava0$hcor, "outcomes"))
cols


# In[16]:


## Rename/Preprocess
df0 <- train1[, cols]

# Null check.\
# sapply(df0, summary, USE.NAMES=TRUE)

head(df0)


# In[19]:


## simple controls

fitControl <- trainControl(
    method = "repeatedcv",
    number = 5, ## repeated a few times
    repeats = 3,
    summaryFunction = twoClassSummary,
  classProbs = TRUE)

gbmGrid <- expand.grid(interaction.depth = c(1, 3, 5, 9),
                       n.trees = (1:20)*10,
                       shrinkage = 0.1,
                       n.minobsinnode = 20)


# In[ ]:


fit0 <- train(accepted ~ ., data = df0, method = "gbm", 
              trControl = fitControl,
              tuneGrid = gbmGrid,
              metric = "ROC", # beecause it is fairly well-centred, use this not Kappa or Accuracy
              verbose = FALSE)
smava0$gbm <- fit0
fit0


# In[7]:


trainPred <- predict(fit0, df0)
# postResample(testPred, testClass)

conf0 <- confusionMatrix(trainPred, df0$accepted, positive = "YES")
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

test.df <- data.frame(true0=x.p[[ "YES" ]], Obs=outcomes)
test.roc <- roc(Obs ~ true0, test.df)

densityplot(~test.df$true0, groups = test.df$Obs, auto.key = TRUE)

plot.roc(test.roc)

dev.off()


# In[8]:


## Make a prediction using test.

## Apply the same data pre-processing and predict.

## Don't do the order.

test0 <- data.frame(test) # just an backup to use in the interpreter.
test1 <- data.frame(test)

for(c in intersect(smava0$cs, colnames(test))) {
  test1[[c]] <- as.numeric(test1[[c]])
}


# In[9]:


test1$x2na <- 0
test1[ is.na(test1$x2), "x2na" ] <- 1
test1[ is.na(test1$x2), "x2" ] <- smava0$x2impute


# In[10]:


df0 <- test1[, intersect(cols, colnames(test1))]


# In[11]:


## pre-process
if (!is.null(smava0$pp)) {
    df0 <- predict(smava0$pp, df0)
}

testPred <- predict(smava0$gbm, df0)

predictions <- data.frame(test)
predictions$predictionAccepted <- testPred

save(predictions, file="smava01.dat")


# In[12]:


head(predictions)


# In[ ]:




