
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
       hat_w = w * 2
       hat_h = h
       s_hat = cv2.resize(hat, dsize=(hat_w, hat_h))
       
       y1, y2 = int(y - h * .7), int(y - h *.7 + hat_h)
       x1, x2 = int(x - w/2), int(x - w/2 + hat_w)
       
       #print "X: ", x1, x2, "Y:", y1, y2
       #print "Face: ", face_image.shape
       
       if x1 < 0:
         x1 = 0
       if y1 < 0:
         y1 = 0
       if x2 > face_image.shape[1]:
         x2 = face_image.shape[1]
       if y2 > face_image.shape[0]:
         y2 = face_image.shape[0]
         
       s_hat = cv2.resize(hat, dsize=(x2-x1, y2-y1))
      
       alpha_s = s_hat[:, :, 3] / 255.0
       alpha_l = 1.0 - alpha_s
      
       for c in range(0, 3):
           face_image[y1:y2, x1:x2, c] = (alpha_s * s_hat[:, :, c] +
                                    alpha_l * face_image[y1:y2, x1:x2, c])

  return face_image
