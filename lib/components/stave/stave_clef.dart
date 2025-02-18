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

  Future<void> changeClef(
      NoteData currentNoteData, NoteData newNote) async {
    if (clefChanges(currentNoteData, newNote)) {
      print('Clef changed');
      bassClefSprite.isVisible = newNote.clef.name == 'Bass';
      trebleClefSprite.isVisible = newNote.clef.name == 'Treble';
    }
  }

  bool clefChanges(NoteData currentNoteData, NoteData newNote) {
    return currentNoteData.clef.name != newNote.clef.name;
  }
}
