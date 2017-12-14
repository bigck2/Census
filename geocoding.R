
library(tidyverse)
library(ggmap) # for geocode()
library(tigris) # for getting shape files, ie counties()
library(tmap) # for maps, ie tm_shape() + tm_polygons()
library(sp) # for sp class, and over()


# Geo Code some addresses -------------------------------------------------


my_address <- "18235 Justice Ln Dallas, TX 75827"
my_geo <- geocode(location = my_address,output = "more" )


my_work <- "600 E. Las Colinas Blvd. Suite 2100 Irving, Texas 75039"
my_wk_geo <- geocode(location = my_work, output = "more")

mom <- "5846 Shurmard Houston, TX 77092"
mom_geo <- geocode(location = mom, output = "more")

my_adds <- c(my_address = my_address, my_work = my_work, mom = mom)
my_adds
my_geos <- geocode(location = my_adds, output = "more")

View(my_geos)



# Download Shape Files for counties in TX ---------------------------------
my_counties <- counties(cb = TRUE, resolution = "20m", state = "TX")




# Make a map --------------------------------------------------------------
tm_shape(my_counties) +
  tm_polygons(col = "lightgreen")



# Filter Counties to Dallas -----------------------------------------------
dallas <- my_counties[my_counties$NAME == "Dallas",]





# Create and sp Points Object ---------------------------------------------

# Create regular df
df <- my_geos %>%
      select(lon, lat)

df$names <- my_geos$.id

# Now convert the df to sp object  
coordinates(df) <- ~ lon + lat
proj4string(df) <- proj4string(dallas)




# Use Over Function to see which overlaps ---------------------------------
over(dallas, df)

over(df, dallas)




# Creating a map in layers ------------------------------------------------
tm_shape(my_counties) +
  tm_polygons(col = "lightgreen") +
tm_shape(dallas) +
  tm_polygons(col = "lightblue", border.col = "blue") +
tm_shape(df) + 
  tm_squares()

# If you save the above into a variable and call tmap_leaflet it will be an interactive map
tmap_leaflet(m)








