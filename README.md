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
 
### Case I

Filesystem related
 
(1) In the directory with the sketch create a directory called data and one called out
 
(2) In data, create a directory called images. Fill the directory data/images with the images you want the mosaic to consist of

Algorithm related
 
(3) active <- false, repeat <- false, subset <- false 
              
(4) Once you have added all the images to the collection in data/collection, set update to true. This will create a JSON file into which the RGB values from every image in data/images is saved. Once the code has been run with the boolean values from (3), you can set update to false, which will prevent this JSON file from being created. Whenever you add images to the image collection, you have to run the code once with the boolean values from (3) and update == true.

(5) Run code
 
(6) Now the JSON file described in (4) was created and in data/out you will find pixelized version of the images in data/images
                                                
(7) subTar <- name of the target image, whose name you find in out
 
(8) active <- true
              
(9) Run code
              
(10) You will find your photo mosaic under out/mosaiked
              
              
### Case II

Filesystem related
 
(1) In the directory with the sketch create a directory called data and one called out
 
(2) In data, create a directory called images. Fill the directory data/images with the images you want the mosaic to consist of

Algorithm related
 
(3) active <- false, repeat <- **true**, subset <- false 
              
(4) Once you have added all the images to the collection in data/collection, set update to true. This will create a JSON file into which the RGB values from every image in data/images is saved. Once the code has been run with the boolean values from (3), you can set update to false, which will prevent this JSON file from being created. Whenever you add images to the image collection, you have to run the code once with the boolean values from (3) and update == true.

(5) Run code
 
(6) Now the JSON file described in (4) was created and in data/out  you will find pixelized version of the images in data/images
 
(7) active <- true
              
(8) Run code
              
(9) You will find your photo mosaics under out/mosaiked
              
### Case III

Filesystem related
 
(1) In the directory with the sketch create a directory called data and one called out
 
(2) In data, create a directory called images. Fill the directory data/images with the images you want the mosaic to consist of

(3) In data create a directory called subset. Fill the directory data/subset with the target images (the images of which you want a mosaic of)

Algorithm related
 
(4) active <- false, repeat <- **true**, subset <- **tru** 
              
(4) Once you have added all the images to the collection in data/collection, set update to true. This will create a JSON file into which the RGB values from every image in data/images is saved. Once the code has been run with the boolean values from (3), you can set update to false, which will prevent this JSON file from being created. Whenever you add images to the image collection, you have to run the code once with the boolean values from (3) and update == true.

(5) Run code
 
(6) Now the JSON file described in (4) was created and in data/out you will find pixelized version of the images in data/images
 
(7) active <- true
              
(8) Run code
              
(9) You will find your photo mosaics under out/subset/mosaiked
 

 
 

