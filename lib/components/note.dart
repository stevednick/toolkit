import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/config.dart';
import 'package:toolkit/models/accidental.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/note_data.dart';

class Note extends PositionComponent{
  late Asset crotchetSprite;
  late Asset invertedCrotchetSprite;
  //late Asset accidentalSprite;
  late Asset sharpSprite;
  late Asset flatSprite;
  late NoteData noteData;
  late Asset arrowSprite;
  PositionComponent noteComponents = PositionComponent();
  PositionComponent ledgerHolder = PositionComponent();
  final bool arrowShowing;


  Note(this.noteData, {this.arrowShowing = false, super.position, super.size, super.scale, super.angle, super.nativeAngle, super.anchor, super.children, super.priority, super.key});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    setUp();
  }
  void setUp() {
    arrowSprite = Asset.createArrow();
    crotchetSprite = Asset.createCrotchet();
    invertedCrotchetSprite = Asset.createInvertedCrotchet();
    sharpSprite = Asset.createSharp();
    flatSprite = Asset.createFlat();
    noteComponents.add(crotchetSprite);
    noteComponents.add(invertedCrotchetSprite);
    noteComponents.add(sharpSprite);
    noteComponents.add(flatSprite);
    noteComponents.add(arrowSprite);
    add(noteComponents);
    add(ledgerHolder);
    positionCrotchetSprite();
    //setUpAccidental();
    changeNote(noteData);
    
  }

  void changeNote(NoteData newNote){ 
    noteData = newNote;
    arrowSprite.isVisible = arrowShowing;
    crotchetSprite.isVisible = noteData.posOnStave <= 0;
    invertedCrotchetSprite.isVisible = noteData.posOnStave > 0;
    sharpSprite.isVisible = noteData.accidental == Accidental.sharp;
    flatSprite.isVisible = noteData.accidental == Accidental.flat;
    positionCrotchetSprite();
    drawLedgers();
  }

  // void setUpAccidental() {
  //   switch (noteData.accidental) {
  //     case Accidental.sharp:
  //       accidentalSprite = Asset.createSharp();
  //       break;
  //     case Accidental.flat:
  //       accidentalSprite = Asset.createFlat();
  //       break;
  //     default:
  //       return;
  //   }
  //   noteComponents.add(accidentalSprite);
  // }

  void drawLedgers() {
    ledgerHolder.children.clear();
    for (var i = 6; i <= noteData.posOnStave; i += 2) {
      drawLedger(i);
    }
    for (var i = -6; i >= noteData.posOnStave; i -= 2) {
      drawLedger(i);
    }
  }

  void drawLedger(int p) {
    RectangleComponent ledgerLine = RectangleComponent(
      size: Vector2(ledgerLength, lineWidth),
      paint: Paint()..color = Colors.black,
    )..position = Vector2(-13, -p / 2 * lineGap);
    ledgerHolder.add(ledgerLine);
  }

  void positionCrotchetSprite() {
    noteComponents.position = Vector2(0, -lineGap * noteData.posOnStave / 2.0);
  }

  void addArrow(){
    
    noteComponents.add(arrowSprite); 
  }
}
