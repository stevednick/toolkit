import 'package:flame/components.dart';
import 'package:toolkit/components/stave/stave_position_manager.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/tools/utils.dart';

class StaveKeySignature extends PositionComponent {
  PositionComponent keySignatureHolder = PositionComponent();
  KeySignature keySignature = KeySignature.keySignatures[0];

  late StavePositionManager positionManager;
  late Player player;
  @override
  double opacity = 1.0;


  StaveKeySignature(this.player, this.positionManager, NoteData currentNoteData){
    setUpKeySignature(currentNoteData);
  }

  Future<void> setUpKeySignature(NoteData currentNoteData) async {
    keySignature = await player.loadKeySignature();
    keySignatureHolder.position = positionManager.keySignatureHolderPosition();
    add(keySignatureHolder);
  }

  Future<void> changeKeySignature(NoteData newNote) async {  // todo add fade duration
    Utils.removeAllChildren(keySignatureHolder);
    keySignatureHolder.add(keySignature.displayKeySignature(newNote.clef));
  }
}