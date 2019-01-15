library(shiny)

shinyUI(fluidPage(

    
    tagList(
        singleton(tags$head(
            tags$script(src="capture.js"),
            tags$link(rel="stylesheet", type="text/css", href="main.css")
        ))
    ),
    
    titlePanel("Reticulated opencv hat preview"),

    sidebarLayout(
        sidebarPanel(
            div(
                tags$video(id="video"),
                tags$button(id="startbutton", "Take Photo"),
                class="camera"),
            tags$canvas(id="canvas"),
            div(
                tags$img(id="photo"), 
                class="output"
            )
        ),

        mainPanel(
            plotOutput("hat")
        )
    )
))
