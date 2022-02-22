# Mosaic
Algorithm which creates a photo mosaic from a collection of images

## How to use this code

There are the following use cases:

#### I Create a single photo mosaic from an image collection

#### II For every image in the image collection, create a photo mosaic consisting of all the images in the image collection

#### III For every image in a set of images create a photo mosaic consisting of all images from a different set of images


For all of these cases the following things need to be done to adapt the code to your needs:

#### Customizing

numCores <- number of available cores (often == 8)

n <- number of pixels per picture side

There are also some things you need to do in preparation.

Due to my laziness I will assume you saved Mosaic.pde into a directory on your desktop called Mosaic. Replace <username> with your username.
 
#### Preparation (Case I)

Filesystem related
 
(1) In the directory with the sketch, create a directory called data
 
(2) In data, create a directory called images. Fill the directory data/images with the images you want the mosaic to consist of

Algorithm related
 
(3) active <- false, repeat <- false, subset <- false 
              
(4) Once you have added all the images to the collection in data/collection, set update to true. This will create a JSON file into which the RGB values from every image in data/images is saved. Once the code has been run with the boolean values from (3), you can set update to false, which will prevent this JSON file from being created. Whenever you add images to the image collection, you have to run the code once with the boolean values from (3) and update == true.
 


This algorithm does the following:
 - if active == false : go through all photos in /data/images, calc their average color and saves all of this info into a json file in /out. It also saves a pixilated version into /out
 - if active == true : go through all pixels of a target photo and decide which, photo from the collected in /images has the best matching average color.
 Then Draw all newly determined pixels at their right location such that a photo mosaic is created
 
 In-depth description on http://multiplexcuriosus.org/mosaic.html
 
 

