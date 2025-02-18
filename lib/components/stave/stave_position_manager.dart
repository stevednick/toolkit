
import 'package:flame/components.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signature_builder_data.dart';
import 'package:toolkit/tools/config.dart';

class StavePositionManager {
  final KeySignature keySignature;
  final KeySignatureBuilderData data = KeySignatureBuilderData();
  final double staffWidth = 280;
  final double ghostNoteExtension = 130;
  final double size;
  final bool showGhostNotes;
  StavePositionManager(this.keySignature, this.showGhostNotes, this.size);

  Vector2 staffLineSize() {

    return Vector2(
        staffWidth +
            (showGhostNotes ? ghostNoteExtension : 0) +
            data.clefOffset(keySignature),
        lineWidth);
  }

  double staffLinePosX() {
    return 20 - staffWidth / 2 - data.clefOffset(keySignature);
  }

  Vector2 notePosition() {
    return Vector2(40, 0);
  }

  Vector2 ghostNotePosition() {
    return Vector2(180, 0);
  }

  Vector2 bouncyBallPosition() {
    return notePosition() + Vector2(80, -70);
  }

  Vector2 clefHolderPosition() {
    return Vector2(-70 - data.clefOffset(keySignature), 0);
  }

  Vector2 keySignatureHolderPosition() {
    return Vector2(25 - data.clefOffset(keySignature), 0);
  }

  double scaleFactor() {
    // Move this to pos Man
    return size /
        ((staffWidth +
                (showGhostNotes ? ghostNoteExtension : 0) +
                data.clefOffset(keySignature)));
  }
}
