import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/note/ledger_line.dart';
import 'package:toolkit/components/note/note_components.dart';
import 'package:toolkit/tools/config.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/utils.dart';

class Note extends PositionComponent with HasVisibility implements OpacityProvider {
  late NoteComponents noteComponents;
  late NoteData noteData;
  PositionComponent ledgerHolder = PositionComponent();
  final bool arrowShowing;
  final bool isGhostNote;

  bool isSetUpComplete = false;

  double _opacity = 1.0;

  @override
  double opacity;

  Note(this.noteData,
      {this.arrowShowing = false,
      this.isGhostNote = false,
      this.opacity = 1.0,
      super.position,
      super.size,
      super.scale,
      super.angle,
      super.nativeAngle,
      super.anchor,
      super.children,
      super.priority,
      super.key});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await setUp();
    isSetUpComplete = true;
  }

  Future<void> setUp() async {
    noteComponents = NoteComponents(isGhostNote);
    add(noteComponents);
    add(ledgerHolder);
    positionCrotchetSprite();
    changeNote(noteData);
  }

  void setOpacity(double opacity) {
    _opacity = opacity.clamp(0.0, 1.0);
    for (var component in noteComponents.children) {
      if (component is Asset) {
        component.changeOpacity(_opacity);
      }
    }
    for (var component in ledgerHolder.children) {
      if (component is Asset) {
        component.changeOpacity(_opacity);
      }
    }
  }

  void changeNote(NoteData newNote) {
    if (newNote == NoteData.placeholderValue) {
      setOpacity(0);
    }
    noteData = newNote;
    noteComponents.changeNoteVisibility(noteData, arrowShowing);
    positionCrotchetSprite();
    drawLedgers();
  }

  void drawLedgers() {
    Utils.removeAllChildren(ledgerHolder);
    for (var i = 6; i <= noteData.posOnStave; i += 2) {
      drawLedger(i);
    }
    for (var i = -6; i >= noteData.posOnStave; i -= 2) {
      drawLedger(i);
    }
  }

  void drawLedger(int p) {
    Color colour = isGhostNote ? Colors.grey : Colors.black;
    LedgerLine newLine = LedgerLine(
      size: Vector2(ledgerLength, lineWidth),
      paint: Paint()..color = colour,
      position: Vector2(-13, -p / 2 * lineGap),
    );
    ledgerHolder.add(newLine);
  }

  void positionCrotchetSprite() {
    noteComponents.positionCrotchetSprite(noteData);
  }

  void addArrow() {
    noteComponents.add(noteComponents.arrowSprite);
  }
  
}

