import 'package:flame/components.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signature_builder_data.dart';

class RangeSelectionPositionManager extends PositionComponent {
  final KeySignatureBuilderData data = KeySignatureBuilderData();
  final double staffWidth = 450;
  late KeySignature keySignature;

  RangeSelectionPositionManager(this.keySignature, this.width) {
    keySignaturePositions = [Vector2(-80 - data.clefOffset(keySignature), 0), Vector2(150, 0)];
    //addDebugBoxes();
    print("Width: $width");
  }

  @override
  double width;
  double screenWidthRatio = 3;

  late List<Vector2> keySignaturePositions;

  List<Vector2> dragBoxStart() {
    return [Vector2(0, 0), Vector2(width / 2, 0)];
  }

  Vector2 dragBoxSize() {
    return Vector2(width / 2, 1000);
  }

  double clefOffset() {
    return data.clefOffset(keySignature);
  }

  double scaleFactor() {
    return extendedStaveWidth() / width;
  }

  double extendedStaveWidth() {
    return staffWidth + (data.clefOffset(keySignature) * 2);
  }

  List<Vector2> notePositions = [Vector2(-75, 0), Vector2(150, 0)];
  List<Vector2> clefPositions = [Vector2(-170, 0), Vector2(50, 0)];

}
