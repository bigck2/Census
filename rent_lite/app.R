library(shiny) # for web apps
library(tidyverse) # for everything
library(sp) # for over() / sp objects
library(RColorBrewer) # for brewer.pal()
library(leaflet) # for mapping
library(htmltools) # for htmlEscape()



# Prep Work ---------------------------------------------------------------
# Read in data
tx_zips <- read_rds("tx_zips.rda")

# population
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
            setView(lng = -97.04034, lat = 32.89981, zoom = 9)



# median_household_income
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
                        title = "Median Income",
                        opacity = 1) %>%
              setView(lng = -97.04034, lat = 32.89981, zoom = 9)



# median_rent
my_purples <- brewer.pal(9, "Purples")

factpal_3 <- colorFactor(palette = my_purples, 
                         levels = levels(tx_zips$median_rent))

map_rent <- leaflet(tx_zips) %>%
            addProviderTiles(providers$Stamen.TonerLite) %>%
            addPolygons(stroke = TRUE, 
                        weight = 0.5, 
                        smoothFactor = 0.5, 
                        fillOpacity = 0.5,
                        fillColor = ~factpal_3(median_rent),
                        highlightOptions = highlightOptions(color = "white", 
                                                            weight = 2,
                                                            bringToFront = TRUE), 
                        popup = ~htmlEscape(paste(zip, 
                                                  scales::dollar(median_gross_rent),
                                                  sep = ": " )
                        )
            ) %>%
            addLegend("bottomright",
                      pal = factpal_3, 
                      values = ~median_rent,
                      title = "Median Rent",
                      opacity = 1) %>%
            setView(lng = -97.04034, lat = 32.89981, zoom = 9)



# rent_to_income
my_blues <- brewer.pal(9, "PuBu")

factpal_4 <- colorFactor(palette = my_blues, 
                         levels = levels(tx_zips$rent_to_income))

map_rent_income <- leaflet(tx_zips) %>%
                    addProviderTiles(providers$Stamen.TonerLite) %>%
                    addPolygons(stroke = TRUE, 
                                weight = 0.5, 
                                smoothFactor = 0.5, 
                                fillOpacity = 0.5,
                                fillColor = ~factpal_4(rent_to_income),
                                highlightOptions = highlightOptions(color = "white", 
                                                                    weight = 2,
                                                                    bringToFront = TRUE), 
                                popup = ~htmlEscape(paste(zip, 
                                                          scales::comma(gr_to_income_median),
                                                          sep = ": " )
                                )
                    ) %>%
                    addLegend("bottomright",
                              pal = factpal_4, 
                              values = ~rent_to_income,
                              title = "Rent to Income",
                              opacity = 1) %>%
                    setView(lng = -97.04034, lat = 32.89981, zoom = 9)






# Actual Shiny App --------------------------------------------------------


# Define UI for application 
ui <- fluidPage(
  
  fluidRow(
    
    textInput(inputId = "my_address", 
              label = "Enter Address:",
              value = "3333 Harry Hines Blvd, Dallas, TX 752001"),
    
    actionButton(inputId = "new_add_button", label = "Submit")
     
  ), 
  
  fluidRow(
  
    splitLayout(leafletOutput("map_pop"),
                leafletOutput("map_income") )
  ),
  
  fluidRow(
    
    splitLayout(leafletOutput("map_rent"),
                leafletOutput("map_rent_income"))
                
  )
  
  
            
)


# Define server logic required to draw a histogram
server <- function(input, output) {
   output$map_pop <- renderLeaflet({map_pop})
   output$map_income <- renderLeaflet({map_income})
   output$map_rent <- renderLeaflet({map_rent})
   output$map_rent_income <- renderLeaflet({map_rent_income})
   
   output$my_address <- renderText({input$my_address})
}



# Run the application 
shinyApp(ui = ui, server = server)

