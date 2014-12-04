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

ArrayList<MatOfPoint> contours;
ArrayList<MatOfPoint2f> approximations;
ArrayList<MatOfPoint2f> markers;

ArrayList<MatOfPoint2f> nonresult = new ArrayList<MatOfPoint2f>();

boolean[][] markerCells;

/*
int thresholdval1 = 451;
int thresholdval2 = -65;
*/
int thresholdval1 = 7;
int thresholdval2 = 7;
int blurval = 5;
float epsMultiplier = 0.01;
float windowScale;

int videoWidth, videoHeight;


/**
 * processing sketch main setup.
 */
void setup () {
  videoWidth = 1280;
  videoHeight = 720;
  //videoWidth = 960;
  //videoHeight = 540;
  windowScale = (float) 960 / videoWidth ;
  println(windowScale);
  int windowWidth = (int)round((videoWidth*0.7 + videoWidth*0.35) * windowScale);
  int windowHeight = (int) round((videoHeight*0.7) * windowScale);

  size(windowWidth, windowHeight);
	//video = new Capture(this, width, height, "Microsoft® LifeCam Studio(TM)", 30);
	video = new Capture(this, videoWidth, videoHeight);
  opencv = new OpenCV(this, videoWidth, videoHeight);
	  
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
  
  opencv.loadImage(video);
  src = video;



  Mat gray = OpenCV.imitate(opencv.getGray());
  opencv.getGray().copyTo(gray);


  Mat thresholdMat = OpenCV.imitate(opencv.getGray());

	

  opencv.blur(blurval);

	
  Imgproc.adaptiveThreshold(opencv.getGray(), thresholdMat,
      255, Imgproc.ADAPTIVE_THRESH_GAUSSIAN_C, Imgproc.THRESH_BINARY_INV,
      thresholdval1, thresholdval2);


	PImage dst3 = createImage(videoWidth, videoHeight, RGB);
	opencv.toPImage(thresholdMat, dst3);

  contours = new ArrayList<MatOfPoint>();
  Imgproc.findContours(thresholdMat, contours, new Mat(), Imgproc.RETR_LIST,
      Imgproc.CHAIN_APPROX_NONE);
	PImage dst4 = createImage(videoWidth, videoHeight, RGB);
	opencv.toPImage(thresholdMat, dst4);

  approximations = createPolygonApproximations(contours);

  markers = new ArrayList<MatOfPoint2f>();
  markers = selectMarkers(approximations);







  MatOfPoint2f canonicalMarker = new MatOfPoint2f();
  Point[] canonicalPoints = new Point[4];
  canonicalPoints[0] = new Point(0, 350);
  canonicalPoints[1] = new Point(0, 0);
  canonicalPoints[2] = new Point(350, 0);
  canonicalPoints[3] = new Point(350, 350);
  canonicalMarker.fromArray(canonicalPoints);

  if (!markers.isEmpty()) println("num points: " + markers.get(0).height());

  Mat transform;
  /*
   * this lines need to do an loop to check all markers.
   */
  println("running for loop: " + frameCount);
  println("number of markers found: " + markers.size());
  for (MatOfPoint2f marker : markers) {
    transform = Imgproc.getPerspectiveTransform(marker, canonicalMarker);
    Mat unWarpedMarker = new Mat(50, 50, CvType.CV_8UC1);  
    Imgproc.warpPerspective(gray, unWarpedMarker, transform, new Size(350, 350));



    /*draw out markers */
    PImage dst1 = createImage(350, 350, RGB);
    opencv.toPImage(unWarpedMarker, dst1);
    pushMatrix();
    scale(0.4);
    image(dst1, 0, videoHeight*1.4);
    popMatrix();
    PImage dst2 = createImage(350, 350, RGB);
    opencv.toPImage(marker, dst2);
    pushMatrix();
    scale(0.4);
    image(dst2, videoWidth, videoHeight*1.4);
    popMatrix();



    Imgproc.threshold(unWarpedMarker, unWarpedMarker, 125, 255,
        Imgproc.THRESH_BINARY | Imgproc.THRESH_OTSU);

    float cellSize = 350/7.0;

    markerCells = new boolean[7][7];

    for (int row = 0; row < 7; row++) {
      for (int col = 0; col < 7; col++) {
        int cellX = int(col*cellSize);
        int cellY = int(row*cellSize);

        Mat cell = unWarpedMarker.submat(cellX, cellX +(int)cellSize, cellY, 
            cellY+ (int)cellSize); 
        markerCells[row][col] = (Core.countNonZero(cell) > (cellSize*cellSize)/2);
      }
    }

    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 7; row++) {
        if (markerCells[row][col]) {
          print(1);
        } 
        else {
          print(0);
        }
      }
      println();
    }
    println();
  }
  // end for loop




  /*
  if (!markers.isEmpty()) { 
    transform = Imgproc.getPerspectiveTransform(markers.get(0), canonicalMarker);
    Mat unWarpedMarker = new Mat(50, 50, CvType.CV_8UC1);  
    Imgproc.warpPerspective(gray, unWarpedMarker, transform, new Size(350, 350));
		if (markers.size() >= 1) {
			PImage dst1 = createImage(350, 350, RGB);
			opencv.toPImage(unWarpedMarker, dst1);
			pushMatrix();
			scale(0.4);
			image(dst1, 0, videoHeight*1.4);
			popMatrix();
			PImage dst2 = createImage(350, 350, RGB);
			opencv.toPImage(markers.get(0), dst2);
			pushMatrix();
			scale(0.4);
			image(dst2, videoWidth, videoHeight*1.4);
			popMatrix();
		}


    Imgproc.threshold(unWarpedMarker, unWarpedMarker, 125, 255,
        Imgproc.THRESH_BINARY | Imgproc.THRESH_OTSU);

    float cellSize = 350/7.0;

    markerCells = new boolean[7][7];

    for (int row = 0; row < 7; row++) {
      for (int col = 0; col < 7; col++) {
        int cellX = int(col*cellSize);
        int cellY = int(row*cellSize);

        Mat cell = unWarpedMarker.submat(cellX, cellX +(int)cellSize, cellY, 
            cellY+ (int)cellSize); 
        markerCells[row][col] = (Core.countNonZero(cell) > (cellSize*cellSize)/2);
      }
    }

    for (int col = 0; col < 7; col++) {
      for (int row = 0; row < 7; row++) {
        if (markerCells[row][col]) {
          print(1);
        } 
        else {
          print(0);
        }
      }
      println();
    }

    dst  = createImage(350, 350, RGB);
    opencv.toPImage(unWarpedMarker, dst);

  } else {
    dst = null;   // removes image of tag so it's not printed when it's not detected.
  }
  */

  /*
   * draw source video
   */
  pushMatrix();
  scale(windowScale);
  scale(0.7);
  image(src, 0, 0);
  noFill();
  smooth();
  strokeWeight(5);
  stroke(0, 0, 255);
  drawContours2f(approximations);
  stroke(255, 0, 0);
  drawContours2f(nonresult);
  stroke(0, 255, 0);
  drawContours2f(markers);  
  popMatrix();

  /*
   * draw binarization video
   */
  pushMatrix();
  scale(windowScale);
  translate(videoWidth*0.7, 0);
  scale(0.35);
  image(dst3, 0, 0);
  stroke(0, 255, 0);
  drawContours2f(markers);  
  popMatrix();

  /*
   * draw contours video
   */
  pushMatrix();
  scale(windowScale);
  translate(videoWidth*0.7, 0);
  scale(0.35);
  translate(0, videoHeight);
  image(dst4, 0, 0);
  stroke(0, 255, 0);
  drawContours2f(markers);  
  popMatrix();

  /*
   * draw tags in video
   */
  pushMatrix();
  scale(0.5);
  translate(0, 0);
  strokeWeight(1);
  if (null != dst) {
    image(dst, 0, 0);
		float cellSize = dst.width/7.0;
	}



	/*
  for (int col = 0; col < 7; col++) {
    for (int row = 0; row < 7; row++) {
      if(markerCells[row][col]){
        fill(255);
      } else {
        fill(0);
      }
      stroke(0,255,0);
      rect(col*cellSize, row*cellSize, cellSize, cellSize);
      //line(i*cellSize, 0, i*cellSize, dst.width);
      //line(0, i*cellSize, dst.width, i*cellSize);
    }
  }
	*/

  popMatrix();


}


/**
 * reads the image if there is taken a new image by the webcam.
 */
void captureEvent(Capture c) {
  c.read();
}



/**
 *
 */
ArrayList<MatOfPoint2f> selectMarkers(ArrayList<MatOfPoint2f> candidates) {
  float minAllowedContourSide = 25;
  minAllowedContourSide = minAllowedContourSide * minAllowedContourSide;

  ArrayList<MatOfPoint2f> result = new ArrayList<MatOfPoint2f>();
  nonresult = new ArrayList<MatOfPoint2f>();

  for (MatOfPoint2f candidate : candidates) {
		//println(candidate.size().height);

    if (candidate.size().height != 4) {
			nonresult.add(candidate);
      continue;
    } 

    if (!Imgproc.isContourConvex(new MatOfPoint(candidate.toArray()))) {
      continue;
    }

    // eliminate markers where consecutive
    // points are too close together
    float minDist = src.width * src.width;
    Point[] points = candidate.toArray();
    for (int i = 0; i < points.length; i++) {
      Point side = new Point(points[i].x - points[(i+1)%4].x,
          points[i].y - points[(i+1)%4].y);
      float squaredLength = (float)side.dot(side);
      // println("minDist: " + minDist  + " squaredLength: " +squaredLength);
      minDist = min(minDist, squaredLength);
    }

    //  println(minDist);


    if (minDist < minAllowedContourSide) {
      continue;
    }

    result.add(candidate);
  }
	

  return result;
}



/**
 *
 */
ArrayList<MatOfPoint2f> createPolygonApproximations(ArrayList<MatOfPoint> cntrs) {
  ArrayList<MatOfPoint2f> result = new ArrayList<MatOfPoint2f>();

	if (!cntrs.isEmpty()) {
		double epsilon = 0;
		println(":" + epsilon);

    int counter = 0;
		for (MatOfPoint contour : cntrs) {
      epsilon = cntrs.get(counter).size().height * 0.15;
      counter++;
			MatOfPoint2f approx = new MatOfPoint2f();
			Imgproc.approxPolyDP(new MatOfPoint2f(contour.toArray()), approx,
					epsilon, true);
			result.add(approx);
		}
	}

  return result;
}



/**
 *
 */
void drawContours(ArrayList<MatOfPoint> cntrs) {
  for (MatOfPoint contour : cntrs) {
    beginShape();
    Point[] points = contour.toArray();
    for (int i = 0; i < points.length; i++) {
      vertex((float)points[i].x, (float)points[i].y);
    }
    endShape();
  }
}



/**
 *
 */
void drawContours2f(ArrayList<MatOfPoint2f> cntrs) {
  for (MatOfPoint2f contour : cntrs) {
    beginShape();
    Point[] points = contour.toArray();

    for (int i = 0; i < points.length; i++) {
      vertex((float)points[i].x, (float)points[i].y);
    }
    endShape(CLOSE);
  }
}


void keyPressed() {
  switch (key) {
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