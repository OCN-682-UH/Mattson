###Week 5 Practice Script for Advanced Plotting###
###Created by Nick Mattson###
###Created on 9-29-26###
##################################################################

###Load Libraries###
library(here)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggrepel)
library(patchwork) 
library(palmerpenguins)
library(gganimate)
library(gifski)
library(plotly)
library(magick)

###data frame###

p1 <- penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point()+
  transition_states(
    year,
    transition_length = 2,
    state_length = 1
  )+
  ease_aes("sine-in-out") +
  labs(title = 'Year: {closest_state}') 
anim_save(here("Week_05", "Outputs", "penguin_animation.gif"), animation = p1)

p1

p2 <- penguins |>
  ggplot(aes(x = sex, 
             y = body_mass_g, 
             color = species)) +
  geom_jitter(width = 0.2)

p2

p1/p2+
  (plot_layout(guides='collect'))+
  plot_annotation(tag_levels = 'A')

###Cars data###

head(mtcars)

ggplot(mtcars, aes(x = wt, 
                   y = mpg, 
                   label = rownames(mtcars))) +
  geom_text_repel() +
  geom_point(color = 'red')

ggplot(mtcars, aes(x = wt, 
                   y = mpg, 
                   label = rownames(mtcars))) +
  geom_label_repel() +
  geom_point(color = 'red')

###Plotly###

penguins |>
  plot_ly(x = ~body_mass_g,
          y = ~bill_depth_mm,
          color = ~species,
          type = "scatter",
          mode = "markers") |>
  layout(title = "Penguin Body Mass vs Bill Depth",
         xaxis = list(title = "Body Mass (g)"),
         yaxis = list(title = "Bill Depth (mm)"))

###Magick###
penguin <- image_read("https://pngimg.com/uploads/penguin/pinguin_PNG9.png")
penguin_scaled <- image_scale(penguin,"200")

penguin_scaled

#make the plot
penguinplot<-penguins |>
  ggplot(aes(x = body_mass_g, 
             y = bill_depth_mm, 
             color = species)) +
  geom_point() 
ggsave(here("Week_05", "Outputs", "penguinplot.png"))
penguinplot

#add the animation
penplot <- image_read(here("Week_05", "Outputs", "penguinplot.png"))
out <- image_composite(image = penplot, composite_image = penguin_scaled,gravity = "center")
out
image_write(out,here("Week_05","Outputs","Magick_practice.png"))
