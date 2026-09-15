###This is the script for the ggplot 1 assignment###
###Created by Nick Mattson###
###Script created on 9-14-2026###
########################################################

###Load Libraries###
library(palmerpenguins)
library(tidyverse)
glimpse(penguins)

###Data Structure###
head(penguins)

###ggplot visual###
ggplot(data=penguins,
       mapping = aes(x = body_mass_g,
                     fill = species))+
  geom_histogram(bins = 30, alpha = 0.4, position = "dodge")+
  theme_classic()+
  labs(title = "Penguin Abundance by Species and Body Mass",
       subtitle = "Comparison of Adelie, Gentoo, and Chinstrap Penguins",
       x = "Body Mass (grams)", y = "Number of Penguins",
       fill = "Species",
       caption = "Palmer Station LTER/ palmerpenguins package")+
  scale_fill_viridis_d()

###save plot as image file###
ggsave("Penguins_Histogram.png")


