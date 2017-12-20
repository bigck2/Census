library(tidyverse)
library(stringr)
library(tidycensus) # to pull census data
library(tigris) # to get shapefiles
options(tigris_use_cache = TRUE)
library(sp) # for over()
library(RColorBrewer) # for brewer.pal()
library(leaflet) # for mapping
library(rgeos) # for trueCentroids() 
library(htmltools) # for htmlEscape()

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

my_labels <- c("0-10k",
               "11-20k",
               "21-30k",
               "31-40k",
               "41-50k",
               "51-70k",
               ">70k")

tx_zips$population <- cut(tx_zips$total_population, 
                          breaks = my_breaks, 
                          labels = my_labels)


ggplot(data = tx_zips@data, aes(x = total_population, fill = population)) + 
  geom_histogram()


rm(my_breaks, my_labels)



# Calculate Polygon Centroids ---------------------------------------------

# TODO Delete this code, it isn't really needed in mapping

# TODO: this could be useful to calculate the nearest 10 zip codes or something


# trueCentroids <- gCentroid(tx_zips, byid = TRUE)
# 
# tx_zips$lon <- trueCentroids@coords[,1]
# tx_zips$lat <- trueCentroids@coords[,2]
# 
# rm(trueCentroids)


# TODO calculate population density

my_area <- gArea(tx_zips, byid = TRUE)


# Make some maps ----------------------------------------------------------




# median_rent,
# rent_to_income


# population,

my_cols <- brewer.pal(9, "YlGnBu")

factpal <- colorFactor(palette = my_cols, levels = levels(tx_zips$population))

leaflet(tx_zips) %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(stroke = TRUE, 
              weight = 0.5, 
              smoothFactor = 0.5, 
              fillOpacity = 0.5,
              fillColor = ~factpal(population),
              highlightOptions = highlightOptions(color = "white", 
                                                  weight = 2,
                                                  bringToFront = TRUE), 
              popup = ~htmlEscape(paste(zip, 
                                        format(total_population, 
                                               big.mark = ","), 
                                        sep = ": " )
                                  )
              ) %>%
  addLegend("bottomright",
            pal = factpal, 
            values = ~population,
            title = "Total Population",
            opacity = 1) %>%
  setView(lng = -97.04034, lat = 32.89981, zoom = 10)




# median_household_income,
my_reds <- brewer.pal(9, "Reds")

factpal_2 <- colorFactor(palette = my_reds, 
                       levels = levels(tx_zips$median_household_income))

leaflet(tx_zips) %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(stroke = TRUE, 
              weight = 0.5, 
              smoothFactor = 0.5, 
              fillOpacity = 0.5,
              fillColor = ~factpal_2(median_household_income),
              highlightOptions = highlightOptions(color = "white", 
                                                  weight = 2,
                                                  bringToFront = TRUE), 
              popup = ~htmlEscape(paste(zip, 
                                        scales::dollar(inc_median_household_income),
                                        sep = ": " )
              )
  ) %>%
  addLegend("bottomright",
            pal = factpal_2, 
            values = ~median_household_income,
            title = "Median Household Income",
            opacity = 1) %>%
  setView(lng = -97.04034, lat = 32.89981, zoom = 10)

