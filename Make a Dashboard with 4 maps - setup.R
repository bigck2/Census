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



index <- !is.na(tx_zips$STATEFP)

tx_zips <- zips[index,]

rm(index)
rm(tx, my_states, zips)
rm(my_vec, my_vec_lookup)



dat <- dat %>%
  select(-moe, -variable, -NAME)

dat <- dat %>%
  spread(key = var, value = estimate)



# geo_join the spatialdata to the regular data
tx_zips <- geo_join(tx_zips, dat, "GEOID10", "zip")




# Figure out cut points ---------------------------------------------------


ggplot(data = dat, aes(x = gr_to_income_median)) + geom_histogram()

ggplot(data = dat, aes(x = inc_median_household_income)) + geom_histogram()

ggplot(data = dat, aes(x = median_gross_rent)) + geom_histogram()

ggplot(data = dat, aes(x = total_population)) + geom_histogram()


# gr_to_income_meidan 

my_breaks <- c(0, 20, 30, 40, max(dat$gr_to_income_median, na.rm = TRUE))

my_labels <- c("0-20",
               "21-30",
               "30-40",
               ">=41")

tx_zips$rent_to_income <- cut(x = tx_zips$gr_to_income_median, 
                              breaks = my_breaks, 
                              labels = my_labels)


ggplot(data = tx_zips@data, aes(x = gr_to_income_median, fill = rent_to_income)) +
  geom_histogram()




# inc_median_household

my_breaks <- c(0, 40000, 50000, 60000, 
               70000, 80000, 90000, 110000, 
               150000, max(dat$inc_median_household_income, na.rm = TRUE) )

my_labels <- c("<$40k",
               "$41-50k",
               "$51-60k",
               "$61-70k",
               "$71-80k",
               "$81-90k",
               "91-110k",
               "$111-150k",
               ">$150k")

tx_zips$median_household_income <- cut(x = tx_zips$inc_median_household_income, 
                                       breaks = my_breaks, 
                                       labels = my_labels)


ggplot(data = tx_zips@data, aes(x = inc_median_household_income, fill = median_household_income)) +
  geom_histogram()



# median_gross_rent

my_breaks <- c(0, 750, 1000, 
               1250, 1500, 1750, 
               2000, 2500, max(dat$median_gross_rent, na.rm = TRUE))

my_labels <- c("$0-750",
               "$751-1,000",
               "$1,001-1,250",
               "$1,251-$1,500",
               "$1,501-1,750",
               "1,751-2,000",
               "$2,001-2,500",
               ">$2,500")

tx_zips$median_rent <- cut(tx_zips$median_gross_rent, 
                           breaks = my_breaks, 
                           labels = my_labels)


ggplot(data = tx_zips@data, aes(x = median_gross_rent, fill = median_rent)) + 
  geom_histogram()


# total population

my_breaks <- c(0, 10000, 20000, 30000, 
               40000, 50000, 70000, 
               max(dat$total_population, na.rm = TRUE))

my_cuts <- c("0-10k",
             "11-20k",
             "21-30k",
             "31-40k",
             "41-50k",
             "51-70k",
             ">70k")

tx_zips$population <- cut(tx_zips$total_population, 
                          breaks = my_breaks, 
                          labels = my_labels)





























