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


## Slide 4
ui code

--- .class #id 

## Slide 5
server.r code
