# ggplot2 coding challange
# Ghadi 
# 19.10.2020

# load packages
library(ggplot2) # part of tidyverse library 
library(RColorBrewer)

library(munsell)
library(Hmisc)
library(lattice)
library(survival)
library(Formula)

# Using color:
# Hex codes - 6 alpha-numeric digits long

# Base 16 (hexadecimal) numbering system
# 16 1-digit(16^1): 0-9 & a-f(or A-F) same
# 256 2-digit(16^2): 00-ff


# Base 10 numbring systems
# 10 1-digit(10^1): 0-9
# 100 2-digit(10^2): 00-99
# 1000 3-digit(10^3): 000-999 WILL NOT USE

# Hex codes: "RRGGBB"
"#FFFFFF" # All color = Black or White ? White
"#000000" #No color = Black or White ? Black
"#af9900" #Dark gold
munsell::plot_hex("#00FF00") #show color

# in total we have :
256*256*256 # RR*GG*BB -> 16 77 216

# see all color pallet 
display.brewer.all()

display.brewer.all(type = "seq")

display.brewer.pal(9, "Blues")

brewer.pal(9, "Blues")

myBlues <- brewer.pal(9, "Blues")[c(4,6,8)]

# BELLOW 2 function have same output
plot_hex(myBlues)

munsell::plot_hex(myBlues)

# Load dataset
iris
# 1- Basic scatter plot with color
# first , save plot with color
g <- ggplot(iris, aes(x=Sepal.Length , y=Sepal.Width, color = Species)) 

# Then add various other layers

g +
  geom_point()
# Problem with using points: Overlapping :/
# here because of "low precision data"
# Solution 
g +
  geom_jitter()

g +
  geom_point(position = "jitter")

posn_j <- position_jitter(seed = 136)

g +
  geom_point(position = posn_j)

# 3 - linear model without background 
g + geom_point(position = posn_j , shape=1 ) +
  stat_smooth(method = "lm", se = FALSE) + # Linear Model
  scale_color_brewer("Iris Species", palette = "Dark2") + # change color & give it diff name 
  theme(legend.position = c(0.1,0.9)) +
  #scale_x_continuous("Sepal Length(cm)", limits = c(4,8)) +
  #scale_y_continuous("Sepal Width (cm)", limits = c(2,5)) +
  coord_cartesian(xlim = c(4,8),ylim = c(2,5),expand = 0,clip = "off")
  theme_classic()

  
## 3 img 
  
ggplot(iris, aes(x=Sepal.Length , y=Sepal.Width)) +
  geom_point(position = posn_j ,shape=16 , alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE,color ="#cb181d") +
  coord_cartesian(xlim = c(4,8) , ylim = c(2,5) , expand = 0 , clip = "off")+
  facet_grid(. ~ Species) +
  labs(title = "The iris data set again!",
       caption = "Anderson ,1931",
       x ="Sepal Length(cm)",
       y ="Sepal Wedth(cm)",
       color = "") +
  theme_classic(10) +
  theme(rect = element_blank(),
        legend.position = c(0.2,0.9),
        aspect.ratio = 1)





    
# Mammal EX:-  
msleep

msleep2 <- msleep %>% 
  select(vore, sleep_total) %>% 
  na.omit()

msleep2

# a) "Dot" plot
g2 <- ggplot(msleep2, aes(x = vore, y = sleep_total, color = vore)) +
  geom_point(position = position_jitter(width = 0.2, seed = 136), 
             shape = 16, alpha = 0.65) +
  scale_color_brewer(palette = "Dark2") +
  scale_y_continuous(limits = c(0,24),
                     breaks = seq(0, 24, 6),
                     expand = c(0,0)) +
  scale_x_discrete(labels = c("Carnivore",
                              "Herbivore",
                              "Insectivore",
                              "Omnivore")) +
  labs(title = "a) Dot Plot",
       x = "Eating Habits",
       y = "Total Sleep Time (h)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  NULL
g2

# dot plot with mean & sd
g2  + stat_summary(fun.data = mean_cl_normal)

#facet_grid(sleep_total ~ vore) +

# How about a density plot:
ggplot(msleep2, aes(sleep_total, color = vore)) +
  geom_density()

# b) "Dot" plot with mean and sd
data_summary <- function(x) {
  m <- mean(msleep2$sleep_total)
  ymin <- m-sd(msleep2$sleep_total)
  ymax <- m+sd(msleep2$sleep_total)
  return(c(y=m,ymin=ymin,ymax=ymax))
}
g2 + stat_summary(fun.data=data_summary, color="black")



# c) Just the mean and the sd
gc <- ggplot(msleep2, aes(x = vore, y = sleep_total, color = vore))
#posn_j <- position_jitter(seed = 136)

gc +
  geom_jitter(width = 0.3, alpha =  0.6, shape =1)


set.seed(136)
xx <- rnorm(100, 10, 6)
mean(xx)
sd(xx)
smean.sdl(xx, mult = 1)
mean_sdl(xx, mult = 1)

gc +
  stat_summary(fun.data = mean_sdl, 
               fun.args = list(mult = 1))




 
# d) Bar (aka "Dynamite") plot
gBar <- ggplot(msleep2, aes(factor(vore), fill = factor(sleep_total)))
gBar

gBar +
  geom_bar(position = "fill") 

# e) Box plot

# f) Violin plot


#theme(legend.position = left)
#scale_x_continuous( limits = c(4,8)) +
#scale_y_continuous(limits = c(2,5))