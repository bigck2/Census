library(tidycensus)
library(tigris)
library(tmap)
library(tidyverse)


census_api_key("f6259ec5d271471f6656ae7c66e2f41b867e5cb1")


# From tigris
tx <- counties(state = "TX", cb = TRUE, resolution = "20m")

# From tidycensus
rent <- get_acs(year = 2015, 
                geography = "county", 
                variables = "B25031_001", 
                state = "TX", 
                survey = "acs5")

# From tigris
my_dat <- geo_join(tx, rent, by = "GEOID")



tm_shape(my_dat) +
  tm_polygons("estimate")


tmap_mode("view")



p <- tm_shape(my_dat) +
        tm_polygons("estimate")


p


# Leaflet Version ---------------------------------------------------------



library(leaflet)


leaflet(my_dat) %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(fill = ~estimate)


