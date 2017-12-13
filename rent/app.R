library(tidycensus)
library(tigris)
library(tmap)
library(tidyverse)
library(leaflet)
library(shiny)



my_dat <- read_rds("my_dat.rds")



p <- tm_shape(my_dat) +
        tm_polygons("estimate")



# Define UI for application that draws a histogram
ui <- fluidPage(
  
      # Show a plot of the generated distribution
      mainPanel(
        
         leafletOutput("distPlot")
         
      )
   
)


# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderLeaflet({
      
     tmap_leaflet(p)
     
   })
}



# Run the application 
shinyApp(ui = ui, server = server)

