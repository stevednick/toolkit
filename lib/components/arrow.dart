import 'dart:math';

import 'package:flame/components.dart';
import 'package:toolkit/models/asset.dart';

class Arrow extends PositionComponent {
  Asset image = Asset.createFeedbackArrow();
  Arrow() {
    _loadImage();
  }

  void _loadImage() {
    image.scale = Vector2.all(1);
    image.anchor = Anchor.center;
    add(image);
  }

  void setScale(double newValue) {
    print(newValue);
    image.angle = newValue > 0 ? pi : 0;
    //double newScale = min(newValue.abs()/3, 1);
    image.scale = Vector2.all(
      getScaleValue(
        newValue.abs(),
      ),
    );
  }

  double getScaleValue(double value) {
    // Ensure the input value is between 1 and 14
    if (value == 0) return 0;
    value = value.clamp(1.0, 14.0);

    // If the value is 14 or more, return 1.0 (full scale)
    if (value >= 14.0) {
      return 1.0;
    }

    // For values between 1 and 13, calculate the scale
    // We'll use a linear interpolation between 0.5 and 1.0
    double normalizedValue =
        (value - 1.0) / 13.0; // This will be between 0 and 1

    // You can adjust the curve of the scaling by modifying this line
    // Currently, it's a simple linear interpolation
    
    return 0.5 + (normalizedValue * 0.5);
  }
}
