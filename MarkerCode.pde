class MarkerCode {
  private MatOfPoint2f mat;
  private int code;
  public MarkerCode(MatOfPoint2f mat, int code) {
    this.mat = mat;
    this.code = code;
  }
  public MatOfPoint2f getMat() {
    return mat;
  }
  public int getCode() {
    return code;
  }
}
