# Practice 2.1.2 - Data handling

# Part 1: Functions

# Arithmetic operators

# type a math equation
100 + 99

# BEDMAS - order of operations
2 - 8/4 # 0
(2 - 8)/4 # -1.5

# Use objects in place of numbers
a <- 20
b <- 101

a + b #121

`+`(a, b) #121 same as above

a * b #2020

# 1 - Generic functions have a form:
# fun_name(fun_arg = ...)

# 2 - Call args by name or position

log(x=8 , base =2) #3
log(base=2 , x=8) #3
log(8,2) #3
log(8 , base=2) #3
log2(8) #3
log(base=2 , 8) #3 

# 3 - Funs can have 0 to many un-named args

library()
ls()
list.files()

# 4 - Args can be named or un-named

var <- c(1,2,3,4,5)
var

# With characters:

name <- c('Amal','Ali','Sara','Hamd','Lili','Hala')
name

# random number generators:
# reproducible

set.seed(77) #chossse any num 
runif(7) #number of elememts to print

# according to a distribution:
runif(3)
rnorm(3)

# by selecting (sample give random set of number from var)
sample(var,1) #1

sample(var,5) #1 5 3 4 2

sample(var,3) #3 2 5

# seq() for a regular sequence of numbers ----
seq(from = 0, to = 50, by = 5) #  0  5 10 15 20 25 30 35 40 45 50

# Can you write this in a shorter form?
shortFormSEQ <- seq(0, 50, 5)
shortFormSEQ #  0  5 10 15 20 25 30 35 40 45 50

# We can use objects in functions:
shortFormSEQ2 <-seq(0,b,a) #from = 0, to = 121=b, by 20=a
shortFormSEQ2 # 0  20  40  60  80 100



# The colon operator

# regular sequence of 1 interval
seq(1, 5, 1) # 1 2 3 4 5

# Use the colon operator instead:
1:5 # 1 2 3 4 5

#---Applying math functions---

# Exercise: Are these transformation or aggregation?
shortFormSEQ2 + 100 # Transformation # 100 120 140 160 180 200
shortFormSEQ2 + shortFormSEQ2 # Transformation # 0  40  80 120 160 200
sum(shortFormSEQ2) + shortFormSEQ2 # Agg, followed by trans #300 320 340 360 380 400
1:3 + shortFormSEQ2 # Transformation  #  1  22  43  61  82 103

#---FUNDAMENTAL CONCEPT: VECTOR RECYCLING---
1:4 + shortFormSEQ2 #Warning message: longer object length is not a multiple of shorter object length

# Exercise:
# Calculate y = 1.12x â 0.4 for xx
y <- 1.12*var - 0.4
y #0.72 1.84 2.96 4.08 5.20

#---Part 2: Objects (nouns)---

#---Vectors - 1-dimensional, homogenous---
shortFormSEQ #11 elements
name #4 elements

#---"user-defined atomic vector types"---

typeof(shortFormSEQ) # "double"
typeof(name) # "character"

# Let's make some more vectors for later on:
vec1 <- c("Liver", "Brain", "Testes", "Muscle","Intestine", "Heart")
typeof(vec1) # "character" 

vec2 <- c(TRUE, FALSE, FALSE, TRUE, TRUE, FALSE)
typeof(vec2) # "logical"


# Homogeneous types:
testHT <- c(1:5, "Arwa",1:2,"Ali")
testHT #"1"    "2"    "3"    "4"    "5"    "Arwa" "1"  "2"    "Ali" 
typeof(testHT) #"character"

# We can't do math:
mean(testHT) #Warning message:argument is not numeric or logical

# R has a type hierarchy

# Solution: Coercion to another type - use an as.*() function
testHT <- as.numeric(testHT)
testHT # 1  2  3  4  5 NA  1  2 NA

# Now we can do math: 
mean(testHT) #NA
# solve NA problem
mean(testHT, na.rm = TRUE) # 2.571429

#---Lists - 1-dimensional, heterogeneous---

PlantGrowth # load dataset
data(PlantGrowth) #see dataset in enviroment

plant_lm <- lm(weight ~ group, data = PlantGrowth)
plant_lm

typeof(plant_lm) #"list"

# how many elements:
length(plant_lm) #13
length(shortFormSEQ) #11 , also works for vectors

# attributes (meta data)
attributes(plant_lm) # 13 named elements

# use common "accessor" functions for attributes
names(plant_lm)


# Anything that's named can be called with $
plant_lm$coefficients # a 3-element named dbl (numeric) vector
plant_lm$residuals # a 30-element dbl vector
plant_lm$model # data.frame

# As an aside: You can even add comments:
comment(plant_lm) <- "I love R!"
attributes(plant_lm)

# Add comment as an actual list item:
plant_lm$myComment <- "But python also :)"
plant_lm$myComment


# What is class?
# An attribute to an object
attributes(plant_lm)
# can also access with "accessor" function:
class(plant_lm)
class(plant_aov)
# class tells R functions what to do with this object
# e.g.
summary(plant_lm) # get t-test and ANOVA summary from an "lm"
summary(PlantGrowth) # summarise each column in a "dataframe"


# Dataframes - 2-dimensional, heterogenous ----
class(PlantGrowth)
# A special class of type list...
typeof(PlantGrowth)
# ...where each element is a vector of the SAME length!
# Rows = observations
# Columns = variables


# Make a data frame from scratch using data.frame(), or...
# You can use the modern variant  
# Note, I put _df on the end of the name to remind us that this is a
# data frame (well, a tibble), but it's not necessary.
library(tidyverse)

df <- tibble(shortFormSEQ2, vec1, vec2)
df

# To modify the column names, what you're actually doing is
# Change an attribute (think metadata). The most common attributes
# can be accessed with accessor functions, in this case names()
names(df) <- name
df

# How can you call each variable (i.e. column) by name:
# Note it will return a vector
#df$healthy
PlantGrowth$weight 

# Basic functions:
# Display the structure of foo_df using a base R function:
str(df)

# Now using a tidyverse function:
glimpse(df)


# Can you get a short summary of every variable with one command?
summary(df)


# Can you print out the number of rows & columns?
length(df) # The number of columns, i.e. the number of elements in the list #3
dim(df) #3 6

# How about just the number of rows?
nrow(df) #6

# How about just the number of columns? 
ncol(df) #3 



