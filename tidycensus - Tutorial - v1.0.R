
library(tidycensus)
library(tidyverse)

census_api_key("f6259ec5d271471f6656ae7c66e2f41b867e5cb1")

m90 <- get_decennial(geography = "state", variables = "H043A001", year = 1990)

head(m90)

m90 %>%
  ggplot(aes(x = value, y = reorder(NAME, value))) + 
  geom_point()



vt <- get_acs(geography = "county", variables = "B19013_001", state = "VT")

head(vt)

vt %>%
  mutate(NAME = gsub(" County, Vermont", "", NAME)) %>%
  ggplot(aes(x = estimate, y = reorder(NAME, estimate))) +
  geom_errorbarh(aes(xmin = estimate - moe, xmax = estimate + moe)) +
  geom_point(color = "red", size = 3) +
  labs(title = "Household income by county in Vermont",
       subtitle = "2011-2015 American Community Survey",
       y = "",
       x = "ACS estimate (bars represent margin of error)")




# testing -----------------------------------------------------------------

vt <- get_acs(geography = "county", variables = "HC01_EST_VC13", state = "VT")


v15 <- load_variables(2015, "acs5", cache = TRUE)

View(v15)


pop <- get_acs(geography = "county", variables = "B01001_001", state = "TX")

pop















