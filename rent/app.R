library(shiny) # for web apps
library(tidyverse) # for everything
library(sp) # for over() / sp objects
library(RColorBrewer) # for brewer.pal()
library(leaflet) # for mapping
library(htmltools) # for htmlEscape()


tx_zips <- read_rds("tx_zips.rda")


# population,

my_cols <- brewer.pal(9, "YlGnBu")

factpal <- colorFactor(palette = my_cols, levels = levels(tx_zips$population))

map_pop <- leaflet(tx_zips) %>%
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

map_income <- leaflet(tx_zips) %>%
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









# Define UI for application 
ui <- fluidPage(
  
  fluidRow( leafletOutput("map_pop") ),
  
  fluidRow( leafletOutput("map_income", height = ) )
            
)


# Define server logic required to draw a histogram
server <- function(input, output) {
   output$map_pop <- renderLeaflet({map_pop})
   output$map_income <- renderLeaflet({map_income})
}



# Run the application 
shinyApp(ui = ui, server = server)

