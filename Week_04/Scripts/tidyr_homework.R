###Homework script for tidyr###
###Created by Nick Mattson###
###Script created on 9-22-26###
################################################

###Load Libraries###
library(here)
library(tidyverse)
library(ggplot2)
library(ggridges)

###Load in the data###
Maunalua_Chemdata <- read.csv(here("Week_04","Data","chemicaldata_maunalua.csv"))
head(Maunalua_Chemdata) #quick check at data structure

###Step 1: Clean data using tidyr###
Maunalua_Chemdata_Cleaned_Table <- Maunalua_Chemdata |>
  drop_na() |> #dropping NA values
  separate_wider_delim(cols = Tide_time,
                       delim = "_",
                       names = c("Tide","Time")) |> #separating time and tide
  filter(Tide=="High",Season=="SPRING") |> #Lets only look at high tides in the spring
  pivot_longer(cols = Temp_in:percent_sgd,
               names_to = "Test_Variables",
               values_to = "Values") #convert to long data format for variables measured

###Step 2: Look at some summary statistics###
ChemData_Summary_Table <- Maunalua_Chemdata_Cleaned_Table |>
  group_by(Test_Variables,Site,Zone) |> #grouping variables
  summarise(Mean=mean(Values),
            Median=median(Values)) |> #summary stats
  write_csv(here("Week_04","Data","Chemdata_Summary_Table.csv")) #exported csv file

Maunalua_Chemdata_Cleaned_Table_Wide <- Maunalua_Chemdata_Cleaned_Table |>
  pivot_wider(names_from = "Test_Variables",
              values_from = "Values") #re-pivot data for easier plotting

###Step 3: Creating a visual from cleaned data###
#Making a ridge plot comparing salinity values
ggplot(Maunalua_Chemdata_Cleaned_Table_Wide, aes(x = Salinity, y = Zone)) +
  geom_density_ridges(scale=0.8,
                      fill="lightblue",
                      alpha = 0.5) +
  theme_ridges() + 
  theme(legend.position = "none")+
  labs(title="Distribution of Spring High Tide Salinity Readings",
       subtitle="Grouped by Submarine Groundwater Zone", 
       x = "Salinity (Parts Per Thousand)",
       y = "Groundwater Zone",
       caption = "Data from Silbiger et al. 2020")+
  theme(axis.title = element_text(size = 12),
        plot.title = element_text(size=14, face = "bold"),
        plot.subtitle = element_text(size =10, face="bold"),
        plot.caption = element_text(size=7,face = "italic"))

###Step 4: Export plot as image file###
ggsave(here("Week_04","Outputs","Maunalua_ChemData_Ridgeplot.png"))

