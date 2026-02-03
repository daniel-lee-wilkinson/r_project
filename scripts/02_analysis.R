library(ggthemes)

# Assumptions:
# 1. chocolates are sold as packets to consumers (i.e. not as wholesale pallet sizes)



# Research questions
# what is the cost per box shipped?
sales$unit_price <- sales$amount/sales$boxes_shipped

# What were the total sales per year, product and country?

sales %>%
  mutate(year = year(date)) %>%
  group_by(year, country, product) %>%
  summarise(
    total_sales = sum(amount, na.rm = TRUE),
    .groups = "drop"
  )

# What is the best selling product in each country?

best_by_country <- sales %>%
  group_by(country, product) %>%
  summarise(total_sales = sum(amount, na.rm = TRUE), .groups = "drop") %>%
  group_by(country) %>%
  slice_max(total_sales, n = 1, with_ties = TRUE) %>% # total sales per country
  ungroup() # total sales per country and product

best_by_country # the best seller is different in each country

best_by_country %>%
  ggplot(aes(x=reorder(product, total_sales), y=total_sales)) +
  geom_col() + coord_flip() + 
  labs(x = "Product",y="Total Sales (USD)")

# barplot of the products which are most often purchased (months-wise)
sales %>%
  filter(country == "Australia") %>%
  mutate(month = floor_date(date, "month")) %>%
  summarise(
    months_ordered = n_distinct(month),
    .by = product
  ) %>%
  arrange(desc(months_ordered)) %>%
  ggplot(aes(x = reorder(product, months_ordered),
             y = months_ordered)) +
  geom_col() +
  coord_flip() +
  labs(
    x = "Product",
    y = "Number of months ordered",
    title = "Australian products by months ordered"
  ) +
  theme_fivethirtyeight()

# when was the first and last order to Australia?
sales %>%
  select(country, product, date, amount, boxes_shipped) %>%
  filter(country == "Australia") %>%
  mutate(month = floor_date(date, "month"), unit_price = amount/boxes_shipped) %>%
  summarise(earliest_order = min(date),
            lastest_order = max(date),
            max_unit_price = max(unit_price),
          min_unit_price = min(unit_price))

sales %>%
  filter(country == "Australia") %>%
  mutate(unit_price = amount / boxes_shipped) %>%
  filter(unit_price == max(unit_price, na.rm = TRUE)) 
# Eclairs at 2633/box --> error in recording? More expensive than world's most expensive chocolates in the world if we assume a standard packet and not a crate-full

# since these values do not represent real relationships, it is not meaningful to analyse them in depth.

