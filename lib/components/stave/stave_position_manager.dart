
import 'package:flame/components.dart';
import 'package:toolkit/models/key_signature.dart';
import 'package:toolkit/tools/config.dart';

class StavePositionManager {
  final KeySignature keySignature;
  final double staffWidth = 280;
  final double ghostNoteExtension = 130;
  final double size;
  final bool showGhostNotes;
  StavePositionManager(this.keySignature, this.showGhostNotes, this.size);

  Vector2 staffLineSize() {
    return Vector2(
        staffWidth +
            (showGhostNotes ? ghostNoteExtension : 0) +
            keySignature.clefOffset(),
        lineWidth);
  }

  double staffLinePosX() {
    return 20 - staffWidth / 2 - keySignature.clefOffset();
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
    return Vector2(-70 - keySignature.clefOffset(), 0);
  }

  Vector2 keySignatureHolderPosition() {
    return Vector2(25 - keySignature.clefOffset(), 0);
  }

  double scaleFactor() {
    // Move this to pos Man
    return size /
        ((staffWidth +
                (showGhostNotes ? ghostNoteExtension : 0) +
                keySignature.clefOffset()));
  }
}
