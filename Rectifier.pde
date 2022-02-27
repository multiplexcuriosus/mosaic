/* WRITTEN BY JAÚ GRETLER (jau.gretler@gmail.com) around 1.1.22

 This code is intended to bring all pictures in the data folder into the following format:
 
 1.) Find the average color of the picture and set it as background color
 2.) If the picture is horizontal, place it centered such that it spans the width of the screen. 
 If the picture is vertical, rotate it 90° and palce it such that it spans the width of the screen.
 
 Then this new image is saved to the out folder with the same name it had before.
 
 Important:
 - Set the right file path in setup
 
 */

PVector C; // stores coordinates to center of screen for ease of writing

//file system handling
File path;
File [] files;

void setup() {
  fullScreen(P3D);
  C = new PVector(width/2, height/2);

  //set correct file path
  path = new File("C:/Users/username/Desktop/Rectifier/data");
  files = path.listFiles();

  String _name; //variable for name of image file
  PImage target;
  for (int i = 0; i < files.length; i++) { //iterate over all images in data and apply the format
    _name = files[i].getName();
    target = loadImage(_name);
    rectify(target, _name);
  }
  
  println("setup done");
}

void draw() {
}

//POST: bring the input image into the format specified above
void rectify(PImage input, String name) {
  if (input == null) return;
  boolean hor = input.width > input.height; // is the picture horizontal?
  color bg = findCol(input, 0, 0, input.width, input.height, 5, 5); //find average color of input image

  float rRes= (float)input.width/ (float)input.height; //ratio of input image
  float rGood = (float)width/ (float)height; //ratio of screen

  //if picture has a bigger side ratio set its width to screen.width and if the ratio is smaller set its height to screen.height
  if (rRes < rGood) {
    input.resize(0, height);
    println("h");
  } else {
    input.resize(width, 0);
    println("w");
  }

  PImage res;
  /*if the image is vertical, rotate it by 90°clockwise by doing this: rotate the coordinate system by 90° clockwise,
   draw the image in the center, rotate the cs back, retrieve image with get, scale it, draw and save it
   */

  if (!hor) {
    translate(width/2, height/2);
    rotateZ(PI/2);
    imageMode(CENTER);
    image(input, 0, 0);
    imageMode(CORNER);
    rotateZ(-PI/2);
    translate(-width/2, -height/2);
    PVector cL = new PVector(C.x-input.height/2, C.y-input.width/2);
    res = get((int)cL.x, (int)cL.y, input.height, input.width);
    res.resize(width, 0);
  } else {
    res = input;
    res.resize(0, height);
  }
  background(bg);
  imageMode(CENTER);
  image(res, width/2, height/2);
  saveFrame("out/"+name);
}


//POST: return average color of img
color findCol(PImage img, int x0, int y0, int sX, int sY, int deltaX, int deltaY) {
  int red = 0;
  int green = 0;
  int blue = 0;
  int num = sX*sY/(deltaX*deltaY);
  img.loadPixels();
  for (int x = x0; x<x0+sX; x+=deltaX) {
    for (int y = y0; y<y0+sY; y+=deltaY) {
      color col = img.get(x, y);
      red += red(col);
      green += green(col);
      blue += blue(col);
    }
  }
  red /= num;
  green /= num;
  blue /= num;
  return color(red, green, blue);
}
