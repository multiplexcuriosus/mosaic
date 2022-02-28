# Mosaic
Algorithm which creates a photo mosaic from a collection of images - In-depth description on http://multiplexcuriosus.org/mosaic.html

## How to use this code

There are the following use cases:

#### I Create a single photo mosaic from an image collection

#### II For every image in the image collection, create a photo mosaic consisting of all the images in the image collection

#### III For every image in a set of images create a photo mosaic consisting of all images from a different set of images

Due to my laziness I will assume you are working on windows and saved Mosaic.pde into a directory on your desktop called Mosaic (Mind the upper case M).

For all three cases you need to do the following:

(1) In the directory with the sketch create a directory called data and one called out
 
(2) In data, create a directory called images. Fill the directory data/images with the images you want the mosaic to consist of
 
(3) Replace 'username' with your username.

(4) numCores <- number of available cores (often == 8), n <- number of pixels per picture side (I highly suggest a multiple of 8 between 40 and 80)

Now come the case specific instructions


IMPORTANT:

If you are in case II or III, the console will display a bunch of error messages once all images are mosaikized. This does not need to concern you.

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
 
(1) In /data create a directory called subset. Fill data/subset with the target images.

Algorithm related
 
(2) active <- false, repeat <- **true**, subset <- **true**, update <- **false**

(3) Run code

(4) active <- false, repeat <- true, subset <- **false**, update <- **true**

(5) Run code

(6) active <- **true**, repeat <- true, subset <- **true**, update <- **false**
              
(7) Run code
                     
(8) You will find your photo mosaics under out/subset/mosaiked
 

 
### Rectifier
Now you might realise that the images got all squeezed into a rectangular shape no matter what their original dimension was. To overcome this problem I have written a processing sketch which takes iterates over all images in a directory and 
 
a) rotates them 90 degrees clockwise if they are vertical (height > width) 
 
b) positions them centered into a new image, keeping its original dimension
 
c) fills the leftover space with the average color of the image

To use rectify.pde you need to do the following:

(1) Create a directory on your desktop called Rectifier and move the Rectifier.pde file in there

(2) Inside the directory Rectifier, create a directory called data and one called out

(3) Fill the directory data with all the images you want to later input into the mosaic sketch

(4) Replace username with you username

(5) If you run the Rectifier sketch now it will perform the actions a),b) and c) which I described above for all the images in /data

Using these "rectified" images for the mosaic sketch will result in mosaics in which the individual images will be better recognizable
 
 
 
 

