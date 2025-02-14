import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/note.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/key_signature.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/tools/config.dart';
import 'package:toolkit/tools/note_generator.dart';
import 'package:toolkit/tools/utils.dart';
import 'package:toolkit/components/stave_position_manager.dart';
import 'package:toolkit/components/note_manager.dart';
import 'package:toolkit/components/clef_manager.dart';
import 'package:toolkit/components/key_signature_manager.dart';
import 'package:toolkit/components/stave_line_drawer.dart';

class Stave extends PositionComponent {
  late StavePositionManager positionManager;
  final double displaySize;
  final Player player;
  NoteData currentNoteData = NoteData.placeholderValue;
  NoteGenerator noteGenerator = NoteGenerator();
  late NoteManager noteManager;
  late ClefManager clefManager;
  late KeySignatureManager keySignatureManager;
  late StaveLineDrawer staveLineDrawer;

  Stave(this.player, this.displaySize, {bool showGhostNotes = false}) {
    positionManager = StavePositionManager(player.keySignature, showGhostNotes, displaySize);
    noteManager = NoteManager(this, positionManager, noteGenerator);
    clefManager = ClefManager(this, positionManager);
    keySignatureManager = KeySignatureManager(this, positionManager, player);
    staveLineDrawer = StaveLineDrawer(this, positionManager);
  }

  @override
  FutureOr<void> onLoad() {
    build();
    return super.onLoad();
  }

  void build() {
    staveLineDrawer.drawLines();
    clefManager.drawClef();
    keySignatureManager.setUpKeySignature();
    noteManager.addGhostNote();
    noteManager.addNote();
    scale = Vector2(positionManager.scaleFactor(), positionManager.scaleFactor());
  }

  void changeNote(NoteData newNote, double fadeDuration) {
    noteManager.changeNote(newNote, fadeDuration);
    if (clefManager.clefChanges(newNote)) {
      clefManager.changeClef(newNote, fadeDuration);
      keySignatureManager.changeKeySignature(newNote);
    }
    currentNoteData = newNote;
  }
}
