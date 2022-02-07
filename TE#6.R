library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(nycflights13)
library(fivethirtyeight)

library(readr)
dem_score <- read_csv("https://moderndive.com/data/dem_score.csv")
dem_score

guat_dem <- dem_score %>%
  filter(country == "Guatemala")
guat_dem

guat_dem_tidy <- guat_dem %>%
  pivot_longer(names_to = "year",
               values_to = "democracy_score",
               cols = -country,
               names_transform = list(year = as.integer))
guat_dem_tidy

ggplot(guat_dem_tidy, aes(x=year, y=democracy_score)) +
  geom_line() +
  labs(x = "Year", y = "Democracy Score")