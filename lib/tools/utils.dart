import 'dart:math';

class Utils {

  
  /// Removes all children from the given parent widget.
  static void removeAllChildren(dynamic parent) {
    if (parent != null && parent.children != null) {
      parent.children.toList().forEach((child) {
        child.removeFromParent();
      });
    }
  }
}

// class ScaleManager{
//   final double screenWidth;
//   final double minimumAcceptableWidth = 800;

//   ScaleManager(this.screenWidth);

//   double scaleFactor(){
//     return min(screenWidth / minimumAcceptableWidth, 1);
//   }
// }

class ScaleManager {
  static final ScaleManager _instance = ScaleManager._internal();

  double _screenWidth = 1000; // Default value to prevent division by zero
  double minimumAcceptableWidth = 900;

  factory ScaleManager() {
    return _instance;
  }

  ScaleManager._internal();

  void setScreenWidth(double width) {
    _screenWidth = width;
  }

  double scaleFactor() {
    // Define your scaling logic based on screen width
    return min(_screenWidth / minimumAcceptableWidth, 1); // Example: Assuming 375 as base width
  }
}