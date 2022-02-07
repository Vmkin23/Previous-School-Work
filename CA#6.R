# (LC4.4) Convert the dem_score data frame into a "tidy" data frame and assign the
# name of dem_score_tidy to the resulting long-formatted data frame.

library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(nycflights13)
library(fivethirtyeight)

library(readr)
dem_score <- read_csv("https://moderndive.com/data/dem_score.csv")
dem_score

dem_score_tidy <- dem_score %>%
  pivot_longer(names_to = "year",
               values_to = "democracy_score",
               cols = -country,
               names_transform = list(year = as.integer))
dem_score_tidy 


# (LC4.5) Read in the life expectancy data stored at 
# https://moderndive.com/data/le_mess.csv and convert it to a "tidy" data frame.

life_expect <- read_csv("https://moderndive.com/data/le_mess.csv")
life_expect

life_expect_tidy <- life_expect %>%
  pivot_longer(names_to = "Year",
               values_to = "Average Life Expectancy",
               cols = -country,
               names_transform = list(year = as.integer))
life_expect_tidy