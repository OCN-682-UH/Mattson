####My name is Nick. This is the first script I am writing for OCN682.###
###Created by Nick Mattson###
###Script created on 9-7-2026###
##########################################################

###Load libraries###
library(here)
library(tidyverse)

###Read in my data###

WeightData <- read.csv(here("Week_02","Data","weightdata.csv"))

###Data analysis###

head(WeightData)
tail(WeightData)
View(WeightData)
