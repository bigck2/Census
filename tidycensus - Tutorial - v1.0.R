
library(tidycensus)
library(tidyverse)
library(tmap)
library(sf)

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


v15 <- load_variables(2016, "acs1", cache = TRUE)

View(v15)


pop <- get_acs(geography = "county", variables = "B01001_001", state = "TX")

pop



# Get entire table --------------------------------------------------------


df <- get_acs(geography = "state", table = "B01001", survey = "acs1", year = 2016, cache_table = TRUE)

df <- get_acs(geography = "state", table = "B01001", survey = "acs1", year = 2016)




# Dallas Home Values ------------------------------------------------------

library(leaflet)
library(stringr)
library(sf)

dal_value <- get_acs(geography = "tract", 
                     variables = "B25077_001", 
                     state = "TX",
                     county = "Dallas",
                     geometry = TRUE)

# leaflet::colorNumeric()
pal <- colorNumeric(palette = "viridis", 
                    domain = dal_value$estimate)




dal_value %>%
          st_transform(crs = "+init=epsg:4326") %>%
          leaflet(width = "100%") %>%
          addProviderTiles(provider = "CartoDB.Positron") %>%
          addPolygons(popup = ~estimate,
                      stroke = FALSE,
                      smoothFactor = 0,
                      fillOpacity = 0.7,
                      color = ~ pal(estimate)) %>%
          addLegend("bottomright", 
                    pal = pal, 
                    values = ~ estimate,
                    title = "Median Home Value",
                    labFormat = labelFormat(prefix = "$"),
                    opacity = 1)




# BLAH --------------------------------------------------------------------

metros <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area",
                  variables = "B01003_001")

tx <- get_acs(geography = "zcta", variables = "B01001_001")

us <- get_acs(geography = "us", variables = "B01001_001")


dal <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area", variables = "B01001_001")

dal2 <- get_acs(geography = "principal city", variables = "B01001_001")


teton15 <- get_acs(geography = "block group", variables = "B01003_001", 
                   state = "WY", county = "Teton", geometry = TRUE)


dal_county <- get_acs(geography = "county subdivision", variables = "B01001_001",
                      county = "Dallas", state = "TX")


tx_state <- get_acs(geography = "State Legislative District (Upper Chamber)", variables = "B01001_001")
                      



# possible geography options ------------------------------------------------------------

# Seen working examples

# Note "B01003_001" is the total poulation variable


# county
county <- get_acs(geography = "county", 
                     variables = "B01003_001") 

# County (with geometry) - This takes a LONG time. So you sould probably include a state
county <- get_acs(geography = "county", 
                  variables = "B01003_001", geometry = TRUE) 

qtm(county, fill = "estimate")


# Tract 
# Requires State
tract <- get_acs(geography = "tract", 
                  variables = "B01003_001",
                 state = "TX") 


tract <- get_acs(geography = "tract", 
                 variables = "B01003_001",
                 state = "TX", county = "Dallas") 


tract <- get_acs(geography = "tract", 
                 variables = "B01003_001",
                 state = "TX", county = "Dallas", 
                 geometry = TRUE) 


qtm(tract)

qtm(tract, fill = "estimate")






# State
state <- get_acs(geography = "state", 
                 variables = "B01003_001")


state <- get_acs(geography = "state", 
                 variables = "B01003_001", geometry = TRUE)

qtm(state, fill = "estimate")

# Note if the sf package is not loaded then dplyr::filter will change the object to a tibble and drop the sf class
state <- state %>%
         filter(!(NAME %in% c("Alaska", "Hawaii", "Puerto Rico")))


qtm(state, fill = "estimate")

tm_shape(state) +
  tm_polygons("estimate", id = "NAME")




# County subdivision
# This works but note that geometry does not work at this geography
dal_div <- get_acs(geography = "county subdivision", 
                   variables = "B01003_001", 
                   state = "TX", county = "Dallas")
                   


# Place
my_place <- get_acs(geography = "place", 
                    variables = "B01003_001") 
                    


# Block Group
# Requires State and County
bg <- get_acs(geography = "block group", 
                    variables = "B01003_001", 
              state = "TX", county = "Dallas") 


bg <- get_acs(geography = "block group", 
              variables = "B01003_001", 
              state = "TX", county = "Dallas",
              geometry = TRUE) 

                 

qtm(bg, fill = "estimate")





