import 'dart:async';
import 'package:flame/components.dart';
import 'package:toolkit/models/key_signature.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/components/stave_position_manager.dart';
import 'package:toolkit/tools/utils.dart';

class KeySignatureManager {
  final PositionComponent parent;
  final StavePositionManager positionManager;
  final Player player;
  final PositionComponent keySignatureHolder = PositionComponent();
  late KeySignature keySignature;

  KeySignatureManager(this.parent, this.positionManager, this.player);

  Future<void> setUpKeySignature() async {
    keySignature = await player.loadKeySignature();
    keySignatureHolder.position = positionManager.keySignatureHolderPosition();
    keySignatureHolder.add(keySignature.displayKeySignature(NoteData.placeholderValue.clef));
    parent.add(keySignatureHolder);
  }

  Future<void> changeKeySignature(NoteData newNote) async {
    Utils.removeAllChildren(keySignatureHolder);
    keySignatureHolder.add(keySignature.displayKeySignature(newNote.clef));
  }
}
