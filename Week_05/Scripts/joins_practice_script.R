###Practice scripts for joining###
#######################################################

###Load Libraries###
library(here)
library(tidyverse)
library(lubridate)

###Making a tibble###
T1 <- tibble(
  Site.ID = c("A","B","C","D"),
  Temperature = c(14.1,16.7,15.3,12.8)
)

T1

T4 <- tibble(
  Site.ID = c("A", "A", "B", "B"),
  Year = c(2020, 2021, 2020, 2021),
  Biomass = c(12.5, 15.3, 18.2, 16.9)
)

T5 <- tibble(
  SiteID = c("A", "A", "B"),
  Year = c(2020, 2021, 2021),
  Nutrients = c(8.2, 7.9, 9.1))

joined_table <- left_join(T4,T5,by=c("Site.ID" = "SiteID","Year" = "Year"))

mdy("02/24/2021")

datetimes <- c(
  "02/24/2021 22:22:20",
  "02/25/2021 11:21:10",
  "02/26/2021 8:01:52"
)

datetimes
datetimes <- mdy_hms(datetimes)

datetimes

month(datetimes, label = TRUE)

CondData <- read_csv(here("Week_05", "Data", "CondData.csv")) |>
  mutate(datetime = mdy_hms(date))

CondData

DepthData <- read_csv(here("Week_05","Data","DepthData.csv")) |>
  mutate(datetime = ymd_hms(date))

head(DepthData)
head(CondData)

joined_table <- full_join()