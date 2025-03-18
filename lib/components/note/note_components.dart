import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/accidental.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/tools/config.dart';

class NoteComponents extends PositionComponent {
  late Asset crotchetSprite;
  late Asset invertedCrotchetSprite;
  late Asset sharpSprite;
  late Asset flatSprite;
  late Asset doubleSharpSprite;
  late Asset doubleFlatSprite;
  late Asset naturalSprite;
  late Asset arrowSprite;

  NoteComponents(bool isGhostNote) {
    Color colour = isGhostNote ? Colors.grey : Colors.black;
    arrowSprite = Asset.createArrow();
    crotchetSprite = Asset.createCrotchet(colour: colour);
    invertedCrotchetSprite = Asset.createInvertedCrotchet(colour: colour);
    sharpSprite = Asset.createSharp(colour: colour);
    flatSprite = Asset.createFlat(colour: colour);
    doubleSharpSprite = Asset.createDoubleSharp(colour: colour);
    doubleFlatSprite = Asset.createDoubleFlat(colour: colour);
    naturalSprite = Asset.createNatural(colour: colour);
    addAll([
      crotchetSprite,
      invertedCrotchetSprite,
      sharpSprite,
      flatSprite,
      doubleSharpSprite,
      doubleFlatSprite,
      arrowSprite,
      naturalSprite,
    ]);
  }

  void positionCrotchetSprite(NoteData noteData) {
    position = Vector2(0, -lineGap * noteData.posOnStave / 2.0);
  }

  void changeNoteVisibility(NoteData noteData, bool arrowShowing) {
    arrowSprite.isVisible = arrowShowing;
    crotchetSprite.isVisible = noteData.posOnStave <= 0;
    invertedCrotchetSprite.isVisible = noteData.posOnStave > 0;
    sharpSprite.isVisible = noteData.accidental == Accidental.sharp;
    flatSprite.isVisible = noteData.accidental == Accidental.flat;
    doubleSharpSprite.isVisible = noteData.accidental == Accidental.doubleSharp;
    doubleFlatSprite.isVisible = noteData.accidental == Accidental.doubleFlat;
    naturalSprite.isVisible = noteData.accidental == Accidental.natural;
  }
}
