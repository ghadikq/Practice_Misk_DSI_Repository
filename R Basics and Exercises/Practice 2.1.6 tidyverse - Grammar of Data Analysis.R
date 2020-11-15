# 2.1.6 tidyverse - Grammar of Data Analysis
# Misk Academy Data Science Immersive, 2020
# DAY 1&2

# Using the tidy PlayData dataframe, try to compute an aggregation function 
# according to the three scenarios, e.g. the mean of the value.
#in consol : glimpse(irrigation) to see data in consol 

# Scenario 1: Aggregation (mean) across height & width
PlayData_t %>% 
  group_by(time,type) %>% 
  summarise(avg = mean(value))

# Scenario 2: Aggregation (mean) across time 1 & time 2
PlayData_t %>% 
  group_by(type,key) %>% 
  summarise(avg = mean(value))

# Scenario 3: Aggregation across type A & type B
# Ratio of A/B for each time & key
PlayData_t %>% 
  group_by(key,time) %>% 
  summarise(type_ratio = value[type=="A"]/value[type=="B"])







