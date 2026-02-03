library(tidyverse)
library(DBI)
library(car)
library(data.table)
library(sp)

library(readr)
sales <- read_csv("data/sales.csv", col_types = cols(Date = col_date(format = "%d/%m/%Y"),Amount = col_character()))
View(sales)
