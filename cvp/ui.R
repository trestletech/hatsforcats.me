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
                id="webcaminput",
                div(
                    tags$video(id="video"),
                    tags$button(id="startbutton", "Take Photo"),
                    class="camera"),
                tags$canvas(id="canvas")
            ),
            selectInput("hat", "Hat Type: ", 
                        choices=c("Cowboy", "Santa", "Party", "Wizard"),
                        selected="Cowboy")
        ),

        mainPanel(
            plotOutput("hat")
        )
    )
))
