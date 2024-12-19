import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/tools/config.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/utils.dart';

class Note extends PositionComponent with HasVisibility{
  late Asset crotchetSprite;
  late Asset invertedCrotchetSprite;
  //late Asset accidentalSprite;
  late Asset sharpSprite;
  late Asset flatSprite;
  late Asset doubleSharpSprite;
  late Asset doubleFlatSprite;
  late Asset naturalSprite;
  late NoteData noteData;
  late Asset arrowSprite;
  PositionComponent noteComponents = PositionComponent();
  PositionComponent ledgerHolder = PositionComponent();
  final bool arrowShowing;
  final bool isGhostNote;

  bool isSetUpComplete = false;

  Note(this.noteData,
      {this.arrowShowing = false,
      this.isGhostNote = false,
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
    Color colour = isGhostNote ? Colors.grey : Colors.black;
    arrowSprite = Asset.createArrow();
    crotchetSprite = Asset.createCrotchet(colour: colour);
    invertedCrotchetSprite = Asset.createInvertedCrotchet(colour: colour);
    sharpSprite = Asset.createSharp(colour: colour);
    flatSprite = Asset.createFlat(colour: colour);
    doubleSharpSprite = Asset.createDoubleSharp(colour: colour);
    doubleFlatSprite = Asset.createDoubleFlat(colour: colour);
    naturalSprite = Asset.createNatural(colour: colour);
    noteComponents
    ..add(crotchetSprite)
    ..add(invertedCrotchetSprite)
    ..add(sharpSprite)
    ..add(flatSprite)
    ..add(doubleSharpSprite)
    ..add(doubleFlatSprite)
    ..add(arrowSprite)
    ..add(naturalSprite);
    add(noteComponents);
    add(ledgerHolder);
    positionCrotchetSprite();
    changeNote(noteData);
  }

  void changeNote(NoteData newNote) {
    noteData = newNote;
    arrowSprite.isVisible = arrowShowing;
    crotchetSprite.isVisible = noteData.posOnStave <= 0;
    invertedCrotchetSprite.isVisible = noteData.posOnStave > 0;
    sharpSprite.isVisible = noteData.accidental == Accidental.sharp;
    flatSprite.isVisible = noteData.accidental == Accidental.flat;
    doubleSharpSprite.isVisible = noteData.accidental == Accidental.doubleSharp;
    doubleFlatSprite.isVisible = noteData.accidental == Accidental.doubleFlat;
    naturalSprite.isVisible = noteData.accidental == Accidental.natural;
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
    RectangleComponent ledgerLine = RectangleComponent(
      size: Vector2(ledgerLength, lineWidth),
      paint: Paint()..color = colour,
    )..position = Vector2(-13, -p / 2 * lineGap);
    ledgerHolder.add(ledgerLine);
  }

  void positionCrotchetSprite() {
    noteComponents.position = Vector2(0, -lineGap * noteData.posOnStave / 2.0);
  }

  void addArrow() {
    noteComponents.add(arrowSprite);
  }
}
