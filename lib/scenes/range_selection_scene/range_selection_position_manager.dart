import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signature_builder_data.dart';

class RangeSelectionPositionManager {

  final KeySignatureBuilderData data = KeySignatureBuilderData();
  final double staffWidth = 450;
  late KeySignature keySignature;

  RangeSelectionPositionManager(this.keySignature, this.width){
    keySignaturePositions  = [Vector2(-80 - data.clefOffset(keySignature), 0), Vector2(150, 0)];
  }

  double width;
  double screenWidthRatio = 3;

  late List<Vector2> keySignaturePositions;

  List<Vector2> dragBoxStart(){
    return [Vector2(5, 0), Vector2(width/(screenWidthRatio*2)+ 5, 0)];
  }

  Vector2 dragBoxSize() {
    print("Width: $width");
    return Vector2(width / (screenWidthRatio * 2), 1000);
  }

    double scaleFactor() {
    return width /
        ((staffWidth + data.clefOffset(keySignature) * 2) * screenWidthRatio);
  }

  List<Vector2> notePositions = [Vector2(-75, 0), Vector2(150, 0)];
  List<Vector2> clefPositions = [Vector2(-170, 0), Vector2(50, 0)];
}
