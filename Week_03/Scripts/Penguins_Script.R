###This is the script for the ggplot 1 assignment###
###Created by Nick Mattson###
###Script created on 9-14-2026###
########################################################

###Load Libraries###
library(here)
library(palmerpenguins)
library(tidyverse)
glimpse(penguins)

###Data Structure###
head(penguins)

###ggplot visual###
ggplot(data=penguins,
       mapping = aes(x = body_mass_g,
                     fill = species))+
  geom_histogram(binwidth = 140, alpha = 0.4, position = "dodge")+
  theme_classic()+
  labs(title = "Penguin Abundance by Species and Body Mass",
       subtitle = "Comparison of Adelie, Gentoo, and Chinstrap Penguins",
       x = "Body Mass (Kg)", y = "Number of Penguins",
       fill = "Species",
       caption = "Palmer Station LTER/ palmerpenguins package")+
  scale_fill_viridis_d()+
  scale_x_continuous(breaks = c(2500,3000,3500,4000,4500,5000,5500,6000,6500),
                     labels = c("2.5","3.0","3.5","4.0","4.5","5.0","5.5","6.0","6.5"))

###save plot as image file###
ggsave(here("Week_03","Outputs","Penguins_Histogram.png"))


