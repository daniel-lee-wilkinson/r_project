# Cleaning the dataset sales

library(janitor)
library(tidyverse)
library(forcats)
# normalise all the heading names
# strip out $ and commas from amount
# convert county and product to factors


sales <- sales %>%
  clean_names() %>%
  mutate(
    amount  = round(as.numeric(str_remove_all(amount, "[\\$,]")),2), # strip out $ and commas
    country = fct_inorder(country), #make country a factor
    product = fct_inorder(product) # make product a factor
  )


