class PlaneManager {
  String planeSelection(String plane) {
    List<String> planelist = plane.split('');
    String plane1 = planelist[0];
    String plane2 = planelist[1];
    String areaElement = "d$plane1 d$plane2";
    return areaElement;
  }
}
