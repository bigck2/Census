library(tidyverse)
library(tidycensus)
library(tigris)
library(sp)
library(stringr)

library(tmap)



census_api_key("f6259ec5d271471f6656ae7c66e2f41b867e5cb1")


my_vec <- c(value_median_value = "B25077_001")


values <- get_acs(geography = "zcta", 
                 variables = my_vec,  
                 survey = "acs5", 
                 year = 2015)

values <- values %>%
          mutate(zip = str_(NAME, 5))


zips <- zctas(cb = TRUE)

my_states <- states(cb = TRUE, resolution = "20m")


tx <- my_states[my_states$NAME == "Texas", ]


tx_zips <- over(zips, tx)

index <- !is.na(tx_zips$STATEFP)

tx_zips <- zips[index,]


test <- geo_join()


