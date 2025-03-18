import 'package:flame/components.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/scenes/range_selection/range_selection.dart';

class RangeSelectionClefComponent extends PositionComponent{

  late RangeSelectionNoteManager noteManager;

  late RangeSelectionPositionManager positionManager;

  late List<Asset?> clefSprites = [];
  List<PositionComponent> clefHolders = [
    PositionComponent(),
    PositionComponent()
  ];

  List<String> currentClefs = ["None", "None"];

  RangeSelectionClefComponent(this.noteManager, this.positionManager){
    drawClefs();
  }

  void drawClefs(){
    List<NoteData> noteData = noteManager.getNotes();
    for (var i = 0; i < 2; i++) {
      
      currentClefs[i] = noteData[i].clef.name; // todo is this necessary?
      clefSprites.add(noteData[i].clef.sprite);
      add(clefHolders[i]);
      clefHolders[i].add(clefSprites[i]!);
      clefHolders[i].position = positionManager.clefPositions[i] -
          (i == 0 ? Vector2(positionManager.clefOffset(), 0) : Vector2.zero());
      addClef(clefSprites[i], noteData[i], clefHolders[i]);
    }
  }
    

  void changeClef(Asset sprite, NoteData data, int n) {
    addClef(sprite, data, clefHolders[n]);
  }

  void addClef(Asset? sprite, NoteData data, PositionComponent clefHolder) {
    sprite = data.clef.sprite..positionSprite();
    clefHolder.children.toList().forEach((child) {
      child.removeFromParent();
    });
    clefHolder.add(sprite);
  }

  void checkAndHideBottomClef() {
    if (clefsTheSame()) {
      clefHolders[1].scale = Vector2.zero();
    } else {
      clefHolders[1].scale = Vector2(1, 1);
    }
  }

  bool clefsTheSame(){
    return currentClefs[0] == currentClefs[1];
  }

}