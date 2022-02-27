# Mosaic
Algorithm which creates a photo mosaic from a collection of images - In-depth description on http://multiplexcuriosus.org/mosaic.html

## How to use this code

There are the following use cases:

#### I Create a single photo mosaic from an image collection

#### II For every image in the image collection, create a photo mosaic consisting of all the images in the image collection

#### III For every image in a set of images create a photo mosaic consisting of all images from a different set of images


For all of these cases the following things need to be done to adapt the code to your needs:

#### Customizing

numCores <- number of available cores (often == 8)

n <- number of pixels per picture side

Due to my laziness I will assume you are working on windows and saved Mosaic.pde into a directory on your desktop called Mosaic. Replace <username> with your username.
 
Also, for all use cases, the following two steps need to be done:
 
(1) In the directory with the sketch create a directory called data and one called out
 
(2) In data, create a directory called images. Fill the directory data/images with the images you want the mosaic to consist of
 
### Case I

(1) active <- false, repeat <- false, subset <- false 
              
(2) Once you have added all the images to the collection in data/collection, set update to true. This will create a JSON file into which the RGB values from every image in data/images is saved. Once the code has been run with the boolean values from (3), you can set update to false, which will prevent this JSON file from being created. Whenever you add images to the image collection, you have to run the code once with the boolean values from (3) and update == true.

(3) Run code
 
(4) Now the JSON file described in (4) was created and in out you will find pixelized version of the images in data/images
                                                
(5) subTar <- name of the target image, whose name you find in out
 
(6) active <- true
              
(7) Run code
              
(8) You will find your photo mosaic under out/mosaiked
              
              
### Case II
 
(1) active <- false, repeat <- **true**, subset <- false 
              
(2) Once you have added all the images to the collection in data/collection, set update to true. This will create a JSON file into which the RGB values from every image in data/images is saved. Once the code has been run with the boolean values from (3), you can set update to false, which will prevent this JSON file from being created. Whenever you add images to the image collection, you have to run the code once with the boolean values from (3) and update == true.

(3) Run code
 
(4) Now the JSON file described in (4) was created and in out  you will find pixelized version of the images in data/images
 
(5) active <- true
              
(6) Run code
              
(7) You will find your photo mosaics under out/mosaiked
              
### Case III

Filesystem related
 
(1) In the directory with the sketch create a directory called data and one called out

Algorithm related
 
(2) active <- false, repeat <- **true**, subset <- **tru** 
              
(3) Once you have added all the images to the collection in data/collection, set update to true. This will create a JSON file into which the RGB values from every image in data/images is saved. Once the code has been run with the boolean values from (3), you can set update to false, which will prevent this JSON file from being created. Whenever you add images to the image collection, you have to run the code once with the boolean values from (3) and update == true.

(4) Run code
 
(5) Now the JSON file described in (4) was created and in out you will find pixelized version of the images in data/images
 
(6) active <- true
              
(7) Run code
              
(8) You will find your photo mosaics under out/subset/mosaiked
 

 
 

