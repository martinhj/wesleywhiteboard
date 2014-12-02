import gab.opencv.*;
import processing.video.*;



Capture video;



OpenCV opencv;



/**
 * processing sketch main setup.
 */
void setup () {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);


  video.start();
}



/**
 * processing sketch's main loop.
 */
void draw () {
  scale(2);
  opencv.loadImage(video);
  image(video, 0, 0);
}


/**
 * reads the image if there is taken a new image by the webcam.
 */
void captureEvent(Capture c) {
  c.read();
}