import 'package:toolkit/models/key_signature/key_signature_note_modifier.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/scenes/range_selection/range_selection.dart';
import 'package:toolkit/tools/note_generator.dart';

class RangeSelectionNoteManager {
  final NoteGenerator noteGenerator = NoteGenerator();
  late KeySignatureNoteModifier keySignatureNoteModifier;
  late Player player;
  late bool isClefThresholds;

  late RangeSelectionKeySignatureComponent keySignatureComponent;

  late RangeSelectionNoteComponent noteComponent;

  late RangeSelectionDataManager dataManager;

  late RangeSelectionClefComponent clefComponent;

  final RangeSelectionBarLine barLine;

  RangeSelectionNoteManager(this.keySignatureNoteModifier, this.player, this.isClefThresholds, this.keySignatureComponent, this.barLine);

  List<NoteData> getNotes() {
    List<NoteData> noteData = [
      keySignatureNoteModifier.modifyNote(
          noteGenerator.getNextAvailableNote(player.range.top, false, player),
          rangeSelection: true),
      keySignatureNoteModifier.modifyNote(
          noteGenerator.getNextAvailableNote(
              player.range.bottom, false, player),
          rangeSelection: true)
    ];
    if (isClefThresholds) {
      noteData = [
        NoteData.findFirstChoiceByNumber(
            player.clefThreshold.trebleClefThreshold, Clef.treble()),
        NoteData.findFirstChoiceByNumber(
            player.clefThreshold.bassClefThreshold, Clef.bass())
      ];
    }
    return noteData;
  }
  bool isValidChange(bool isTop, bool up) {
    return noteGenerator.checkValidChange(player, isTop, up);
  }

  void onClefChange() {
    keySignatureComponent.displayKeySignature(0, getNotes()[0].clef);
    keySignatureComponent.displayKeySignature(1, getNotes()[1].clef);
    noteComponent.positionNotes();
  }

  void changeValue(bool isTop, bool up) {
    dataManager.changeValue(isTop, up);
    changeNote(isTop);
  }

  void changeNote(bool isTop) {
    List<NoteData> data = getNotes();

    for (var i = 0; i < 2; i++) {
      noteComponent.changeNote(i, data[i]);

      if (data[i].clef.name != clefComponent.currentClefs[i]) {  // todo move to clef component
        clefComponent.changeClef(clefComponent.clefSprites[i]!, data[i], i);
        clefComponent.currentClefs[i] = data[i].clef.name;
        onClefChange();
      }
    }
    checkAndHideBottomClef();
  }

  void checkAndHideBottomClef() {
    clefComponent.checkAndHideBottomClef();
    onClefChange();
    keySignatureComponent.showBottomKeySignature(!clefComponent.clefsTheSame());
    if (clefComponent.clefsTheSame()) {
      barLine.showLine(true);
    } else {
      barLine.showLine(false);
    }
  }
}
