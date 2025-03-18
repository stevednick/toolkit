import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/key_signature/key_signature_builder_data.dart';
import 'package:toolkit/scenes/range_selection/range_selection.dart';
import 'package:toolkit/tools/config.dart';

class RangeSelectionStave extends PositionComponent {

  final RangeSelectionPositionManager positionManager;
  final KeySignatureBuilderData data = KeySignatureBuilderData();

  RangeSelectionStave(this.positionManager){
    setUp(); 
  }

  void setUp() {
      for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: Vector2(
            positionManager.extendedStaveWidth(), lineWidth),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(
          -positionManager.extendedStaveWidth()/2, i * lineGap);
      add(newLine);
    }
  }
}