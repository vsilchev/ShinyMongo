library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Twitter Analytics"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      textInput("searchQuery", "Let's find some:", value="#mongodb"),
      actionButton("go", "Search"),
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 50, value = 5),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 100,  value = 50)
    ),
    
    mainPanel(
      plotOutput("plot")
    )
  )
))