/* WRITTEN BY JAÚ GRETLER (jau.gretler@gmail.com) around 1.1.2022

For detailled instructions please read the Readme on GitHub https://github.com/multiplexcuriosus/mosaic

Short description of what this code does:
 - If active == false : go through all photos in /data/images, calc their average color and saves all of this info into a json file in /out.
 It also saves a pixilated version into /out
 - If active == true : go through all pixels of a target photo and decide which photo from the collected in /images has the best matching average color.
 Then Draw all newly determined pixels at their right location such that a photo mosaic is created
 
 */

//#############
int n = 40; //number by which screen.width and screen.height get divided to form pixel side dimensions
//#############

int stepsX; //sides of pixels
int stepsY;

int numCores = 8; // number of cores ~ degree of parallelization

//images
JSONArray vals; //json array which holds info about all images from data/images, i.e their average rgb values
String[][] newPixels; // when threads are done with
int[][][] pixRects; //remember which pixels to draw where, all data points determined by mosaic_threaded
HashMap<String, PImage> allImgs; //in active mode, all source images get loaded into allImgs
PImage img; //target image
ArrayList<String> pixImgsNams; //for repeat mode this arraylist is faster than using an PImage array
//threads
ArrayList<int[]> threadData; //the dac method determines the chunk intervals and saves them here, the mosaic_threaded method extracts the chunk intervals from here to get to work
String[] names; //names of images
int chunkArea = n*n/numCores;
int threadIndex = 0;
//preload
PVector[] preLoadIntervals; //
int preLoadIndex = 0;
boolean[] preLoadDones;
boolean preLoadDone = false;
boolean fancy = false; //when set to true certain threads dont go to work thereby leaving their sector blank
boolean preloadDone = false;

//file system handling
File path1; //path to set of unaltered source imgs
File path2; //path to pixelised version of path1 pictures
File path3; //path to small subset of set at path1
File path4; //path to pixelised version of path3 pictures
File [] files1;
File [] files2;
File [] files3;
File [] files4;

//sequence handling
//#######################################
//#######################################
//active == true: mosaic is created
//active == false: images in data/images get pixelised and analized, average col is saved to json file
boolean active = false;
boolean repeat = false ; //true: mosaikize all images in images folder. might stop aprubtly, there is a bug lurking around somewhere
//#######################################
boolean subset = false; //false: use images from path2. true: use images from path3
boolean update = true; //replace json object with new containing pixel data. Only makes sense if new pictures are added to image pool
//#######################################
boolean threadApproxDones[]; //keeps track of which approximateThreads are done
boolean run = true;
int globaldrawIndex = 0;
int mosaikIndex = 0;

String subTar = "x_y_z"; //name of pixelised target image in data/out
String target = "out/n_"+n+"/"+subTar+".jpg"; //if !repeat this image will be approximated

void setup() {

  fullScreen();
  background(0);

  //get image files
  path1 = new File("C:/Users/username/Desktop/Mosaic/data/images");
  files1 = path1.listFiles();
  path2 = new File("C:/Users/username/Desktop/Mosaic/out/n_"+n);
  files2 = path2.listFiles();
  path3 = new File("C:/Users/username/Desktop/Mosaic/data/subset");
  files3 = path3.listFiles();
  path4 = new File("C:/Users/username/Desktop/Mosaic/out/subset/n_"+n);
  files4 = path4.listFiles();

  //init data structures
  allImgs = new HashMap<String, PImage>();

  names = new String[260]; //length = number of images in /data/images
  newPixels = new String[numCores][width*height/numCores];
  pixRects = new int[numCores][width*height/numCores][4];
  threadApproxDones = new boolean[numCores];
  preLoadDones = new boolean[numCores];
  threadData = new ArrayList<int[]>();

  //reset boolean arrays, indices and sequence variables
  reset();

  //pixel dimensions
  stepsX = width/n;
  stepsY = height/n;

  if (active) {
    if (repeat) pixImgsNams = loadImgNames(); // load names of pixelised images
    vals = loadJSONArray("out/colors.json"); // load json file
    preload(); //only for active mode //load all images into a hashmap
    dac(); //determines chunks and instantiates threads (divide and conquer)
  } else {
    //Pixelizing
    ArrayList<PImage> imgs = loadImgs();
    color[] colData = new color[imgs.size()];
    vals = new JSONArray();
    prepare(vals, colData, imgs); //pixelize all images and save their average colors into the vals json file
  }
  println("setup done");
}

void draw() {
  if (active) { //active == false -> images are prepared in setup, no need for draw
    approximate(); //search best fitting image for each pixel of image
  }
}

void approximate() {
  if (run) {
    boolean allDone = true;
    for (int k = 0; k<numCores; k++) allDone = threadApproxDones[k] && allDone; //wait until are threads are done with searching for the best images until beginning to place them
    if (allDone) {
      for (int i = 0; i<numCores; i++) {
        int M = pixRects[i].length;
        for (int j = 0; j<M; j++) {
          PImage pixel = allImgs.get(newPixels[i][j]);
          //if (pixel == null) println(newPixels[i][j] +" is null in approximate");
          int x = pixRects[i][j][0];
          int y = pixRects[i][j][1];
          int dx = pixRects[i][j][2];
          int dy = pixRects[i][j][3];
          if (pixel != null) {
            image(pixel, x, y, dx, dy);
          }
        }
      }
      run = false;
    }
  } else {
    String save = subset ? "out/subset/mosaiked/n_"+n+"/n"+n+"_"+mosaikIndex : "out/mosaiked/n"+n+"_"+subTar;
    if(repeat && active && !subset) save = "out/mosaiked/n"+n+"_"+mosaikIndex;
    println(mosaikIndex + " st run done");
    saveFrame(save);

    if (repeat) {
      reset();
      int N = subset ? files3.length : files2.length;
      if (mosaikIndex<N) {
        mosaikIndex++;
      } else {
        noLoop();
      }
      dac();
    } else {
      noLoop();
    }
  }
}

//determines chunks and instantiates threads
//the interval of the chunk is loaded into threadData at the respective thread index
void dac() {

  int xNum = n/4;
  int yNum = n/2;
  int chunkSideX = stepsX * xNum;
  int chunkSideY = stepsY * yNum;

  int cx = 0;
  int cy = 0;
  for (int x = 0; x<width && cx < 4; x+=chunkSideX) {
    for (int y = 0; y<height && cy < 2; y+=chunkSideY) {

      int beginX = x;
      int endX = chunkSideX;
      int beginY = y;
      int endY = chunkSideY;

      if (cx == 3) {
        endX+=stepsX;
      }
      //println(y);
      if (cy == 1) {
        endY+=stepsY;
      }

      //disp
      noFill();
      strokeWeight(3);
      stroke(255, 0, 0);

      int[] temp = {beginX, beginY, endX, endY};
      threadData.add(temp);
      cy++;
    }
    cy = 0;
    cx++;
  }

  //fill as many pixels as possible with matching images
  threadIndex = 0;
  delay(100);
  for (int i = 0; i<numCores; i++) {
    thread("mosaic_threaded");
    delay(50);
    threadIndex++;
  }
  threadIndex = 0;

  println("\n" +"Chunkifying done"+"\n");
}


void mosaic_threaded() {
  final int myIndex = threadIndex;
  if (fancy) {
    if (myIndex == 1 ||
      myIndex == 2 ||
      myIndex == 5 ||
      myIndex == 6) {
      threadApproxDones[myIndex] = true;
      return;
    }
  }
  final double tic = millis();
  println("mosaic thread " + myIndex + " started");
  int localIndex = 0;

  //fill as many pixels as possible with matching images
  int[] data = threadData.get(myIndex);
  int x0 = data[0];
  int y0 = data[1];
  int xLimit = x0+data[2];
  int yLimit = y0+data[3];
  PImage img;
  if (repeat) {
    img = loadImage(pixImgsNams.get(mosaikIndex));
  } else {
    img = loadImage(target);
  }
  img.resize(width, 0);
  image(img, 0, 0);
  for (int x = x0; x<xLimit; x+=stepsX) {
    for (int y = y0; y<yLimit; y+=stepsY) {
      color col = img.get(x+stepsX/2, y+stepsY/2);
      PVector req = new PVector(red(col), green(col), blue(col));
      double max = 10000;
      String winner = "failed";
      for (int i = 0; i < vals.size(); i++) {
        JSONObject json = vals.getJSONObject(i);
        PVector offer = new PVector(json.getInt("red"), json.getInt("green"), json.getInt("blue"));
        double distance = offer.sub(req).mag();
        if (distance<max) {
          max = distance;
          winner = json.getString("original file name");
        }
      }
      newPixels[myIndex][localIndex] = winner;
      pixRects[myIndex][localIndex][0] = x;
      pixRects[myIndex][localIndex][1] = y;
      pixRects[myIndex][localIndex][2] = stepsX;
      pixRects[myIndex][localIndex][3] = stepsY;
      localIndex++;
    }
  }
  threadApproxDones[myIndex] = true;
  println("mosaic thread "+myIndex+" done after " + (millis()-tic)/1000+ " s");
}

//POST: preLoadIntervals contains intervals which allow the preloadThreads to load images into allImgs
void preload() {
  println("Starting preload");
  double tic = millis();
  int s = files1.length; //s corresponds to the total workload (amount of pictures to be loaded)
  preLoadIntervals = new PVector[numCores];
  int plcs = s / numCores; //preLoadChunkSize
  int a = 0;
  int b = plcs;
  for (int i = 0; i<7; i++) {
    preLoadIntervals[i] = new PVector(a, b);
    a+=plcs;
    b+=plcs;
  }
  preLoadIntervals[7] = new PVector(b-plcs, s);

  for (int i = 0; i<numCores; i++) {
    thread("preLoad_threaded");
    delay(100); //delay to ensure the thread had time to start and set its local const copy of preLoadIndex before we increment it
    ++preLoadIndex;
  }

  //wait until all threads are done
  while (!preLoadDone) {
    preLoadDone = true;
    for (int i = 0; i<numCores; i++) {
      preLoadDone = preLoadDones[i]&&preLoadDone;
    }
  }
  println("Preload done after " + (millis()-tic)/1000 + " s");
  println();
}

void preLoad_threaded() {
  final int myPreLoadIndex = preLoadIndex;
  int start = (int)preLoadIntervals[myPreLoadIndex].x;
  int end = (int)preLoadIntervals[myPreLoadIndex].y;

  for (int i = start; i < end; i++) {
    String name = (files1[i] == null) ? "failed" : files1[i].getName();
    names[i] = name;
    String temp = "images/" + name;
    PImage Var = loadImage(temp);
    if (Var == null) println(name + " is null in preLoad threaded");
    allImgs.put(name, Var);
  }
  preLoadDones[myPreLoadIndex] = true;
  println("- "+myPreLoadIndex+" done");
}

//POST json file contains rgb values and original file name for all images from data/images
void prepare(JSONArray values, color[] imgCols, ArrayList<PImage> imgs) {
  final double tic = millis(); //const time stamp
  println("Starting passive preparation");

  for (int i = 0; i<imgs.size(); i++) {
    PImage img = imgs.get(i);
    if (img.width>img.height) { //landscape mode
      img.resize(width, 0);
    } else {
      img.resize(0, height); //portrait mode
    }
    image(img, 0, 0);
    imgCols[i] = findCol(img, stepsX/2, stepsY/2, img.width, img.height, stepsX, stepsY);
    pixelize(img, stepsX, stepsY);

    JSONObject json = new JSONObject();

    int r = (int)red(imgCols[i]);
    int g = (int)green(imgCols[i]);
    int b = (int)blue(imgCols[i]);

    json.setInt("red", r);
    json.setInt("green", g);
    json.setInt("blue", b);

    String rgb = r+ "_" + g + "_" + b;
    String saveName = subset ? "out/subset/" + "n_"+n +"/"+rgb + ".jpg" : "out/" + "n_"+n +"/"+rgb + ".jpg";
    saveFrame(saveName);
    json.setString("name", rgb);
    json.setString("original file name", names[i]);
    values.setJSONObject(i, json);
  }

  if (update)saveJSONArray(values, "out/colors.json");
  println("Prep done after " + (millis()-tic)/1000 + " s");
}

//POST res contains all images from data/images as PImage
ArrayList<PImage> loadImgs() {
  final double tic = millis();
  println("Commenced image loading");
  ArrayList<PImage>res = new ArrayList<PImage>();
  File[] files = subset ? files3 : files1;
  for (int i = 0; i < files.length; i++) {
    String name = files[i].getName();
    names[i] = name;
    String temp = "images/" + name;
    PImage Var = loadImage(temp);
    res.add(Var);
  }
  println("Image loading done after " + (millis()-tic)/1000 + " s");
  return res;
}

//POST: res contains all names of the image files in data/images
ArrayList<String> loadImgNames() {
  File[] files = subset ? files4 : files2;
  ArrayList<String>res = new ArrayList<String>();
  for (int i = 0; i < files.length; i++) {
    String name = subset ? "out/subset/n_"+n+"/" + files[i].getName() : "out/n_"+n+"/" + files[i].getName();
    res.add(name);
  }
  return res;
}

//POST: image was approximated by pixels
void pixelize(PImage img, int sX, int sY) {
  for (int x = 0; x<width; x+=sX) {
    for (int y = 0; y<height; y+=sY) {
      color col = findCol(img, x, y, sX, sY, 3, 3);
      fill(col);
      rect(x, y, sX, sY);
    }
  }
}
//POST: return average color of image segment specified by function arguments, deltaX and deltaY define precision
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
  //println("r: " + red + ",g: " + green + ",b: " + blue);
  return color(red, green, blue);
}


void reset() {
  delay(100); //threads need to get done before we call this function
  for (int i = 0; i<numCores; i++) {
    preLoadDones[i] = false;
    threadApproxDones[i] = false;
  }
  run = true; //separates cycles of creation of one mosaic
  globaldrawIndex = 0;
  threadIndex = 0;
}
