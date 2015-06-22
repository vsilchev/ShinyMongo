library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      actionButton("go", "Go"),
      textInput("searchQuery", "Let's find", value="#mongodb")
    ),
    
    mainPanel(
      verbatimTextOutput("nText")
    )
  )
))