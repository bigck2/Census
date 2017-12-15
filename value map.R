library(tidyverse)
library(tidycensus)
library(tigris)
library(sp)
library(stringr)

library(tmap)

census_api_key("f6259ec5d271471f6656ae7c66e2f41b867e5cb1")


# census variable to look up
my_vec <- c(value_median_value = "B25077_001")

# access the api to get the data 
values <- get_acs(geography = "zcta", 
                 variables = my_vec,  
                 survey = "acs5", 
                 year = 2015)

rm(my_vec)

# create a column that is clean with just the zip code
values <- values %>%
          mutate(zip = str_sub(NAME, -5))




# download shape files for ALL US zips
zips <- zctas(cb = TRUE)

# download shape files for ALL US states
my_states <- states(cb = TRUE, resolution = "20m")

# filter to just TX
tx <- my_states[my_states$NAME == "Texas", ]


# filter zips to only zips in TX
tx_zips <- over(zips, tx)

rm(tx)

index <- !is.na(tx_zips$STATEFP)

tx_zips <- zips[index,]

rm(index)


# geo_join the spatialdata to the regular data
tx_zips <- geo_join(tx_zips, values, "GEOID10", "zip")


# make a map
tm_shape(tx_zips) +
  tm_polygons(col = "estimate")


p <- tm_shape(tx_zips) +
        tm_polygons(col = "estimate")

tmap_leaflet(p)




# Better Cuts -------------------------------------------------------------


# TODO: I don't like the buckets that tmap is choosing for me

dat <- as_tibble(tx_zips@data)

dat

ggplot(dat, aes(x = estimate)) +
  geom_histogram(bins = 100)



my_breaks <- c(0, 75000, 150000, 225000, 300000, 
               400000, 500000, 70000, 
               max(dat$estimate, na.rm = TRUE))

my_labels <- c("0-$75k", "$76-150k", "$151-225k", "$226-300k",
               "$301-400k", "401-500k", "501-700K",
               "$701k_or_more")

test <- cut(dat$estimate, breaks = my_breaks, labels = my_labels)

tx_zips$value <- cut(tx_zips$estimate, breaks = my_breaks, labels = my_labels)


tm_shape(tx_zips) +
  tm_polygons(col = "value")



library(RColorBrewer)

my_cols <- brewer.pal(9, "Set3")











