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



/**
 * processing sketch main setup.
 */
void setup () {
  //setThreshold();
  //bitshift();
  frame.setTitle("Wesley the white board");


  videoWidth = 1280 / 2;
  videoHeight = 720 / 2;
  
  windowScale = (float) 960 / videoWidth ; // to scale down the video and window
  println(windowScale);
  PFrame secondFrame = new PFrame(s, (int)round(videoWidth * windowScale), 900);
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
  
  if (
      !markerCodes.slackMarkers.isEmpty()
      && markerCodes.angelMarkers.size() == 2
      ) {
    if (lastTimeOutput == 0) {
      lastTimeOutput = millis();
    }
    println("something in there \n\n\n");
    if (lastTimeOutput > 2000) {
      markerCodes.saveImage();
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