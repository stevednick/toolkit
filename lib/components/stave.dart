import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/note.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/key_signature.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/tools/config.dart';
import 'package:toolkit/tools/note_generator.dart';
import 'package:toolkit/tools/utils.dart';

class Stave extends PositionComponent {
  // Can I fix this?
  late StavePositionManager positionManager;
  final double displaySize;

  final Player player;

  NoteData currentNoteData = NoteData.placeholderValue;

  NoteGenerator noteGenerator = NoteGenerator();

  late Note note;
  PositionComponent noteHolder = PositionComponent();

  late Note ghostNote;
  PositionComponent ghostNoteHolder = PositionComponent();
  int previousGhostNote = -556;
  late bool showGhostNotes;

  final PositionComponent clefHolder = PositionComponent();
  Asset trebleClefSprite = Asset.createTrebleClef()..positionSprite();
  Asset bassClefSprite = Asset.createBassClef()..positionSprite();

  PositionComponent keySignatureHolder = PositionComponent();
  KeySignature keySignature = KeySignature.keySignatures[0];

  Stave(this.player, this.displaySize, {this.showGhostNotes = false});

  @override
  FutureOr<void> onLoad() {
    positionManager = StavePositionManager(player.keySignature, showGhostNotes, displaySize);
    build();
    return super.onLoad();
  }

  void build() {
    drawLines();
    drawClef();
    setUpKeySignature();
    addGhostNote();
    addNote();
    scale = Vector2(positionManager.scaleFactor(), positionManager.scaleFactor());
  }

  void changeNote(NoteData newNote, double fadeDuration) {
    note.fadeAndChangeNote(newNote, duration: fadeDuration);
    if(clefChanges(newNote)){
      changeClef(newNote, fadeDuration);
      changeKeySignature(newNote); 
    }
    currentNoteData = newNote;
  }

  // Note Functions

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
    //d = keySignature.noteModifier(d, ghostNote: true);
    print("$num, $noteToCheck");
    if (num == noteToCheck) {
      d = currentNoteData;
    }

    ghostNote.changeNote(d);
    ghostNote.isVisible = true;
    previousGhostNote = num;
  }

  // Clef Functions

  void drawClef() {
    clefHolder.position = positionManager.clefHolderPosition();
    add(clefHolder);
    clefHolder.addAll([trebleClefSprite, bassClefSprite]);
    trebleClefSprite.opacity = 0;
    bassClefSprite.opacity = 0;
  }

  Future<void> sequentialFade(
      Asset outSprite, Asset inSprite, double duration) async {
    await outSprite
        .add(OpacityEffect.fadeOut(EffectController(duration: duration)));
    await inSprite.add(OpacityEffect.fadeIn(DelayedEffectController(
        EffectController(duration: duration),
        delay: duration)));
  }

  Future<void> changeClef(NoteData newNote, double fadeDuration) async {
    if (clefChanges(newNote)) {
      if (newNote.clef.name == 'Bass') {
        await sequentialFade(trebleClefSprite, bassClefSprite, fadeDuration);
      } else {
        await sequentialFade(bassClefSprite, trebleClefSprite, fadeDuration);
      }
    }
  }

  bool clefChanges(NoteData newNote) {
    return currentNoteData.clef.name != newNote.clef.name;
  }

  // Key Signature Functions

  Future<void> setUpKeySignature() async {
    keySignature = await player.loadKeySignature();
    keySignatureHolder.position = positionManager.keySignatureHolderPosition();
    keySignatureHolder.add(keySignature.displayKeySignature(currentNoteData.clef));
    add(keySignatureHolder);
  }

  Future<void> changeKeySignature(NoteData newNote) async {  // todo add fade duration
    Utils.removeAllChildren(keySignatureHolder);
    keySignatureHolder.add(keySignature.displayKeySignature(newNote.clef));
  }

  // Stave Line Functions

  void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: positionManager.staffLineSize(),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(positionManager.staffLinePosX(), i * lineGap);
      add(newLine);
    }
  }
}

class StavePositionManager {
  final KeySignature keySignature;
  final double staffWidth = 280;
  final double ghostNoteExtension = 130;
  final double size;
  final bool showGhostNotes;
  StavePositionManager(this.keySignature, this.showGhostNotes, this.size);

  Vector2 staffLineSize() {
    return Vector2(
        staffWidth +
            (showGhostNotes ? ghostNoteExtension : 0) +
            keySignature.clefOffset(),
        lineWidth);
  }

  double staffLinePosX() {
    return 20 - staffWidth / 2 - keySignature.clefOffset();
  }

  Vector2 notePosition() {
    return Vector2(40, 0);
  }

  Vector2 ghostNotePosition() {
    return Vector2(180, 0);
  }

  Vector2 bouncyBallPosition() {
    return notePosition() + Vector2(80, -70);
  }

  Vector2 clefHolderPosition() {
    return Vector2(-70 - keySignature.clefOffset(), 0);
  }

  Vector2 keySignatureHolderPosition() {
    return Vector2(25 - keySignature.clefOffset(), 0);
  }

  double scaleFactor() {
    // Move this to pos Man
    return size /
        ((staffWidth +
                (showGhostNotes ? ghostNoteExtension : 0) +
                keySignature.clefOffset()));
  }
}
