# Helper packages
library(recipes)   # for feature engineering
library(tidyverse) # general data munging
# Modeling packages
library(glmnet)   # for implementing regularized regression
library(caret)    # for automating the tuning process
library(rsample)  # for sampling
# Model interpretability packages
library(vip)      # for variable importance


data(Hitters, package = "ISLR")
head(Hitters)
Hitters

Hitters <- drop_na(Hitters)

# split data
set.seed(123)
split <- initial_split(Hitters, strata = "Salary")
Hitters_train <- training(split)

# Create training  feature matrices
# we use model.matrix(...)[, -1] to discard the intercept
X <- model.matrix(Salary ~ ., Hitters_train)[, -1]

# transform y with log transformation
Y <- log(Hitters_train$Salary)


ridge <- glmnet(
  x = X,
  y = Y,
  alpha = 0
)

plot(ridge, xvar = "lambda")

# Lasso
lasso <- glmnet(
  x = X,
  y = Y,
  alpha = 1
)

plot(lasso, xvar = "lambda")

# Ridge CV model
  ridge <- cv.glmnet(
  x = X,
  y = Y,
  alpha = 0
)

plot(ridge)


# Lasso CV model
lasso <- cv.glmnet(
  x = X,
  y = Y,
  alpha = 1
)

plot(lasso)

###Ridge model results:________ 
  
# Ridge model - minimum MSE
min(ridge$cvm)
# Ridge model - lambda for this min MSE
ridge$lambda.min 
# Ridge model w/1-SE rule
ridge$cvm[ridge$lambda == ridge$lambda.1se]
# Ridge model w/1-SE rule -- No. of coef | 1-SE MSE
ridge$nzero[ridge$lambda == ridge$lambda.1se]

##Lasso model results:___________ 
# Lasso model - minimum MSE
min(lasso$cvm)       
# Lasso model - lambda for this min MSE
lasso$lambda.min 
# Lasso model - w/1-SE rule
lasso$cvm[lasso$lambda == lasso$lambda.1se]
# Lasso model w/1-SE rule -- No. of coef | 1-SE MSE
lasso$nzero[lasso$lambda == lasso$lambda.1se]

# Grid search
# tuning grid
hyper_grid <- expand.grid(
  alpha = seq(0, 1, by = .25),
  lambda = c(0.1, 10, 100, 1000, 10000)
)

# perform resampling
set.seed(123)
cv_glmnet <- train(
  x = X,
  y = Y,
  method = "glmnet",
  preProc = c("zv", "center", "scale"),
  trControl = trainControl(method = "cv", number = 10),
  tuneLength = 10
)

# best model
cv_glmnet$results %>%
  filter(
    alpha == cv_glmnet$bestTune$alpha,
    lambda == cv_glmnet$bestTune$lambda
  )


# plot results
plot(cv_glmnet)

# Comparing results to previous models_______
# predict sales price on training data
pred <- predict(cv_glmnet, X)

# compute RMSE of transformed predicted
RMSE(exp(pred), exp(Y))

# Feature importance_______
vip(cv_glmnet, num_features = 20, geom = "point")
