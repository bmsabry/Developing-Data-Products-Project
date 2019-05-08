---
title       : Estimating MPG from HP
subtitle    : Developing Data Products Course Project
author      : Bassam Abdelnabi
job         : Engineer
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}

knit        : slidify::knit2slides

---

## what does the code provide and how it works?

This tool helps the user estimate the expected MPG (miles per gallon) of a vehicle as a function of the HP (Hourse Power). The user uses a slider to select the HP of interest and then the program gives four outputs. The first output is a plot with the origional data set and a fitted curve. Also, there are dotted lines on the plot that define the Standard Deviation (3 sigma). the red line on the plot will move based on the user entry to illustrate the specifc point of interst on the curve. 

There are also three text boxes. the first one provides the average MPG expected based on the fitted curve. The second one provides the minimum expected MPG based on the standard deviation bands. The third one provides the maximum expected MPG based on the upper standard deviation band. 

The curve fit in the code uses a smoothed spline. The blue vertical dotted lines on the curve define the splitting points. The user cannot chage that. However, the splitting was done in such a way to ensure that the fit is smooth and that the physics is captured properly.

--- .class #id 

## Slide 3
This is a screen shot of the Shiny App hosted on RShiny
<img src=assets/img/DevelopingDataProductsProjectScreen style="width: 750px">


--- .class #id 
## UI code Overview

```r
library(shiny); library(shinyhelper); library(magrittr)
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
```

<!--html_preserve--><div class="container-fluid">
<h2>Predict MPG from HP</h2>
<div class="row">
<div class="col-sm-4">
<form class="well">
<div class="form-group shiny-input-container">
<label class="control-label" for="sliderHP">What is the HP of the car?</label>
<input class="js-range-slider" id="sliderHP" data-min="50" data-max="335" data-from="150" data-step="1" data-grid="true" data-grid-num="9.82758620689655" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
</div>
<hr/>
<div id="dynamicUI" class="shiny-html-output"></div>
<hr/>
</form>
</div>
<div class="col-sm-8">
<div id="plot1" class="shiny-plot-output" style="width: 100% ; height: 400px" data-click-id="plot_click" data-click-clip="TRUE"></div>
<pre id="info" class="shiny-text-output noplaceholder"></pre>
<h3>Click on the points of interest to get the MPG and HP</h3>
<h4>Predicted MPG :</h4>
<div id="pred" class="shiny-text-output"></div>
<h4>Predicted Min MPG :</h4>
<div id="predmin" class="shiny-text-output"></div>
<h4>Predicted Max MPG :</h4>
<div id="predmax" class="shiny-text-output"></div>
</div>
</div>
</div><!--/html_preserve-->

--- .class #id 

## server.r code Sample

```r
library(shiny)
library(shinyhelper)
library(magrittr)

shinyServer(function(input, output,session) {
  observe_helpers(withMathJax = TRUE)
  require(splines)
  model <-lm(mpg~bs(hp,knots=c(100,200)),mtcars)
  hp.lims=range(mtcars$hp)
  hp.grid=seq(from=hp.lims[1],to=hp.lims[2])
  preds=predict(model,newdata=list(hp=hp.grid),se=TRUE)
  se.bands=cbind(preds$fit+3*preds$se,preds$fit-3*preds$se)
 
  hpInput <- reactive({
    input$sliderHP})
  
  modelpred <- reactive({
    predict(model, newdata = data.frame(hp = hpInput()))
  
  })
  
  modelpredmin <- reactive({
    predict(model, newdata = data.frame(hp = hpInput()))-3*preds$se[hpInput()-hp.lims[1]]
    
  })
  
  modelpredmax <- reactive({
    predict(model, newdata = data.frame(hp = hpInput()))+3*preds$se[hpInput()-hp.lims[1]]
    
  })
  
  output$plot1 <- renderPlot({
    plot(mtcars$hp, mtcars$mpg, xlab = "HorsePower", 
         ylab = "mpg", bty = "n", pch = 16,
         xlim = c(50, 400), ylim = c(6, 40))
     lines(hp.grid,preds$fit,col="blue",lwd=2)
      abline(v=c(100,200),lty=2,col="blue")
      matlines(hp.grid,se.bands,col="lightblue",lty =2)
      abline(v=hpInput(),lty=2,col="red")
 #      points(hpInput, modelpred(), col = "red", pch = 16, cex = 2)

  })
  
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })
  
  output$pred <- renderText({
    modelpred()
  })
  
  output$predmin <- renderText({
    modelpredmin()
  })
  
  output$predmax <- renderText({
    modelpredmax()
  })
  
  output$dynamicUI <- renderUI({
   h4("Click the help icon for current details...") %>%
     helper(icon = "question",
            colour = "orange",
            size = "s",
            type = "inline",
            title = "Current Details",
            content = c("</br>This tool helps the user estimate the expected MPG (miles per gallon) of a vehicle as a function of the HP (Hourse Power). The user uses a slider to select the HP of interest and then the program gives four outputs. The first output is a plot with the origional data set and a fitted curve. Also, there are dotted lines on the plot that define the Standard Deviation (3 sigma). the red line on the plot will move based on the user entry to illustrate the specifc point of interst on the curve. 

                        There are also three text boxes. the first one provides the average MPG expected based on the fitted curve. The second one provides the minimum expected MPG based on the standard deviation bands. The third one provides the maximum expected MPG based on the upper standard deviation band. 
                        
                        The curve fit in the code uses a smoothed spline. The blue vertical dotted lines on the curve define the splitting points. The user cannot chage that. However, the splitting was done in such a way to ensure that the fit is smooth and that the physics is captured properly.
                        "))
 })
  
})
```
