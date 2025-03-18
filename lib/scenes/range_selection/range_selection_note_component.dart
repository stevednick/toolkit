import 'package:flame/components.dart';
import 'package:toolkit/components/note/note.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/scenes/range_selection/range_selection.dart';

class RangeSelectionNoteComponent extends PositionComponent{

  late List<Note> notes;
  late RangeSelectionNoteManager noteManager;
  late RangeSelectionPositionManager positionManager;

  RangeSelectionNoteComponent(this.noteManager, this.positionManager){
    drawNotes();
  }

  void drawNotes(){
    List<NoteData> noteData = noteManager.getNotes();
    notes = [];
    for (var i = 0; i < 2; i++) {
      notes.add(Note(noteData[i], arrowShowing: true));
      
      add(notes[i]);
    }
    positionNotes();
  }

  void positionNotes(){
    for (var i = 0; i < 2; i++) {
      notes[i].position = positionManager.notePositions[i] + noteOffset(noteManager.getNotes(), i);
    }
  }

  void changeNote(int i, NoteData noteData){
    notes[i].changeNote(noteData);
  }

  Vector2 noteOffset(List<NoteData> noteData, int i){
    print(noteData[0].clef.name);
    print(noteData[1].clef.name);
    if (i == 1) {
        return (noteData[0].clef.name != noteData[1].clef.name)
            ? Vector2(positionManager.clefOffset(), 0)
            : Vector2.zero();
      }
      return Vector2.zero();
  }
}
