
# these imports let you use opencv
import cv2 #opencv itself
import common #some useful opencv functions
#import video # some video stuff
import numpy as np # matrix manipulations

def find_faces(file):
  face_image = cv2.imread(file)
  grey = cv2.cvtColor(face_image, cv2.COLOR_BGR2GRAY)

  hat = cv2.imread("hat.png", -1)

  face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
  faces = face_cascade.detectMultiScale(grey, 1.3, 5)
  
  for (x,y,w,h) in faces:
       cv2.rectangle(face_image,(x,y),(x+w,y+h),(255,0,0),2)
       
       #hat_height = s_img.shape[0]
       #hat_width = s_img.shape[1]
       s_hat = cv2.resize(hat, dsize=(w,h))
       
       y1, y2 = y, y + s_hat.shape[0]
       x1, x2 = x, x + s_hat.shape[1]
      
       alpha_s = s_hat[:, :, 3] / 255.0
       alpha_l = 1.0 - alpha_s
      
       for c in range(0, 3):
           face_image[y1:y2, x1:x2, c] = (alpha_s * s_hat[:, :, c] +
                                    alpha_l * face_image[y1:y2, x1:x2, c])

  return face_image
