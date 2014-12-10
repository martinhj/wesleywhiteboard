import javax.swing.*;
public class PFrame extends JFrame {
  public PFrame(SecondApplet s, int width, int height) {
    setBounds(100, 100, width, height);
    add(s);
    s.init();
    show();
  }
}
