library(tidyverse)
library(stringr)
library(tidycensus)
library(tigris)
options(tigris_use_cache = TRUE)
library(sp)

census_api_key("f6259ec5d271471f6656ae7c66e2f41b867e5cb1")


my_vec <- c(total_population = "B01003_001",
            inc_median_household_income = "B19013_001",
            median_gross_rent = "B25031_001",
            gr_to_income_median = "B25071_001")


# access the api to get the data 
dat <- get_acs(geography = "zcta", 
                  variables = my_vec,  
                  survey = "acs5", 
                  year = 2016)



# Create a named vector (opposite of my_vec) (a lookup vector)
my_vec_lookup <- names(my_vec)
names(my_vec_lookup) <- my_vec

# Index the lookup table / vector by the variable column 
dat$var <- my_vec_lookup[dat$variable]


# create a column that is clean with just the zip code
dat <- dat %>%
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



dat <- dat %>%
        select(-moe, -variable, -NAME)

dat <- dat %>%
        spread(key = var, value = estimate)



# geo_join the spatialdata to the regular data
tx_zips <- geo_join(tx_zips, dat, "GEOID10", "zip")




# Figure out cut points ---------------------------------------------------


ggplot(data = dat, aes(x = gr_to_income_median)) + geom_histogram()









