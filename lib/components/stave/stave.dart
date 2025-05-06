import 'dart:async';

import 'package:flame/components.dart';
import 'package:toolkit/components/note/note.dart';
import 'package:toolkit/components/stave/stave_clef.dart';
import 'package:toolkit/components/stave/stave_lines.dart';
import 'package:toolkit/components/stave/stave_note_changer.dart';
import 'package:toolkit/components/stave/stave_position_manager.dart';
import 'package:toolkit/models/key_signature/key_signature_component.dart';
import 'package:toolkit/models/key_signature/key_signature_note_modifier.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/tools/note_generator.dart';

class Stave extends PositionComponent {

  late StavePositionManager positionManager;
  late StaveLines staveLines;

  late StaveNoteChanger noteChanger;
  final double displaySize;

  final Player player;

  NoteData currentNoteData = NoteData.placeholderValue;

  NoteGenerator noteGenerator = NoteGenerator();

  late Note note;
  PositionComponent noteHolder = PositionComponent();

  late KeySignatureComponent keySignatureComponent;

  late KeySignatureNoteModifier keySignatureNoteModifier;

  late StaveClef clef;

  late Note ghostNote;
  PositionComponent ghostNoteHolder = PositionComponent();
  int previousGhostNote = -556;
  late bool showGhostNotes;

  Stave(this.player, this.displaySize, {this.showGhostNotes = false});

  @override
  FutureOr<void> onLoad() {
    positionManager = StavePositionManager(player.keySignature, showGhostNotes, displaySize);
    staveLines = StaveLines(positionManager);
    clef = StaveClef(positionManager);
    keySignatureComponent = KeySignatureComponent(player.keySignature);
    keySignatureComponent.position = positionManager.keySignatureHolderPosition();
    keySignatureNoteModifier = KeySignatureNoteModifier(player.keySignature);
    build();
    return super.onLoad();
  }

  void build() {
    add(staveLines);
    add(clef);
    add(keySignatureComponent);
    addGhostNote();
    addNote();
    scale = positionManager.scaleMultiplier();
    noteChanger = StaveNoteChanger(note, clef, keySignatureComponent, keySignatureNoteModifier);
  }

  void changeNote(NoteData newNote, double fadeDuration) {
    noteChanger.fadeAndChangeNote(newNote, duration: fadeDuration);
    currentNoteData = newNote;
  }

  // Note

  Future<void> addNote() async {
    note = Note(currentNoteData)
      ..position = positionManager.notePosition();
    add(noteHolder);
    noteHolder.add(note);
  }

  // Ghost Note

    Future<void> addGhostNote() async {
    ghostNote = Note(NoteData.octave[0], isGhostNote: true)
      ..position = positionManager.ghostNotePosition();

    add(ghostNoteHolder);
    ghostNoteHolder.add(ghostNote); 
    ghostNote.isVisible = false;
  }

    void showGhostNote(int num, int noteToCheck) {
    num -= player.selectedInstrument.currentTransposition.pitchModifier;
    if (num == previousGhostNote) return;
    if (num < -500) {
      previousGhostNote = -1001;
      ghostNote.isVisible = false;
      return;
    }

    NoteData d = noteGenerator.noteFromNumber(num, currentNoteData.clef);
    d = keySignatureNoteModifier.modifyNote(d, ghostNote: true); 

    //("$num, $noteToCheck");
    if (num == noteToCheck) {
      d = currentNoteData;
    }

    ghostNote.changeNote(d);
    ghostNote.isVisible = true;
    previousGhostNote = num;
  }

  // Clef Function

  bool clefChanges(NoteData newNote) {
    return currentNoteData.clef.name != newNote.clef.name;
  }
}
