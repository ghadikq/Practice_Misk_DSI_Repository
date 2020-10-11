# Chicken Weights Analysis 
library(tidyverse)
library(DT)

# Descriptive Statistics
chickTable <- chickwts %>% 
  group_by(feed) %>% 
  summarise(n = length(feed),
            average = mean(weight),
            SD = sd(weight))
datatable(chickTable)

# Box Plot 
chickwts %>%
  ggplot(aes(x=feed , y=weight)) + geom_boxplot()


# Jitter Plot
chickwts %>%
  ggplot(aes(x=feed , y=weight)) + geom_jitter()+
  stat_summary(fun.data = mean_sdl,
               fun.args = list(mult =1),
               col = "orange")
  

# Inferential Statistics

## The one-way ANOVA summary

install.packages("data.table")

res.aov <- aov(weight ~ feed, data = chickwts)
summary(res.aov)

chickwts.av <- aov(weight ~ feed, data = chickwts)
tukeyTest <- TukeyHSD(chickwts.av)
datatable(tukeyTest$feed)

# Tukey’s Test (another way 1st attempt)

#tukey.test <- TukeyHSD(res.aov)
#tukey.test

#typeof(tukeyTest)
#class(tukeyTest)
#names(tukeyTest)

#chickwts.av <- aov(chickTable)
#res.aov <-aov(Chickwts)


res.aov <- aov(weight ~ feed, data = chickwts)
ANOVATable <- summary(res.aov)

# create table for ANOVA 'list' '.aov, .av' using pander pakage
install.packages("pander")
library(pander)
pander(ANOVATable, style='rmarkdown') # without style its normal table --
