import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';
import 'package:toolkit/components/note/note.dart';
import 'package:toolkit/components/stave/stave_clef.dart';
import 'package:toolkit/components/stave/stave_key_signature.dart';
import 'package:toolkit/mixins/fadeable.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/note_data.dart';

class StaveNoteChanger extends PositionComponent with Fadeable{

  late Note note;
  late StaveKeySignature keySignature;
  late StaveClef clef;

  NoteData currentNoteData = NoteData.placeholderValue;

  StaveNoteChanger(this.note, this.keySignature, this.clef);

  Future<void> fadeAndChangeNote(NoteData newNote, {double duration = 1.0}) async {
    await fadeOut(duration: duration);
    Future.delayed(Duration(milliseconds: (duration * 1000).toInt()), () {
      note.changeNote(newNote);
      if(clef.clefChanges(currentNoteData,newNote)){
      //clef.changeClef(currentNoteData, newNote, fadeDuration);
      keySignature.changeKeySignature(newNote); 
    }
      fadeIn(duration: duration);
      currentNoteData = newNote;
    });
  }


  
  @override
  List<PositionComponent> get fadeableComponents => [note.noteComponents, note.ledgerHolder, keySignature.keySignatureHolder];
}