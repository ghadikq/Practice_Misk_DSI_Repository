#Ex_Multivariate_adaptive_regression_splines
# Helper packages
library(dplyr)     # for data wrangling
library(ggplot2)   # for awesome plotting
library(tidyverse) # general data munging

# Modeling packages
library(earth)     # for fitting MARS models
library(caret)     # for automating the tuning process
library(rsample)  # for sampling

# Model interpretability packages
library(vip)       # for variable importance
library(pdp)

library(tidyverse) # general data munging

data(Hitters, package = "ISLR")
head(Hitters)
Hitters <- drop_na(Hitters)

# split data
set.seed(123)
split <- initial_split(Hitters, strata = "Salary")
Hitters_train <- training(split)

# Implementation for MARS
# tuning grid
hyper_grid <- expand.grid(
  nprune = seq(2, 50, length.out = 10) %>% floor(),
  degree = 1:3
)

# perform resampling
set.seed(123)
cv_mars <- train(
  Salary ~ ., 
  data = Hitters_train, 
  trControl = trainControl(method = "cv", number = 10),
  method = "earth", #<<
  tuneGrid = hyper_grid,
  metric = "RMSE"
)

# best model
cv_mars$results %>%
  filter(
    nprune == cv_mars$bestTune$nprune,
    degree == cv_mars$bestTune$degree
  )
# plot MARS results
plot(cv_mars)

# auto features selections 
p1 <- vip(cv_mars, num_features = 40, geom = "point", value = "gcv") + ggtitle("GCV")
p2 <- vip(cv_mars, num_features = 40, geom = "point", value = "rss") + ggtitle("RSS")
gridExtra::grid.arrange(p1, p2, ncol = 2)


