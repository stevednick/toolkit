import 'dart:async';
import 'package:flame/components.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/components/stave_position_manager.dart';

class ClefManager {
  final PositionComponent parent;
  final StavePositionManager positionManager;
  final PositionComponent clefHolder = PositionComponent();
  Asset trebleClefSprite = Asset.createTrebleClef()..positionSprite();
  Asset bassClefSprite = Asset.createBassClef()..positionSprite();

  ClefManager(this.parent, this.positionManager);

  void drawClef() {
    clefHolder.position = positionManager.clefHolderPosition();
    parent.add(clefHolder);
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

  Future<void> changeClef(NoteData newNote, double fadeDuration) async {
    if (clefChanges(newNote)) {
      if (newNote.clef.name == 'Bass') {
        await sequentialFade(trebleClefSprite, bassClefSprite, fadeDuration);
      } else {
        await sequentialFade(bassClefSprite, trebleClefSprite, fadeDuration);
      }
    }
  }

  bool clefChanges(NoteData newNote) {
    return NoteData.placeholderValue.clef.name != newNote.clef.name;
  }
}
