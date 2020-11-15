---
title: "ML_Ex_2"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


```{r}
library(rsample)
library(caret)
library(tidyverse)
# ames data
ames <- AmesHousing::make_ames()
# attrition data
churn <- rsample::attrition
```


```{r}
set.seed(123) # for reproducibility
split <- initial_split(diamonds, strata = "price", prop = 0.7)
train <- training(split)
test  <- testing(split)
# Do the distributions line up? 
ggplot(train, aes(x = price)) + 
  geom_line(stat = "density", 
            trim = TRUE) + 
  geom_line(data = test, 
            stat = "density", 
            trim = TRUE, col = "red")
```


```{r}
#Ames Housing

set.seed(123)
ames_split <- initial_split(ames, prop = 0.7, strata = "Sale_Price")
ames_train <- training(ames_split)
ames_test  <- testing(ames_split)
# Do the distributions line up? 
ggplot(ames_train, aes(x = Sale_Price)) + 
  geom_line(stat = "density", 
            trim = TRUE) + 
  geom_line(data = ames_test, 
            stat = "density", 
            trim = TRUE, col = "red")

#Employee Attrition

set.seed(123)
churn_split <- initial_split(churn, prop = 0.7, strata = "Attrition")
churn_train <- training(churn_split)
churn_test  <- testing(churn_split)
# consistent response ratio between train & test
table(churn_train$Attrition) %>% prop.table()
table(churn_test$Attrition) %>% prop.table()
```


```{r}
# Variables + interactions
model_fn(Sale_Price ~ Neighborhood + Year_Sold + Neighborhood:Year_Sold, data = ames_train)
# Shorthand for all predictors
model_fn(Sale_Price ~ ., data = ames_train)
# Inline functions / transformations
model_fn(log10(Sale_Price) ~ ns(Longitude, df = 3) + ns(Latitude, df = 3), data = ames_train)

# Usually, the variables must all be numeric
features <- c("Year_Sold", "Longitude", "Latitude")
model_fn(x = ames_train[, features], y = ames_train$Sale_Price)

# specify x & y by character strings
model_fn(
  x = c("Year_Sold", "Longitude", "Latitude"),
  y = "Sale_Price",
  data = ames.h2o
  )
```
















