###This is the dplyr homework script I made.###
###Created by Nick Mattson###
###Script created on 9-22-26###
##########################################################

###Load Libraries###
library(here)
library(tidyverse)
library(palmerpenguins)
library(ggplot2)

###Peek at the data###
head(penguins)

###Manipulate data with dplyr###
#Part 1: Calculate mean and variance by groups
mean_and_variance_table <- penguins |> #assign output
  group_by(island,species,sex) |> #grouping command
  summarise(mean_body_mass=mean(body_mass_g,na.rm=TRUE),
            body_mass_variance=var(body_mass_g,na.rm=TRUE)) #summary table of mass and variance

head(mean_and_variance_table) #check structure

#Part 2: Filter and mutate data for plot
penguins_altered_table <- penguins |>
  filter(sex=="female") |> #exclude males
  mutate(log_body_mass=log(body_mass_g)) |> #new column for log of body mass
  select(species,island,sex,log_body_mass) #selects only the columns I want

head(penguins_altered_table) #check structure

#Part 3: ggplot visual of edited data frame

#Let's make a box plot!
ggplot(penguins_altered_table, aes(x=island,y=log_body_mass,color=species))+
  geom_boxplot(fill="limegreen", #plot shape color
               alpha=0.2, #transparency
               position=position_dodge2(preserve="single"), #make all columns equal width
               outlier.shape=NA)+ #remove outliers from final plot
  theme_grey()+
  labs(title="Body Mass of Female Penguins by Species and Island", 
       subtitle = "Values Expressed as Log10 of Body Mass (g)",
       x = "Island",
       y = "Log10 of Body Mass (g)",
       color = "Species",
       caption = "Note: not all penguin species found on all islands")+
  
  theme(axis.title = element_text(size = 10),
        plot.title = element_text(size=16, face = "bold"),
        plot.subtitle = element_text(size=14),
        plot.caption = element_text(size=8,face = "italic"))
  
###Save plot as an image file###
ggsave(here("Week_04","Outputs","log_boxplot_edited_penguin_data.png"))
 
