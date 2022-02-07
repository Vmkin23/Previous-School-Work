
getwd()
setwd("C:/Users/18033/Desktop/School Schtuff/Current Semester/Fall 2021/BAS 240")

library(ggplot2)
library(DT)
library(tidyr)
library(dplyr)
library(knitr)

library(readxl)
annual_hiv_deaths_number_all_ages <- read_excel("C:/Users/18033/Desktop/School Schtuff/Current Semester/Fall 2021/BAS 240/annual_hiv_deaths_number_all_ages.xlsx")
View(annual_hiv_deaths_number_all_ages)

head(annual_hiv_deaths_number_all_ages)

TotalDeath <- rowSums(annual_hiv_deaths_number_all_ages[,-1], na.rm = TRUE)

AnnualHIVDeath <- cbind(annual_hiv_deaths_number_all_ages, TotalDeath)

top_n(AnnualHIVDeath,10)

datatable(top_n(AnnualHIVDeath,10))

