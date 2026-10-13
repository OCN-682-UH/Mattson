###Maps Class Practice###
###Created by Nick Mattson###
###Created on 10-6-2026###

#Load Libraries
library(tidyverse)
library(here)
library(maps)
library(mapdata)
library(mapproj)

popdata <- read.csv(here("Week_07","Data","CAPopdata.csv"))

head(popdata)

world <- map_data("world")

head(world)

usa <- map_data("usa")

head(usa)

ggplot() +
  geom_polygon(data = world,
               aes(x = long, y = lat,
                   group = group))
