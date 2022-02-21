# mosaic
Algorithm which creates a foto mosaic from colleciton of images

This algorithm does the following:
 - if active == false : go through all photos in /data/images, calc their average color and saves all of this info into a json file in /out.
 It also saves a pixilated version into /out
 - if active == true : go through all pixels of a target photo and decide which, photo from the collected in /images has the best matching average color.
 Then Draw all newly determined pixels at their right location such that a photo mosaic is created
 
 In-depth description on http://multiplexcuriosus.org/mosaic.html
 
 

