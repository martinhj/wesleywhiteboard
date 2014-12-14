import gab.opencv.*;


import processing.video.*;



Capture video;
OpenCV opencv;


SecondApplet s = new SecondApplet();
PImage secondWindowImage1 = createImage(1280, 720, RGB);
PImage secondWindowImage2 = createImage(1280, 720, RGB);


float windowScale;
int videoWidth, videoHeight;


int lastTimeOutput = 0;


MarkerCodes markerCodes;
ArrayList<MarkerCode> markerCodesResult;

ArrayList<MatOfPoint2f> angelMarkers = new ArrayList<MatOfPoint2f>();
ArrayList<MatOfPoint2f> slackMarkers = new ArrayList<MatOfPoint2f>();
PImage imageForSaving = createImage(videoWidth, videoHeight, RGB);


/**
 * processing sketch main setup.
 */
void setup () {
  //setThreshold();
  //bitshift();
  frame.setTitle("Wesley the white board");


  videoWidth = 1920;
  videoHeight = 1080;
  
  windowScale = (float) 960 / videoWidth ; // to scale down the video and window
  println(windowScale);
  PFrame secondFrame = new PFrame(s, (int)round(videoWidth * windowScale * windowScale), 900);
  secondFrame.setTitle("Wesley output");
  int windowWidth = (int)round((videoWidth*0.7 + videoWidth*0.35) * windowScale);
  int windowHeight = (int) round((videoHeight*0.7) * windowScale);

  size(windowWidth, windowHeight);

	video = new Capture(this, videoWidth, videoHeight, "Microsoft® LifeCam Studio(TM)", 30);
	//video = new Capture(this, videoWidth, videoHeight);
  opencv = new OpenCV(this, videoWidth, videoHeight);



  markerCodes = new MarkerCodes(this, opencv, videoWidth, videoHeight);
	  
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
  //markerCodes.drawMarkerImagesUnwarped(0, 0);
  markerCodesResult = markerCodes.getMarkerCodes();
  checkMarkers();
    /*
     * draw source video
     */
    frame.setTitle("" + frameRate);
    pushMatrix();
    scale(windowScale);
    scale(0.7);
    smooth();
    image(markerCodes.src, 0, 0);
    //s.newImage(dst3);
    strokeWeight(5);
    stroke(0, 0, 255);
    //drawContours2f(approximations);
    fill(0, 0, 255, 75);
    if (angelMarkers.size() == 2) {
      markerCodes.drawAngelsRectangel(angelMarkers);
      println("\n\n\n*****");
    }
    noFill();
    stroke(255, 0, 0);
    markerCodes.drawContours2f(slackMarkers);
    stroke(0, 255, 0);
    markerCodes.drawContours2f(angelMarkers);
    //drawContours2f(markers);  
    popMatrix();

    /*
     * draw binarization video
     */
    pushMatrix();
    scale(windowScale);
    translate(videoWidth*0.7, 0);
    scale(0.35);
    image(markerCodes.dst3, 0, 0);
    stroke(0, 255, 0);
    markerCodes.drawContours2f(markerCodes.getMarkers());
    popMatrix();

    /*
     * draw contours video
     */
    pushMatrix();
    scale(windowScale);
    translate(videoWidth*0.7, 0);
    scale(0.35);
    translate(0, videoHeight);
    image(markerCodes.dst4, 0, 0);
    stroke(0, 255, 0);
    markerCodes.drawContours2f(markerCodes.getMarkers());
    popMatrix();
  
  if (
      !slackMarkers.isEmpty()
      && angelMarkers.size() == 2
      ) {
    if (lastTimeOutput == 0) {
      lastTimeOutput = millis();
    }
    println("something in there \n\n\n");
    if (lastTimeOutput > 2000) {
      saveImage();
    }
  } else {
    lastTimeOutput = 0;
  }
  
}



/**
 * reads the image if there is taken a new image by the webcam.
 */
void captureEvent(Capture c) {
  c.read();
}





void keyPressed() {
  switch (key) {
    case 'r':
      markerCodes.setThreshold();
      break;
    case 'f':
      markerCodes.epsMultiplier -= 0.01;
      println(markerCodes.epsMultiplier);
      break;
    case 'v':
      markerCodes.epsMultiplier += 0.01;
      println(markerCodes.epsMultiplier);
      break;
    case 'd':
      markerCodes.blurval -= 1;
      println(markerCodes.blurval);
      break;
    case 'c':
      markerCodes.blurval += 1;
      println(markerCodes.blurval);
      break;
    case 'a':
      markerCodes.thresholdval1 -= 2;
      if (markerCodes.thresholdval1 < 3) {
        markerCodes.thresholdval1 = 3;
        println("can't go lower");
      }
      println(markerCodes.thresholdval1);
      break;
    case 'z':
      markerCodes.thresholdval1 += 2;
      println(markerCodes.thresholdval1);
      break;
    case 's': 
      markerCodes.thresholdval2 -= 1;
      println(markerCodes.thresholdval2);
      break;
    case 'x':
      markerCodes.thresholdval2 += 1;
      println(markerCodes.thresholdval2);
      break;
    case 'A':
      markerCodes.thresholdval1 -= 10;
      println(markerCodes.thresholdval1);
      break;
    case 'Z':
      markerCodes.thresholdval1 += 10;
      println(markerCodes.thresholdval1);
      break;
    case 'S': 
      markerCodes.thresholdval2 -= 10;
      println(markerCodes.thresholdval2);
      break;
    case 'X':
      markerCodes.thresholdval2 += 10;
      println(markerCodes.thresholdval2);
      break;
  }
}



boolean isAngelMarker(int markerCode) {

  int [] markers = {
    30505948,
    17260279,
    31389121,
    24894928,
    1537981,
    30373981,
    24395239,
    24894928,
    30373981,
    24894928,
    7847191,
    31389120,
    24894960,
    24894928,
    31389120,
    31389632,
    24894912,
    515831,
    17293047,
    30505948,
    30373980,
    489405,
    1013693


  };
  for (int m : markers) {
    if (markerCode == m) return true;
  }
  return false;
}





boolean isSlackOutputMarker (int markerCode) {
  int [] markers = {
    32501201,
    15723985,
    23571958,
    14642125,
    18313198,
    16772561,
    16772560,
    33418704,
    16772592,
    32378880,
    15723969,
    16772544,
    32378880,
    32501201,
    33418705
  };
  for (int m : markers) {
    if (markerCode == m) return true;
  }
  return false;
}

void checkMarkers() {
  angelMarkers.clear();
  slackMarkers.clear();
    angelMarkers.clear();
    MarkerCode mc;
    for (int i = 0; i < markerCodesResult.size(); i++) {
      mc = markerCodesResult.get(i);
      if (isAngelMarker(mc.getCode())) {
        angelMarkers.add(mc.getMat());
      }
    }
    // end for loop
    slackMarkers.clear();
    for (int i = 0; i < markerCodesResult.size(); i++) {
      mc =markerCodesResult.get(i);
      if (isSlackOutputMarker(mc.getCode())) {
        slackMarkers.add(mc.getMat());
      }
    }
}



  void saveImage() {
    saveImage(angelMarkers);
  }
  void saveImage(ArrayList<MatOfPoint2f> am) {
    int x, y, width, height;
    x = 10;
    y = 11;
    width = 300;
    height = 300;
    if (am.get(0).toArray()[0].x < am.get(1).toArray()[0].x) {
      x = (int)am.get(0).toArray()[0].x;
      width = (int) am.get(1).toArray()[0].x - x;
    } else {
      x = (int)am.get(1).toArray()[0].x;
      width = (int) am.get(0).toArray()[0].x - x;
    }
    if (am.get(0).toArray()[0].y < am.get(1).toArray()[0].y) {
      y = (int)am.get(0).toArray()[0].y;
      height = (int) am.get(1).toArray()[0].y - y;
    } else {
      y = (int)am.get(1).toArray()[0].y;
      height = (int) am.get(0).toArray()[0].y - y;
    }
    println("x: " + x + "| y: " + y + "| w: " + width + "| h: " + height);
    println("x: " + x + "| y: " + y + "| w: " + abs(width) + "| h: " + abs(height));
    scale(windowScale);
    imageForSaving = createImage(videoWidth, videoHeight, RGB);
    imageForSaving.copy(markerCodes.src, x, y, width, height, 0, 0, width, height);

    //image(imageForSaving, 0, 0);
    imageForSaving.save("output" + frameCount + ".jpg");
    s.newImage(imageForSaving);

    imageForSaving = createImage(videoWidth, videoHeight, RGB);
    imageForSaving.copy(markerCodes.dst3, x, y, width, height, 0, 0, width, height);
    s.newContour(imageForSaving);
    scale(0.7);
    rect(x, y, width, height);
    rect(x, y, abs(width), abs(height));


  }





void bitshift() {
  // 0000 0000 0000 1111

  int bitmask = 0x000E;
  bitmask += 1;
  int val = 0xFFFFFFF;
  println(val);
  ///*
  int bitmasks[] = new int[28];
  for (int i = 0; i < bitmasks.length; i++) {
    bitmasks[i] = 1 << i;
    println(Integer.toBinaryString(bitmasks[i]));
  }
  println("-");
  //*/
  System.out.println(Integer.toBinaryString(val));
  System.out.println(Integer.toBinaryString(bitmasks[27]));
  val = 0xFFFFFFF ^ bitmasks [27] ^ bitmasks[26] ^ bitmasks[25];
  System.out.println(Integer.toBinaryString(val));

  //System.out.println(Integer.toBinaryString(val & bitmask));
}