import 'package:flutter/services.dart';

enum ScreenOrientation {
  portraitOnly,
  landscapeOnly,
  landscapeLeft,
  landscapeRight,
  rotating,
}

void setOrientation(ScreenOrientation orientation) {
  List<DeviceOrientation> orientations;
  switch (orientation) {
    case ScreenOrientation.portraitOnly:
      orientations = [
        DeviceOrientation.portraitUp,
      ];
      break;
    case ScreenOrientation.landscapeOnly:
      orientations = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
    case ScreenOrientation.rotating:
      orientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      break;
    case ScreenOrientation.landscapeLeft:
      orientations = [
        DeviceOrientation.landscapeLeft,
      ];
      break;
      case ScreenOrientation.landscapeRight:
      orientations = [
        DeviceOrientation.landscapeRight,
      ];
      break;
  }
  SystemChrome.setPreferredOrientations(orientations);
}