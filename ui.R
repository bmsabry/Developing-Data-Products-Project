library(shiny)
library(shinyhelper)
library(magrittr)
shinyUI(fluidPage(
  titlePanel("Predict MPG from HP"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sliderHP", "What is the HP of the car?", 50, 335, value = 150),
      hr(),
      uiOutput(outputId = "dynamicUI"),
      hr()
      
    ),
    mainPanel(
      plotOutput("plot1",click = "plot_click"),
      verbatimTextOutput("info"),
      h3("Click on the points of interest to get the MPG and HP"),
      h4("Predicted MPG :"),
      textOutput("pred"),
      h4("Predicted Min MPG :"),
      textOutput("predmin"),
      h4("Predicted Max MPG :"),
      textOutput("predmax")

    )
  )
))

