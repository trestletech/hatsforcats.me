
library(shiny)
library(grid)
library(base64enc)

# Set the env var before publishing in the IDE: 
# Sys.setenv("RETICULATE_PYTHON"="./ve/bin/python")
library(reticulate)
reticulate::use_virtualenv("./ve/")

#reticulate::virtualenv_install("./ve/", "opencv-python")
#reticulate::virtualenv_install("./ve/", "matplotlib")

sys <- import("sys")
sys$path <- c(sys$path, "/data/face-python")

cv2 <- import("cv2")
numpy <- import("numpy")

source_python("common.py")
source_python("helper.py")

shinyServer(function(input, output) {

    hatfile <- reactive({
        switch(input$hat,
               Cowboy="cowboy.png",
               Santa="santa.png",
               Party="party.png",
               Wizard="wizard.png")
    })
    
    output$hat <- renderPlot({
        req(webcamUpload())
        imgpath <- webcamUpload()
        
        img <- find_faces(imgpath, hatfile())
        
        img <- img/255
        col <- rgb(img[,,3], img[,,2], img[,,1])
        dim(col) <- dim(img[,,1])
        grid.raster(col, interpolate=FALSE)
    })
    
    webcamUpload <- reactive({
        wci <- input$webcaminput
        if (is.null(wci)){
            return(NULL);
        }
        dat <- strsplit(wci, ",", fixed=TRUE)[[1]]
        img <- dat[2]
        fil <- tempfile("uploaded-img", fileext=".jpg")
        output <- file(fil, "wb")
        base64enc::base64decode(img, output)
        close(output)
    
        fil
    })

})
