###Maps Class Practice Part 2###
###Created by Nick Mattson###
###Created on 10-12-2026###

#######################################

#Load Libraries
library(tidyverse)
library(here)
library(sf)
library(maptiles)
library(tidyterra)
library(leaflet)
library(tidygeocoder)
library(ggspatial)

ChemData <- read_csv(here("Week_07", "Data", "chemicaldata_maunalua.csv"))

glimpse(ChemData)

#bounding box for Wailupe
wailupe_bbox <- st_as_sfc(
  st_bbox(c(xmin = -157.772, ymin = 21.267, xmax = -157.752, ymax = 21.281), 
    crs = 4326))

#get tiles
tiles_satellite <- get_tiles(
  wailupe_bbox,               
  provider = "Esri.WorldImagery", 
  zoom = 16,                  
  crop = TRUE,                
  cachedir = here("Week_07", "Data", "tiles_cache")        
)

#quick check
class(tiles_satellite)

#tiles plot
ggplot() +
  geom_spatraster_rgb(data = tiles_satellite) +
  coord_sf(crs = 4326) +
  theme_minimal()

################################################3
#making sure bounding box scales to my data
#convert datafram
ChemData_sf <- st_as_sf(ChemData,
                        coords = c("Long", "Lat"),
                        crs = 4326)

#fit box to my data with small buffer
bbox_chem <- st_bbox(ChemData_sf) + c(-0.004, -0.004, 0.004, 0.004)

#tiles for new bounding box
Map_satellite <- get_tiles(
  st_as_sfc(bbox_chem),
  provider = "Esri.WorldImagery",
  zoom = 15,
  crop = TRUE,
  cachedir = here("Week_07", "data", "tiles_cache")
)

#new map focused on points
ggplot() +
  geom_spatraster_rgb(data = Map_satellite) +
  geom_point(data = ChemData,
             aes(x = Long, y = Lat,
                 color = Salinity),
             size = 4) +
  scale_color_viridis_c(name = "Salinity(PPT)") +
  annotation_scale(           
    location = "bl",          
    bar_cols = c("yellow", "white")) +
  annotation_north_arrow(     
    location = "tl") +
  coord_sf(crs = 4326) +
  labs(title = "Maunalua Bay — Water Chemistry",
       caption = "Basemap: ESRI World Imagery")+
  theme_minimal()

ggsave(here("Week_07", "Outputs", "maunalua_map.pdf"), width = 8, height = 6)
  