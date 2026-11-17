###Week 12 Shiny App HW###

library(shiny)
library(tidyverse)
library(scales)
library(leaflet)
library(nycflights23)

#visualize dataset
head(flights,50)
head(airports,50)
airports <- airports

###Part 1: Create flight data objects###

#create object for destination airports
destination_airports <- flights|>
  #collapse individual flights into total counts
  count(dest,name = "total_flights")|>
  #merge with airports metadata set
  inner_join(airports,by = join_by(dest == faa))

#create object for destination to origin flight routes
flight_routes <- flights|>
  #creates all unique flight combos
  count(origin,dest,name="flights_on_route")|>
  
  #join origin coordinates
  inner_join(airports|>
    #just columns I want
    select(faa,lat_origin = lat,lon_origin = lon),
    #match origin column from route table to to FAA column in metadata
    by = join_by(origin == faa))|>
  
    #join destination coordinates
  inner_join(airports|>
    #just columns I want
    select(faa,lat_destination = lat,lon_destination = lon),
    #match destination column from route table to to FAA column in metadata
    by = join_by(dest == faa))

###Part 2: Establishing Page Layout###

ui <- fluidPage(
  # Input for the plot title
  titlePanel("Domestic Commercial Air Traffic from New York City (2023)"),
  helpText("Data sourced from the CRAN NYCflights23 dataset"),
  
  # Slider to filter destination airports by minimum number of flights
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "min_flights", 
              label = "Minimum Inbound Number of Flights:", 
              min = 0, 
              max = max(destination_airports$total_flights),
              value = 2000,
              step = 200),
  
  #toggle for flight routes
  checkboxGroupInput(
    inputId = "selected_origins",
    label = "Filter Routes by NYC Origin:",
    #three toggle choices
    choices = c("EWR (Newark)" = "EWR",
                "JFK (Kennedy)" = "JFK",
                "LGA (LaGuardia)" = "LGA"),
    #default shows them all
    selected = c("EWR", "JFK", "LGA")
    ),
  
  #placement of running airport list output
  hr(),
  h4("Most Frequent Destinations in Current Map View"),
  tableOutput("top_airports_table")
  ),
  
  #placement of map object
  mainPanel(
    leafletOutput("airports_map",height = "600px")
  )
),
)

###Part 3: Server Logic###

server <- function(input, output){
  
  #reactive filter for airports based on number of inbound flights
  filtered_airports <- reactive({
    flight_routes |>
      #toggle for origin airports
      filter(origin %in% input$selected_origins) |>
      group_by(dest) |>
      #additive count using total from flight_routes object
      summarise(total_flights = sum(flights_on_route), .groups = "drop") |>
      #slider for minimum flights
      filter(total_flights >= input$min_flights)|>
      #attach airport names to FAA codes
      inner_join(airports, by = join_by(dest == faa))
      
  })
  
  #reactive filter for flight routes depending on reactive object for airports
  filtered_routes <- reactive({
    flight_routes|>
      filter(dest %in% filtered_airports()$dest,
             origin %in% input$selected_origins)
  })
  
  #rendering base map with Leaflet
  output$airports_map <- renderLeaflet({
    leaflet()|>
      addTiles()|>
      #boundaries drawn from airport coordinates
      fitBounds(
        lng1 = min(destination_airports$lon),
        lng2 = max(destination_airports$lon),
        lat1 = min(destination_airports$lat),
        lat2 = max(destination_airports$lat)
      )|>
      #legend to differentiate origin airports
      addLegend(
        position = "topright",
        colors = c("navy", "orange", "forestgreen"),
        labels = c("EWR (Newark)", "JFK (Kennedy)", "LGA (LaGuardia)"),
        title = "NYC Origin Airport"
      )
  })

  #color palette to distinguish three NYC origin airports
  route_palette <- colorFactor(
    palette = c("navy","orange","forestgreen"),
    domain = c("EWR", "JFK", "LGA"))

###Part 4: Adding Flight and Airport Dynamic Objects
  
#create observer running off reactive objects
observe({
  #create proxy as leaflet object to connect to map
  proxy <- leafletProxy("airports_map") |>
    clearMarkers() |>
    clearShapes()
  
  #constructing flight routes on map
  if (nrow(filtered_routes()) > 0) {
    routes <- filtered_routes()
    for (i in seq(nrow(routes))) {
      #draw polylines using lat/lon from each iteration of [i]
      proxy <- proxy |>
        addPolylines(
          lng = c(routes$lon_origin[i], routes$lon_destination[i]),
          lat = c(routes$lat_origin[i], routes$lat_destination[i]),
          weight = 1.5,
          color = route_palette(routes$origin[i]),
          opacity = 0.4
        )
    }
  }
  #constructing airport circles
  if (nrow(filtered_airports()) > 0) {
    #draw circles depending on table from filtered_airports reactive
    proxy <- proxy |>
      addCircleMarkers(
        data = filtered_airports(),
        lng = ~lon,
        lat = ~lat,
        radius = ~rescale(total_flights, to = c(3, 18),
                          from = range(destination_airports$total_flights)
                          ),
        color = "yellow",
        fillOpacity = 0.8,
        weight = 1,
        #HTML code popup with airport info
        popup = ~paste0(
          "<b>", name, " (", dest, ")</b><br>",
          "Total Inbound Flights: ", comma(total_flights)
        )
      )
  }
}) 

# Filter visible airports to those inside the current map window
airports_in_view <- reactive({
  #waits until map re-bounding has executed
  req(input$airports_map_bounds)
  #real-time boundaries of map
  bounds <- input$airports_map_bounds
  
  #real-time bounding box depending on map view using filtered_airports reactive
  filtered_airports() |>
    filter(
      lat >= bounds$south,
      lat <= bounds$north,
      lon >= bounds$west,
      lon <= bounds$east
    ) |>
    #arrange airports passing the filter in order of total flights, then take only top 5
    arrange(desc(total_flights)) |>
    slice_head(n = 5)
})

# Render the top 5 airports in map view list
output$top_airports_table <- renderTable({
  airports_in_view() |>
    transmute(
      Airport = paste0(name, " (", dest, ")"),
      `Total Flights` = comma(total_flights)
    )
}, striped = TRUE, hover = TRUE, width = "100%")

}

shinyApp(ui = ui, server = server)
