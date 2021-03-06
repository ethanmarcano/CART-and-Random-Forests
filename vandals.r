
library(formatR)
knitr::opts_chunk$set(tidy.opts=list(width.cutoff=60), tidy=TRUE, echo = TRUE)
library(tidyverse)
library(rpart)
library(rpart.plot)
library(randomForest)
library(caTools)

vandals <- read_csv("Wikipedia.csv")

vandal_count <-vandals %>%
  select(everything()) %>%
  filter(Vandal == 1)
count(vandal_count)

mean(vandals$NumWordsAdded)
mean(vandals$NumWordsRemoved)

pairs(vandals)
cor(vandals)




set.seed(100)
spl = sample.split(vandals$Vandal, SplitRatio = 0.7)
vandalstrain = subset(vandals, spl==TRUE)
vandalstest = subset(vandals, spl==FALSE)

nrow(vandalstrain)/nrow(vandals)
nrow(vandalstest)/nrow(vandals)

### Question B)

simple_vandal <- table(vandalstest$Vandal)
simple_vandal
simple_vandal[2]/sum(simple_vandal)



### Question C)


set.seed(100)
spl <- sample.split(vandalstrain$Vandal, SplitRatio = 0.5)
vandals_validate_train <- subset(vandalstrain, spl == TRUE)
vandals_validate_test <- subset(vandalstrain, spl == FALSE)

vandal_CART1 <- rpart(Vandal ~ Minor + LoggedIn + HTTP + NumWordsAdded + NumWordsRemoved, method = "class", data = vandals_validate_train, minbucket = 5)
vandal_CART2 <- rpart(Vandal ~ Minor + LoggedIn + HTTP + NumWordsAdded + NumWordsRemoved, method = "class", data = vandals_validate_train, minbucket = 15)
vandal_CART3 <- rpart(Vandal ~ Minor + LoggedIn + HTTP + NumWordsAdded + NumWordsRemoved, method = "class", data = vandals_validate_train, minbucket = 25)

vandal_predict1 <- predict(vandal_CART1, newdata = vandals_validate_test, type = "class")
vandal_predict2 <- predict(vandal_CART2, newdata = vandals_validate_test, type = "class")
vandal_predict3 <- predict(vandal_CART3, newdata = vandals_validate_test, type = "class")

vandal_predict_table1 <- table(vandals_validate_test$Vandal, vandal_predict1)
vandal_predict_table2 <- table(vandals_validate_test$Vandal, vandal_predict2)
vandal_predict_table3 <- table(vandals_validate_test$Vandal, vandal_predict3)

vandal_predict_table1
sum(diag(vandal_predict_table1))/sum(vandal_predict_table1)

vandal_predict_table2
sum(diag(vandal_predict_table2))/sum(vandal_predict_table2)

vandal_predict_table3
sum(diag(vandal_predict_table3))/sum(vandal_predict_table3)
```


vandal_CART <- rpart(Vandal ~ Minor + LoggedIn + HTTP + NumWordsAdded + NumWordsRemoved, method = "class", data = vandalstrain, minbucket = 25)
summary(vandal_CART)
prp(vandal_CART)


#### ii)

vandal_CART_predict <- predict(vandal_CART, newdata = vandalstest, type = "class")
vandal_predict_CART_final <- table(vandalstest$Vandal, vandal_CART_predict)

vandal_predict_CART_final
sum(diag(vandal_predict_CART_final))/sum(vandal_predict_CART_final)

### Question D)


vandalstrain$Vandal <- as.factor(vandalstrain$Vandal)
vandalstest$Vandal <- as.factor(vandalstest$Vandal)

vandals_forest <- randomForest(Vandal ~ Minor + LoggedIn + HTTP + NumWordsAdded + NumWordsRemoved, data = vandalstrain, ntree = 200, nodesize = 15)
vandals_predict_forest <- predict(vandals_forest, newdata = vandalstest)
vandals_predict_final <- table(vandalstest$Vandal, vandals_predict_forest)

vandals_predict_final
sum(diag(vandals_predict_final))/sum(vandals_predict_final)

