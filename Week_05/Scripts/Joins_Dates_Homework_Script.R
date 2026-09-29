###This is my Joins and Dates Homework Script###
###Created by Nick Mattson###
###Created on 9-28-2026###
#######################################################

###Load Libraries###
library(here)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(patchwork) 

###Load in the Data###
CondData <- read_csv(here("Week_05", "Data", "CondData.csv")) #conditions data
DepthData <- read_csv(here("Week_05","Data","DepthData.csv")) #depth data

#quick check of data structures
head(CondData)
head(DepthData)

###Joins and Dates Manipulation###
#conditions data manipulation
CondData_Processed <- CondData |>
  mutate(datetime = mdy_hms(date),
  round_date(datetime,"10 seconds")) |> #standardize datetimes and round to nearest 10 seconds
  select(-c(date,datetime)) |> #drop the columns I don't need anymore
  rename(datetime=`round_date(datetime, "10 seconds")`) #get rid of that horrible original column name
  
#depth data manipulation
DepthData_Processed <- DepthData |>
 mutate(datetime = ymd_hms(date)) |>
  select(-(date)) #convert datetime values

#combining dataframes with inner join and exporting result
CondDepthData <- inner_join(CondData_Processed,DepthData_Processed,by="datetime") |>
  mutate(round_date(datetime,"minute")) |> #round datetime values to nearest minute for data analysis
  select(-(datetime)) |> #drop the old datetime column calculated to nearest 10 seconds
  rename(datetime_minute=`round_date(datetime, "minute")`) #give the new datetime column a less unwieldly name

###Summary Statistics###
CondDepthData_Means <- CondDepthData |>
  pivot_longer(cols = c(Temperature,Salinity,AbsPressure,Depth),
               names_to = "Measurements",
               values_to = "Values") |>
                group_by(Measurements) |> 
                mutate(percentile = percent_rank(Values)) |> #calculate percentile values for all measurements
                filter(percentile >= 0.025 & percentile <= 0.975) |> #initial plot had large outliers. This takes out top/bottom 2.5%
              group_by(Measurements,datetime_minute) |> 
               summarise(Param_means =mean(Values,na.rm=TRUE)) |> #summary stats table of mean values per minute
               pivot_wider(names_from = Measurements,
                          values_from = Param_means) #re-pivot wider so I can read it better

###Export csvs###
write.csv(CondDepthData,here("Week_05","Outputs","CondDepthData.csv")) #export joined dataframe as a csv

write.csv(CondDepthData_Means,here("Week_05","Outputs","CondDepthData_Means.csv")) #export dataframe calculating averages for each minute

###Making a plot from the averages data###
p1 <- ggplot(CondDepthData_Means, aes(x=datetime_minute, y=AbsPressure)) +
  geom_line(color="black", linewidth = 0.9) +
  ggtitle("Absolute Pressure") +
  theme_classic() +
  labs(x="Time of Day",
       y="Pressure (mPa)")+
  theme(axis.title = element_text(size = 10))

p2 <- ggplot(CondDepthData_Means, aes(x=datetime_minute, y=Temperature)) +
  geom_line(color="orange", linewidth = 0.9) +
  ggtitle("Temperature") +
  theme_classic()+
  labs(x="Time of Day",
       y="Temperature")+
  theme(axis.title = element_text(size = 10))

p3 <- ggplot(CondDepthData_Means, aes(x=datetime_minute, y=Salinity)) +
  geom_line(color="skyblue", linewidth = 0.9) +
  ggtitle("Salinity") +
  theme_classic()+
  labs(x="Time of Day",
       y="Salinity (PPT)")+
  theme(axis.title = element_text(size = 10))
  
p4 <-  ggplot(CondDepthData_Means, aes(x=datetime_minute, y=Depth)) +
  geom_line(color="limegreen", linewidth = 0.9) +
  ggtitle("Depth") +
  theme_classic()+
  labs(x="Time of Day",
       y="Depth (m)")+
  theme(axis.title = element_text(size = 10))
  
Combined_Plot <- (p1+p2+p3+p4)+ #use patchwork package to stitch plots
            plot_annotation(title="Environmental Variables Measured Across Day", 
            subtitle = "Top/Bottom 2.5% of Outlier Values Removed",
            caption = "Data from Becker et al. 2020") 
             
ggsave(here("Week_05","Outputs","Environmental_Variables_Across_Day.png")) #save final plot as image file
              


         
       