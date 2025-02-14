import 'dart:async';
import 'package:flame/components.dart';
import 'package:toolkit/components/note.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/tools/note_generator.dart';
import 'package:toolkit/components/stave_position_manager.dart';
import 'package:toolkit/tools/utils.dart';

class NoteManager {
  final PositionComponent parent;
  final StavePositionManager positionManager;
  final NoteGenerator noteGenerator;
  late Note note;
  PositionComponent noteHolder = PositionComponent();
  late Note ghostNote;
  PositionComponent ghostNoteHolder = PositionComponent();
  int previousGhostNote = -556;

  NoteManager(this.parent, this.positionManager, this.noteGenerator);

  Future<void> addNote() async {
    note = Note(NoteData.placeholderValue)
      ..position = positionManager.notePosition();
    parent.add(noteHolder);
    noteHolder.add(note);
  }

  Future<void> addGhostNote() async {
    ghostNote = Note(NoteData.octave[0], isGhostNote: true)
      ..position = positionManager.ghostNotePosition();
    parent.add(ghostNoteHolder);
    ghostNoteHolder.add(ghostNote);
    ghostNote.isVisible = false;
  }

  void changeNote(NoteData newNote, double fadeDuration) {
    note.fadeAndChangeNote(newNote, duration: fadeDuration);
  }

  void showGhostNote(int num, int noteToCheck) {
    num -= positionManager.keySignature.clefOffset();
    if (num == previousGhostNote) return;
    if (num < -500) {
      previousGhostNote = -1001;
      ghostNote.isVisible = false;
      return;
    }

    NoteData d = noteGenerator.noteFromNumber(num, NoteData.placeholderValue.clef);
    if (num == noteToCheck) {
      d = NoteData.placeholderValue;
    }

    ghostNote.changeNote(d);
    ghostNote.isVisible = true;
    previousGhostNote = num;
  }
}
