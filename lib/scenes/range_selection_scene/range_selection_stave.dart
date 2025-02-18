import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/key_signature/key_signature_builder_data.dart';
import 'package:toolkit/scenes/range_selection_scene/range_selection_position_manager.dart';
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
            positionManager.staffWidth + (data.clefOffset(positionManager.keySignature) * 2), lineWidth),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(
          (-positionManager.staffWidth / 2) - data.clefOffset(positionManager.keySignature), i * lineGap);
      add(newLine);
    }
  }
}