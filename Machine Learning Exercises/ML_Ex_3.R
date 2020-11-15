---
title: "ML_Ex_3"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
# ML Exercises part 3 - Feature & Target Engineering 

```{r}
library(dplyr)
library(ggplot2)
library(rsample)
library(recipes)
library(caret)

# ames data
ames <- AmesHousing::make_ames()
# split data
set.seed(123)
split <- initial_split(ames, strata = "Sale_Price")
ames_train <- training(split)
ames_test <- testing(split)
```

```{r}
sum(is.na(AmesHousing::ames_raw))
```

```{r}
AmesHousing::ames_raw %>%
  is.na() %>%
  reshape2::melt() %>%
  ggplot(aes(Var2, Var1, fill=value)) + 
    geom_raster() + 
    coord_flip() +
    scale_y_continuous(NULL, expand = c(0, 0)) +
    scale_fill_grey(name = "", labels = c("Present", "Missing")) +
    xlab("Observation") +
    theme(axis.text.y  = element_text(size = 4))
```

```{r}
visdat::vis_miss(AmesHousing::ames_raw, cluster = TRUE)
```


```{r}
AmesHousing::ames_raw %>% 
  filter(is.na(`Garage Type`)) %>% 
  select(`Garage Type`, `Garage Cars`, `Garage Area`)
```



```{r}
caret::nearZeroVar(ames_train, saveMetrics= TRUE) %>% 
  rownames_to_column() %>% 
  filter(nzv)
```



```{r}
ames_train %>% select(matches("Qual|QC|Qu"))
```


```{r}
count(ames_train, Overall_Qual)
```

```{r}
recipe(Sale_Price ~ ., data = ames_train) %>%
  step_integer(Overall_Qual) %>%
  prep(ames_train) %>%
  bake(ames_train) %>%
  count(Overall_Qual)
```



```{r}
blueprint <- recipe(Sale_Price ~ ., data = ames_train) %>%
  step_nzv(all_nominal()) %>%
  step_center(all_numeric(), -all_outcomes()) %>%
  step_scale(all_numeric(), -all_outcomes()) %>%
  step_integer(matches("Qual|Cond|QC|Qu"))
blueprint
```

```{r}
prepare <- prep(blueprint, training = ames_train)
prepare
```

```{r}
baked_train <- bake(prepare, new_data = ames_train)
baked_test <- bake(prepare, new_data = ames_test)
baked_train
```

###Putting the process together

```{r}
# 1. stratified sampling with the rsample package
set.seed(123)
split  <- initial_split(ames, prop = 0.7, strata = "Sale_Price")
ames_train  <- training(split)
ames_test   <- testing(split)

# 2. Feature engineering
blueprint <- recipe(Sale_Price ~ ., data = ames_train) %>%
  step_nzv(all_nominal()) %>%
  step_integer(matches("Qual|Cond|QC|Qu")) %>%
  step_center(all_numeric(), -all_outcomes()) %>%
  step_scale(all_numeric(), -all_outcomes()) %>%
  step_dummy(all_nominal(), -all_outcomes(), one_hot = TRUE)

# 3. create a resampling method
cv <- trainControl(
  method = "repeatedcv", 
  number = 10, 
  repeats = 5
  )

# 4. create a hyperparameter grid search
hyper_grid <- expand.grid(k = seq(2, 25, by = 1))

# 5. execute grid search with knn model
#    use RMSE as preferred metric
knn_fit <- train(
  blueprint, 
  data = ames_train, 
  method = "knn", 
  trControl = cv, 
  tuneGrid = hyper_grid,
  metric = "RMSE"
  )

# 6. evaluate results
# print model results
knn_fit

## RMSE was used to select the optimal model using the smallest value.
## The final value used for the model was k = 12.
# plot cross validation results
ggplot(knn_fit$results, aes(k, RMSE)) + 
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = scales::dollar)
```


Exercises
Using the Ames dataset and the same approach shown in the last section:

Rather than use a 70% stratified training split, try an 80% unstratified training split. How does your cross-validated results compare?

```{r}
# 1. stratified sampling with the rsample package
set.seed(123)
split  <- initial_split(ames, prop = 0.8, strata = "Sale_Price")
ames_train  <- training(split)
ames_test   <- testing(split)
```

Rather than numerically encode the quality and condition features (i.e. step_integer(matches("Qual|Cond|QC|Qu"))), one-hot encode these features. What is the difference in the number of features your training set? Apply the same cross-validated KNN model to this new feature set. How does the performance change? How does the training time change?
```{r}
# 2. Feature engineering
blueprint <- recipe(Sale_Price ~ ., data = ames_train) %>%
  step_nzv(all_nominal()) %>%
  step_integer(matches("Qual|Cond|QC|Qu")) %>%
  step_center(all_numeric(), -all_outcomes()) %>%
  step_scale(all_numeric(), -all_outcomes()) %>%
  step_dummy(all_nominal(), -all_outcomes(), one_hot = TRUE)
```





Identify three new step_xxx functions that recipes provides:
Why would these feature engineering steps be applicable to the Ames data?
Apply these feature engineering steps along with the same cross-validated KNN model. How do your results change?
Using the Attrition data set, assess the characterstics of the target and features.
Which target/feature engineering steps should be applied?
Create a feature engineering blueprint and apply a KNN grid search. What is the performance of your model?
Python challenge: Repeat the above exercises but using Python and Scikit Learn. Reference the Python modeling process notebook to implement the proper workflow but expand upon the feature engineering steps to implement feature engineering steps such as scaling, centering, numerically encoding categorical features, etc.












