###Broomsedge Data Transformations###

###############################################

#Load Libraries
library(tidyverse)
library(here)
library(ggplot2)

broomsedgedata_long <- read.csv(here("Project","Data","PlotsSummaryStats_Long.csv"))
head(broomsedgedata_long)

broomsedgedata_wide <- broomsedgedata_long |>
  pivot_wider(names_from = Cover.Percentages,
              values_from = Values)

write.csv(broomsedgedata_wide,file=here("Project","Data","PlotsSummaryStats_Wide.csv"))

#################################################
broomsedgedata_wide_revised <- read.csv(here("Project","Data","PlotsSummaryStats_Wide_Revised.csv"))
head(broomsedgedata_wide_revised)                              

broomsedgedata_long_revised <- broomsedgedata_wide_revised |>
  pivot_longer(
  cols = c(Percentage.Native.Woody, Percentage.Invasive.Grass, Percentage.Invasive.Woody, Percentage.Native.Herbaceous, Percentage.Invasive.Herbaceous, Percentage.Lichen, Percentage.Bare.Substrate, Percentage.Pukiawe, Percentage.A.ali.i, Percentage.Koa..understory., Percentage..Ohi.a..understory., Percentage.Koa..overstory., Percentage..Ohi.a..overstory., Percentage.Faya..overstory., Percentage.Canopy), # <-- Replace with your actual wide numeric column names
  names_to = "variables",
  values_to = "values"
) |>
  mutate(Burn = as.factor(Burn))
ggplot(broomsedgedata_long_revised,aes(x = Burn, y = values, fill = Burn)) + # <-- Replace with your category
  geom_boxplot() +
  # 3. Create a separate panel for each numeric metric
  facet_wrap(~ variables, scales = "free_y") + 
  theme_minimal() +
  labs(
    x = "Category",
    y = "Value",
    title = "Boxplots of Metrics by Category"
  ) +
  theme(legend.position = "none")
