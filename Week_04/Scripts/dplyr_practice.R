###This is a practice script for 9-15-26 class###
###Created by Nick Mattson###
###Script created on 9-15-26###
###################################################

###Load Libraries###
library(palmerpenguins)
library(tidyverse)
library(here)

###Load Data###
glimpse(penguins)
head(penguins)

###Filtering data###

#Only 2008 penguins
filtered_penguins <- filter(penguins,year == "2008")
head(filtered_penguins)

#penguins over 5kg
big_penguins <- filter(penguins,body_mass_g > "5000")
head(big_penguins)

#2008 and 2009 penguins
both_2008_09_penguins <- filter(penguins,year == "2008"|year == "2009")
#from da front!
head(both_2008_09_penguins)
#from da back!
tail(both_2008_09_penguins)
#the whole shabang
data.frame(both_2008_09_penguins)

#No Dream penguins
penguins_dont_dream <- filter(penguins,island != "Dream")

#Adelie and Gentoo
adelie_gentoo_penguins <- filter(penguins,species == "Gentoo"|species == "Adelie")

###mutation###
Body_mass_plus_flip_length <- mutate(penguins,combined_output = body_mass_g+flipper_length_mm)

big_small_penguins_classification <- mutate(penguins,classification = ifelse(body_mass_g > 4000,"big","small"))
