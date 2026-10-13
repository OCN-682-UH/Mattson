###Maps Class Practice###
###Created by Nick Mattson###
###Created on 10-6-2026###

#Load Libraries
library(tidyverse)
library(here)
library(ggplot2)
library(maps)
library(mapdata)
library(mapproj)

popdata <- read.csv(here("Week_07","Data","CAPopdata.csv"))
stars <- read_csv(here("Week_07", "Data", "stars.csv"))

head(popdata)

#test projection of the world
world <- map_data("world")

head(world)

usa <- map_data("usa")

head(usa)

ggplot() +
  geom_polygon(data = world,
               aes(x = long, y = lat,
                   group = group))

#California map

#map object
states <- map_data("state")
counties <- map_data("county")

#filter california
CA_data <- states |>
  filter(region == "california")

#base map
ggplot() +
  geom_polygon(data = CA_data,
               aes(x = long, y = lat,
                   group = group),
               color = "black") +
  coord_map() +
  theme_void()

#county map
CApop_county <- popdata |>
  select("subregion" = County, Population) |>   
  inner_join(counties) |>
  filter(region == "california")

ggplot() +
  geom_polygon(data = CApop_county,
               aes(x = long, y = lat,
                   group = group,
                   fill = Population),
               color = "black") +
  geom_point(data = stars,
             aes(x = long,
                 y = lat,
                 size = star_no))+
  coord_map() +
  theme_void()+
  scale_fill_gradient(transform = "log10")+
  labs(size = "# stars/m²")

#ggsave map
ggsave(here("Week_07", "Outputs", "CApop.pdf"))

