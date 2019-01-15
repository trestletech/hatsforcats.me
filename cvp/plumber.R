
library(grid)

library(reticulate)
reticulate::use_virtualenv("./ve/")

#reticulate::virtualenv_install("./ve/", "opencv-python")
#reticulate::virtualenv_install("./ve/", "matplotlib")

sys <- import("sys")
sys$path <- c(sys$path, "/data/face-python")

cv2 <- import("cv2")
numpy <- import("numpy")

source_python("common.py")
#source_python("video.py")
source_python("helper.py")

#* @post /addhat
function(){
  
  source_python("helper.py") #FIXME: remove
  img <- find_faces("test.jpg")
  
  img <- img/255
  col <- rgb(img[,,3], img[,,2], img[,,1])
  dim(col) <- dim(img[,,1])
  grid.raster(col, interpolate=FALSE)
}