import 'package:flame/components.dart';
import 'package:toolkit/components/note/note.dart';
import 'package:toolkit/components/stave/stave_clef.dart';
import 'package:toolkit/mixins/fadeable.dart';
import 'package:toolkit/models/key_signature/key_signature_component.dart';
import 'package:toolkit/models/key_signature/key_signature_note_modifier.dart';
import 'package:toolkit/models/note_data.dart';

class StaveNoteChanger extends PositionComponent with Fadeable{

  late Note note;
  
  late StaveClef clef;

  late KeySignatureComponent keySignatureComponent;

  late KeySignatureNoteModifier keySignatureNoteModifier;

  NoteData currentNoteData = NoteData.placeholderValue;

  StaveNoteChanger(this.note, this.clef, this.keySignatureComponent, this.keySignatureNoteModifier);

  Future<void> fadeAndChangeNote(NoteData newNote, {double duration = 1.0}) async {
    if (duration < 0.1) return;
    await fadeOut(duration: duration, fadeNotes: !clef.clefChanges(currentNoteData, newNote));
    Future.delayed(Duration(milliseconds: (duration * 1000).toInt()), () {
      note.changeNote(keySignatureNoteModifier.modifyNote(newNote));
      if(clef.clefChanges(currentNoteData,newNote)){
      clef.changeClef(currentNoteData, newNote);
      keySignatureComponent.displayKeySignature(newNote.clef);
    }
      fadeIn(duration: duration, fadeNotes: !clef.clefChanges(currentNoteData, newNote));
      currentNoteData = newNote;
    });
  }


  
  @override
  List<PositionComponent> get fadeableComponents => [note.noteComponents, note.ledgerHolder, clef.trebleClefSprite, clef.bassClefSprite, keySignatureComponent];
  @override
  List<PositionComponent> get noteComponents => [note.noteComponents, note.ledgerHolder];
}