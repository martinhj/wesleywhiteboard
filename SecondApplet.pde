public class SecondApplet extends PApplet {
  int ghostX, ghostY;
  public void setup() {
    background(0);
    noStroke();
  }

  public void draw() {
    background(50);
    image(secondWindowImage1, 0, 0);
    image(secondWindowImage2, 0, 900/2);
    fill(255);
    ellipse(mouseX, mouseY, 10, 10);
    fill(0);
    ellipse(ghostX, ghostY, 10, 10);
  }
  public void setGhostCursor(int ghostX, int ghostY) {
    this.ghostX = ghostX;
    this.ghostY = ghostY;
  }
  public void newImage(PImage i) {
    secondWindowImage2 = secondWindowImage1;
    secondWindowImage1 = i;
  }
}
