library(shiny) # for web apps
library(tidyverse) # for everything
library(sp) # for over() / sp objects
library(RColorBrewer) # for brewer.pal()
library(leaflet) # for mapping
library(htmltools) # for htmlEscape()
library(ggmap) # for geocode()
library(DT) # for datatable()



# Prep Work ---------------------------------------------------------------
# Read in data
tx_zips <- read_rds("tx_zips.rda")





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



# Geocode "Home" address --------------------------------------------------

home <- "3333 Harry Hines Blvd, Dallas, TX 752001"
  
my_geo_table <- geocode(home, output = "more")

my_cols <- c("lon", "lat", "address", "neighborhood", "administrative_area_level_2", "postal_code")

my_geo_table <- geocode(home, output = "more")[,my_cols]

my_lon <- my_geo_table$lon[1]
my_lat <- my_geo_table$lat[1]



# Actual Shiny App --------------------------------------------------------


# Define UI for application 
ui <- fluidPage(
  fluidRow(
    textInput(inputId = "my_address", 
              label = "Enter Address:",
              value = "3333 Harry Hines Blvd, Dallas, TX 752001"),
    
    actionButton(inputId = "submit_button", label = "Submit")
  ), 
  fluidRow(
    dataTableOutput("geo_add")
  ),
  fluidRow(
      leafletOutput("map_income") 
  )
)


# Define server logic 
server <- function(input, output) {
  
  
  new_address <- eventReactive(input$submit_button, {
    my_geo_table <- geocode(input$my_address, output = "more")[,my_cols]
    my_geo_table
  })
  
  output$geo_add <- renderDataTable(new_address(), 
                                    options = list(paging = FALSE,
                                                   searching = FALSE))
   
  output$map_income <- renderLeaflet({
    map_income
    })
  
  
  
  
  output$map_income <- eventReactive(input$submit_button, {
                              renderLeaflet({map_income})
                                      })

}

# Run the application 
shinyApp(ui = ui, server = server)

