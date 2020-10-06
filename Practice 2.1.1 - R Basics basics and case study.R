# Practice 2.1.1 - R Basics basics and case study

# Load packages 
library(tidyverse)

# Basic R syntax  
n <- log2(8)
n
# Plant Growth Case Study  

PlantGrowth

data(PlantGrowth) #show data in Enviroment 

# convert dataset to "tibble"
PlantGrowth <- as_tibble(PlantGrowth) 
PlantGrowth

# 1. Descriptive Statistics 

# The "global mean" of all the weight values
mean(PlantGrowth$weight)

# Would this on the group column?
mean(PlantGrowth$group)
# * cant do it on argument that not Numeric or Logical (here its Nominal)*

# Group-wise statistics

# Use summarise() for aggregation functions
PlantGrowth %>% 
  group_by(group) %>% 
  summarise(avg = mean(weight))


