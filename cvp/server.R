
library(shiny)
library(grid)

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

    output$hat <- renderPlot({
        req(input$img)
        imgpath <- input$img[1,]$datapath
        
        img <- find_faces(imgpath)
        
        img <- img/255
        col <- rgb(img[,,3], img[,,2], img[,,1])
        dim(col) <- dim(img[,,1])
        grid.raster(col, interpolate=FALSE)
    })

})
