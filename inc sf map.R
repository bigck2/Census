
inc <- get_acs(geography = "state", 
              variables = my_vec, 
              survey = "acs1", 
              year = 2016, geometry = TRUE)

bad <- c("Alaska", "Hawaii", "Puerto Rico")

inc <- inc %>% filter(!NAME %in% bad )

library(tmap)
library(sf)

tm_shape(inc) +
      tm_polygons(border.col = "green", col = "estimate", )
        

tmap_leaflet(p)

