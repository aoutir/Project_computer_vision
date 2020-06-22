import processing.video.*;
import java.util.List;
import gab.opencv.*;

class ImageProcessing extends PApplet{
OpenCV opencv;
//Capture cam; //for cam 
Movie cam;
int width = 800;
int height = 600;
PImage img;
BlobDetection detector;
int threshold;
PVector rotations=new PVector(0f, 0f, 0f);



void settings() {
  size(1000, 500);
  opencv = new OpenCV(this, 100, 100);
}

void setup() {
  //for cam 
  /*
  String[] cameras = Capture.list();
     if (cameras.length == 0) {
     println("There are no cameras available for capture.");
     exit();
     } else {
     println("Available cameras:");
     for (int i = 0; i < cameras.length; i++) {
     println(cameras[i]);
     }
     cam = new Capture(this, 640, 480, cameras[0]);
     
     cam.start();
     }
    */ 
  cam = new Movie(this, "C:/Users/hafsa/Downloads/Game4/testvideo.avi");
  cam.loop();
  
  rotations = new PVector(0f, 0f, 0f);
}
void draw() {
  
  if (cam.available() == true) {
      cam.read();
    }
    img = cam.get();

 
  PImage ImgHough = img.copy();
  image(ImgHough, 0, 0); 
  
  //Hue/Brightness/Saturation thresholding
  ImgHough = thresholdHSB(ImgHough, 90, 140, 60, 255, 30, 180);

  ////Blurring
  ImgHough=convolute(ImgHough);

  //BlobDetection
  detector = new BlobDetection();
  ImgHough = detector.findConnectedComponents(ImgHough, true);

  ///Edge detection
  ImgHough = scharr(ImgHough);

  //suppression of pixels with low brightness 
  ImgHough = thresholdBrightness(ImgHough, 200);


  //hough transform 
  List<PVector> lines = hough(ImgHough, 6);
 
 
  for (int idx = 0; idx < lines.size(); idx++) {
    PVector line=lines.get(idx);
    float r = line.x;
    float phi = line.y;
    // Cartesian equation of a line: y = ax + b
    // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
    // => y = 0 : x = r / cos(phi)
    // => x = 0 : y = r / sin(phi)
    // compute the intersection of this line with the 4 borders of
    // the image
    int x0 = 0;
    int y0 = (int) (r / sin(phi));
    int x1 = (int) (r / cos(phi));
    int y1 = 0;
    int x2 = img.width;
    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
    int y3 = img.width;
    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
    // Finally, plot the lines
    stroke(204, 102, 0);
    if (y0 > 0) {
      if (x1 > 0)
        line(x0, y0, x1, y1);
      else if (y2 > 0)
        line(x0, y0, x2, y2);
      else
        line(x0, y0, x3, y3);
    } else {
      if (x1 > 0) {
        if (y2 > 0)
          line(x1, y1, x2, y2);
        else
          line(x1, y1, x3, y3);
      } else
        line(x2, y2, x3, y3);
    }
  }
  QuadGraph qg = new QuadGraph();
  List<PVector> coins = qg.findBestQuad(lines, img.width, img.height, img.width*img.height, 0, true);
  fill(125, 125, 0, 100);
  for (PVector p : coins) {
    ellipse(p.x, p.y, 10, 10);
    p.set(p.x, p.y, 1f);
  }
      
    TwoDThreeD transform = new TwoDThreeD(img.width, img.height, 0);
    rotations = transform.get3DRotations(coins);
    rotations.set(boundAngle(rotations.x),boundAngle(rotations.y),boundAngle(rotations.z)); 

}

float boundAngle (double a) {
  if (a > PI/2.0) a = a - PI;
  else if (a < -PI/2.0) a = a + PI;
  return (float)a;
 }


PImage thresholdBrightness(PImage img, int brightness) {
  PImage result = createImage(img.width, img.height, RGB); // create a new, initially transparent, 'result' image
  result.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    if (brightness(img.pixels[i])> brightness) {
      result.pixels[i]= img.pixels[i];
    } else {
      result.pixels[i]=0;
    }
  } 
  result.updatePixels();
  return result;
}
PImage thresholdHUE(PImage img, int hueMin, int hueMax) {
  PImage result = createImage(img.width, img.height, RGB);
  result.loadPixels();
  for (int i = 0; i < img.width * img.height; i++) {
    if (hue(img.pixels[i])>=hueMin && hue(img.pixels[i])<=hueMax) {
      result.pixels[i]= color(img.pixels[i]);
    }
  } 
  result.updatePixels();
  return result;
}

PImage thresholdHSB(PImage img, int minH, int maxH, int minS, int maxS, int minB, int maxB) {

  PImage result = createImage(img.width, img.height, RGB);
  float v = 0 ;
  result.loadPixels() ;
  for (int i = 0; i < img.width * img.height; i++) {
    v= hue(img.pixels[i]) ;
    if ( brightness(img.pixels[i]) < minB || brightness(img.pixels[i]) > maxB ||
      saturation(img.pixels[i]) < minS || saturation(img.pixels[i]) > maxS ||
      v < minH || v > maxH) 
    {
      result.pixels[i] = color(0);
    } else {
      result.pixels[i] = color(255) ;
    }
  }
  result.updatePixels();
  return result;
}

boolean imagesEqual(PImage img1, PImage img2) {
  if (img1.width != img2.width || img1.height != img2.height) {
    return false;
  }
  for (int i = 0; i < img1.width*img1.height; i++)
    //assuming that all the three channels have the same value
    if (red(img1.pixels[i]) != red(img2.pixels[i])) {
      return false;
    }
  return true;
}

PImage thresholdBinary(PImage img, int threshold) {
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  img.loadPixels() ;
  for (int i = 0; i < img.width * img.height; i++) {
    if (brightness(img.pixels[i]) > threshold) {
      result.pixels[i] = color(255) ;
    } else {
      result.pixels[i] = color(0, 0, 0);
    }
  }
  result.updatePixels();
  return result;
}

PImage thresholdBinaryInverted(PImage img, int threshold) {
  // create a new, initially transparent, 'result' image
  PImage result = createImage(img.width, img.height, RGB);
  img.loadPixels() ;
  for (int i = 0; i < img.width * img.height; i++) {
    if (brightness(img.pixels[i]) > threshold) {
      result.pixels[i] = color(0, 0, 0);
    } else {
      result.pixels[i] = color(255) ;
    }
  }
  result.updatePixels();
  return result;
}

PImage convolute(PImage img) {
  float[][] kernel = { { 9, 12, 9 }, 
    { 12, 15, 12 }, 
    { 9, 12, 9 }};

  float normFactor = 99.f;
  // create a greyscale image (type: ALPHA) for output
  PImage result = createImage(img.width, img.height, ALPHA);
  result.loadPixels();

  for (int i = 0; i< result.height; ++i) {
    for (int j =0; j<result.width; ++j) {
      if (i%(result.height-1) != 0 && j%(result.width-1) != 0) {
        int res = 0;
        for (int col= -kernel.length/2; col<= kernel.length/2; ++col ) {
          for (int row = -kernel.length/2; row<= kernel.length/2; ++row) {
            int index = (i+ col)*img.width + j + row ; 
            res += (brightness(img.pixels[index])*kernel[col+kernel.length/2][row+kernel.length/2]);
          }
        }  
        res = (int)(res/normFactor);
        result.pixels[i*result.width +j]=color(res);
      }
    }
  }
  result.updatePixels();
  return result;
}




PImage scharr(PImage img) {

  float[][] vKernel = {
    { 3, 0, -3 }, 
    { 10, 0, -10 }, 
    { 3, 0, -3 }};

  float[][] hKernel = {
    { 3, 10, 3}, 
    { 0, 0, 0}, 
    { -3, -10, -3 } };

  PImage result = createImage(img.width, img.height, ALPHA);

  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }


  float max=0;

  float[] buffer = new float[img.width * img.height];

  // *************
  // Implement here the double convolution
  // *************

  for (int i = 1; i< result.height -1; ++i) {
    for (int j = 1; j<result.width -1; ++j) {
      float sum ;  
      int sum_v = 0;
      int sum_h = 0;
      for (int col= -vKernel.length/2; col<= vKernel.length/2; ++col ) {
        for (int row = -vKernel.length/2; row<=vKernel.length/2; ++row) {
          int index =(i+col)*img.width +j+row;

          sum_v += (brightness(img.pixels[index])*vKernel[col+vKernel.length/2][row+vKernel.length/2]);
          sum_h += (brightness(img.pixels[index])*hKernel[col+vKernel.length/2][row+vKernel.length/2]);
        }
      }  

      sum = (sqrt(pow(sum_h, 2) + pow(sum_v, 2)));
      if (sum > max) { 
        max = sum ;
      }

      buffer[i*result.width +j]=sum;
    }
  }

  for (int y = 1; y < img.height - 1; y++) { // Skip top and bottom edges 
    for (int x = 1; x < img.width - 1; x++) { // Skip left and right
      int val=(int) ((buffer[y * img.width + x] / max)*255);
      result.pixels[y * img.width + x]=color(val);
    }
  }

  return result;
}
PVector getRotations() {
    return rotations;
  }
  
}
