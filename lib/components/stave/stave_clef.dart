import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:toolkit/components/stave/stave_position_manager.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/note_data.dart';

class StaveClef extends PositionComponent {
  final PositionComponent clefHolder = PositionComponent();
  Asset trebleClefSprite = Asset.createTrebleClef()..positionSprite();
  Asset bassClefSprite = Asset.createBassClef()..positionSprite();

  late StavePositionManager positionManager;
  StaveClef(this.positionManager) {
    drawClef();
  }

  void drawClef() {
    clefHolder.position = positionManager.clefHolderPosition();
    add(clefHolder);
    clefHolder.addAll([trebleClefSprite, bassClefSprite]);
    trebleClefSprite.opacity = 0;
    bassClefSprite.opacity = 0;
  }

  Future<void> sequentialFade(
      Asset outSprite, Asset inSprite, double duration) async {
    await outSprite
        .add(OpacityEffect.fadeOut(EffectController(duration: duration)));
    await inSprite.add(OpacityEffect.fadeIn(DelayedEffectController(
        EffectController(duration: duration),
        delay: duration)));
  }

  Future<void> changeClef(
      NoteData currentNoteData, NoteData newNote, double fadeDuration) async {
    if (clefChanges(currentNoteData, newNote)) {
      if (newNote.clef.name == 'Bass') {
        await sequentialFade(trebleClefSprite, bassClefSprite, fadeDuration);
      } else {
        await sequentialFade(bassClefSprite, trebleClefSprite, fadeDuration);
      }
    }
  }

  bool clefChanges(NoteData currentNoteData, NoteData newNote) {
    return currentNoteData.clef.name != newNote.clef.name;
  }
}
