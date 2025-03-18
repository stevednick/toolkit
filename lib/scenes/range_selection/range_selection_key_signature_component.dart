import 'package:flame/components.dart';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signature_component.dart';
import 'package:toolkit/scenes/range_selection/range_selection.dart';

class RangeSelectionKeySignatureComponent extends PositionComponent {
  List<KeySignatureComponent> keySignatureComponents = [];

  final KeySignature keySignature;
  final RangeSelectionPositionManager positionManager;

  RangeSelectionKeySignatureComponent(this.keySignature, this.positionManager) {
    addKeySignatures();
  }


  void addKeySignatures() {
    for (int i = 0; i < 2; i++) {
      addKeySignature(i);
    }
  }

  void addKeySignature(int i){
      keySignatureComponents.add(KeySignatureComponent(keySignature));
    add(keySignatureComponents[i]);
    keySignatureComponents[i].displayKeySignature(Clef.treble());
    keySignatureComponents[i].position = positionManager.keySignaturePositions[i];
  }

  void displayKeySignature(int i, Clef clef){
    keySignatureComponents[i].displayKeySignature(clef);

  }

  // void drawKeySignatures(int i) {
  //   keySignatureHolder[i].add(keySignatureComponents[i]);
  //   List<Vector2> positions = [Vector2(-80 - positionManager.clefOffset(), 0), Vector2(150, 0)];
  //   keySignatureHolder[i].position = positions[i];
  // }

  void showBottomKeySignature(bool show) {
    keySignatureComponents[1].scale = show ? Vector2(1, 1) : Vector2.zero();
  }
}
