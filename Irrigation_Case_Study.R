# Irrigation Case Study
#________________work on irrigation case study________________# 

library(tidyverse)

irrigation <- read.csv("Practice_DataSets/Practice_irrigation_wide.csv")

View(irrigation)

# Q: in 2007 what is the totla area under irrigation 
# for only Americans
irrigation %>% 
  filter(year == 2007)  %>%
  select(ends_with('erica'))


irrigation %>% 
  filter(year == 2007)  %>%
  select('N..America','S..America')
# same output but diffrent method 

irrigation %>%
  filter(year == 2007)  %>%
  select(c(4,5))  %>%
  sum() # sum for value in 'N..America','S..America'

## To answer the Qs bwlow we need to first clean data :- ##

irrigation_t <- irrigation %>%
  pivot_longer(-year,names_to="region")

irrigation_t

# Q: what is the total area under irrigation in each yaer?
irrigation_t %>%
  group_by(year) %>% 
  summarise(total = sum(value))


# Q :Which 2 region increase most from 1980 to 2007 ?

irrigation_t %>% 
  group_by(region) %>% 
  summarise(diff = value[year == 2007] - value[year == 1980])

# arrange () recodrds from low to high ("ascending") & with - its oppsite high to low("descending)

# now lets orgnize result in ("descending ")
irrigation_t %>% 
  group_by(region) %>% 
  summarise(diff = value[year == 2007] - value[year == 1980]) %>% 
  arrange(-diff) %>% #diff only ("ascending")
  #slice(1) # to have most increase region {Europe   7.5}
  slice(1:2) # have 2 most regions {1 Europe  7.5 2 S..America 4.6}
# slice take specific row numbers

### ANOTHER SOLUTION FUN top_n() :- 
irrigation_t %>% 
  group_by(region) %>% 
  summarise(diff = value[year == 2007] - value[year == 1980]) %>%
  #top_n()
  slice_max(diff,n=2) #same output as above 1 Europe 7.5 2 S..America 4.6


# Q: what is the rate of change in each region ?(mybe tricky)
xx <- c(1,1.2,1.6,1.1)
xx
# there are the absolute differncess :
c(0,diff(xx))
(1.2-1)/1
(1.6-1.2)/1.2
(1.1-1.6)/1.6

diff(xx)/xx[-length(xx)] #solution (take simplest mathmatic way this is better)
#we can combine it like this 
c(0,diff(xx)/xx[-length(xx)])

# the function can be like this
# How about the proportional ?
irrigation_t <- irrigation_t %>% # to update with rate column
  arrange(region) %>%
  group_by(region) %>%
  mutate(rate = c(0,diff(value)/value[-length(value)])) 

# Q: where is the lowest and highest?
irrigation_t[which.max(irrigation_t$rate),] # must have rate column in our dataset irrigation_t
irrigation_t[which.min(irrigation_t$rate),] 

irrigation_t %>% 
  slice_max(rate,n=1) # this dont work we need to ungroup

#this will give the max rate for EACH region
irrigation_t %>%
  ungroup()%>%  #bcz: its groped if no then no need to do this
  slice_max(rate, n=1) # 0.346 (because the tibble is STILL a group data frame so to get the global Answer: ungroup())

# lowest how we can do it by the tidy way? 
##same but slice_min()
irrigation_t %>%
  ungroup()%>%  
  slice_min(rate, n=1) #-0.0150

# Q: Standardize against 1980(relative change over 1980)(easier)
irrigation_t %>% 
  group_by(region) %>% 
  summarise(Standardize_1980 = value[year==2007]/value[year==1980])

# Q: Plot area over time for each region ?
irrigation_t %>%
  ggplot(aes(x=region, y=year)) + geom_jitter()


