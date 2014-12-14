public class SecondApplet extends PApplet {
  int ghostX, ghostY;
  int lastTimeChangedImage = 0;
  int lastTimeChangedContour = 0;
  public void setup() {
    background(0);
    noStroke();
  }

  public void draw() {
    background(50);
    image(secondWindowImage1, 0, 0);
    image(secondWindowImage2, 0, 900/2);
  }
  public void newImage(PImage i) {
    secondWindowImage1 = i;
    lastTimeChangedImage = millis();
  }
  public void newContour(PImage i) {
    secondWindowImage2 = i;
    lastTimeChangedContour = millis();
  }
}
