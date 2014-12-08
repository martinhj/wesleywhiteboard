import gab.opencv.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Core;
import org.opencv.core.Mat;

import org.opencv.core.Mat;
import org.opencv.core.MatOfPoint;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.CvType;


import org.opencv.core.Point;
import org.opencv.core.Size;


import processing.video.*;



Capture video;



OpenCV opencv;

PImage src, dst, markerImg;

PImage dst1, dst2;


ArrayList<MatOfPoint> contours;
ArrayList<MatOfPoint2f> approximations;
ArrayList<MatOfPoint2f> markers;

ArrayList<MatOfPoint2f> nonresult;

boolean[][] markerCells;




float windowScale;
int videoWidth, videoHeight;


MarkerCodes markerCodes;


void test() {
  println("test");
}
/**
 * processing sketch main setup.
 */
void setup () {
  //setThreshold();

  videoWidth = 1280;
  videoHeight = 720;
  
  windowScale = (float) 960 / videoWidth ; // to scale down the video and window
  println(windowScale);
  int windowWidth = (int)round((videoWidth*0.7 + videoWidth*0.35) * windowScale);
  int windowHeight = (int) round((videoHeight*0.7) * windowScale);

  size(windowWidth, windowHeight);

	//video = new Capture(this, width, height, "Microsoft® LifeCam Studio(TM)", 30);
  //
	video = new Capture(this, videoWidth, videoHeight);
  opencv = new OpenCV(this, videoWidth, videoHeight);


  println(this);

  markerCodes = new MarkerCodes(this, opencv, videoWidth, videoHeight);
  markerCodes.test();
	  
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
	}
  */


  video.start();
}



/**
 * processing sketch's main loop.
 */
void draw () {
  markerCodes.readNextFrame();
  markerCodes.drawMarkerImagesUnwarped(0, 0);

}


/**
 * reads the image if there is taken a new image by the webcam.
 */
void captureEvent(Capture c) {
  c.read();
}





/*
void keyPressed() {
  switch (key) {
    case 'r':
      setThreshold();
      break;
    case 'f':
      epsMultiplier -= 0.01;
      println(epsMultiplier);
      break;
    case 'v':
      epsMultiplier += 0.01;
      println(epsMultiplier);
      break;
    case 'd':
      blurval -= 1;
      println(blurval);
      break;
    case 'c':
      blurval += 1;
      println(blurval);
      break;
    case 'a':
      thresholdval1 -= 2;
      if (thresholdval1 < 3) {
        thresholdval1 = 3;
        println("can't go lower");
      }
      println(thresholdval1);
      break;
    case 'z':
      thresholdval1 += 2;
      println(thresholdval1);
      break;
    case 's': 
      thresholdval2 -= 1;
      println(thresholdval2);
      break;
    case 'x':
      thresholdval2 += 1;
      println(thresholdval2);
      break;
    case 'A':
      thresholdval1 -= 10;
      println(thresholdval1);
      break;
    case 'Z':
      thresholdval1 += 10;
      println(thresholdval1);
      break;
    case 'S': 
      thresholdval2 -= 10;
      println(thresholdval2);
      break;
    case 'X':
      thresholdval2 += 10;
      println(thresholdval2);
      break;
  }
}
 */