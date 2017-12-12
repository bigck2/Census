library(tidycensus)
library(tigris)
library(tmap)

# From tigris
tx <- counties(state = "TX", cb = TRUE, resolution = "20m")

# From tidycensus
rent <- get_acs(year = 2016, 
                geography = "county", 
                variables = "B25031_001", 
                state = "TX")

# From tigris
my_dat <- geo_join(tx, rent, by = "GEOID")



tm_shape(my_dat) +
  tm_polygons("estimate")


tmap_mode("view")



tm_shape(my_dat) +
  tm_polygons("estimate")










