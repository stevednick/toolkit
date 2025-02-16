// import 'dart:async';
// import 'package:flame/components.dart';
// import 'package:flame/effects.dart';
// import 'package:flutter/material.dart';
// import 'package:toolkit/tools/config.dart';
// import 'package:toolkit/models/models.dart';
// import 'package:toolkit/tools/utils.dart';
// import 'package:toolkit/mixins/fadeable.dart';

// class NoteComponents extends PositionComponent {
//   late Asset crotchetSprite;
//   late Asset invertedCrotchetSprite;
//   late Asset sharpSprite;
//   late Asset flatSprite;
//   late Asset doubleSharpSprite;
//   late Asset doubleFlatSprite;
//   late Asset naturalSprite;
//   late Asset arrowSprite;

//   NoteComponents(bool isGhostNote) {
//     Color colour = isGhostNote ? Colors.grey : Colors.black;
//     arrowSprite = Asset.createArrow();
//     crotchetSprite = Asset.createCrotchet(colour: colour);
//     invertedCrotchetSprite = Asset.createInvertedCrotchet(colour: colour);
//     sharpSprite = Asset.createSharp(colour: colour);
//     flatSprite = Asset.createFlat(colour: colour);
//     doubleSharpSprite = Asset.createDoubleSharp(colour: colour);
//     doubleFlatSprite = Asset.createDoubleFlat(colour: colour);
//     naturalSprite = Asset.createNatural(colour: colour);
//     addAll([
//       crotchetSprite,
//       invertedCrotchetSprite,
//       sharpSprite,
//       flatSprite,
//       doubleSharpSprite,
//       doubleFlatSprite,
//       arrowSprite,
//       naturalSprite,
//     ]);
//   }

//   void positionCrotchetSprite(NoteData noteData) {
//     position = Vector2(0, -lineGap * noteData.posOnStave / 2.0);
//   }

//   void changeNoteVisibility(NoteData noteData, bool arrowShowing) {
//     arrowSprite.isVisible = arrowShowing;
//     crotchetSprite.isVisible = noteData.posOnStave <= 0;
//     invertedCrotchetSprite.isVisible = noteData.posOnStave > 0;
//     sharpSprite.isVisible = noteData.accidental == Accidental.sharp;
//     flatSprite.isVisible = noteData.accidental == Accidental.flat;
//     doubleSharpSprite.isVisible = noteData.accidental == Accidental.doubleSharp;
//     doubleFlatSprite.isVisible = noteData.accidental == Accidental.doubleFlat;
//     naturalSprite.isVisible = noteData.accidental == Accidental.natural;
//   }
// }

// class Note extends PositionComponent with HasVisibility, Fadeable implements OpacityProvider {
//   late NoteComponents noteComponents;
//   late NoteData noteData;
//   PositionComponent ledgerHolder = PositionComponent();
//   final bool arrowShowing;
//   final bool isGhostNote;

//   bool isSetUpComplete = false;

//   double _opacity = 1.0;

//   @override
//   double opacity;

//   Note(this.noteData,
//       {this.arrowShowing = false,
//       this.isGhostNote = false,
//       this.opacity = 1.0,
//       super.position,
//       super.size,
//       super.scale,
//       super.angle,
//       super.nativeAngle,
//       super.anchor,
//       super.children,
//       super.priority,
//       super.key});

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();
//     await setUp();
//     isSetUpComplete = true;
//   }

//   Future<void> setUp() async {
//     noteComponents = NoteComponents(isGhostNote);
//     add(noteComponents);
//     add(ledgerHolder);
//     positionCrotchetSprite();
//     changeNote(noteData);
//   }

//   void setOpacity(double opacity) {
//     _opacity = opacity.clamp(0.0, 1.0);
//     for (var component in noteComponents.children) {
//       if (component is Asset) {
//         component.changeOpacity(_opacity);
//       }
//     }
//     for (var component in ledgerHolder.children) {
//       if (component is Asset) {
//         component.changeOpacity(_opacity);
//       }
//     }
//   }

//   // Future<void> fadeIn({double duration = 1.0}) async {
//   //   for (var component in noteComponents.children) {
//   //     if (component is Asset) {
//   //       component.add(OpacityEffect.fadeIn(EffectController(duration: duration)));
//   //     }
//   //   }
//   //   for (var component in ledgerHolder.children) {
//   //     if (component is Asset) {
//   //       component.add(OpacityEffect.fadeIn(EffectController(duration: duration)));
//   //     }
//   //   }
//   // }

//   // Future<void> fadeOut({double duration = 1.0}) async {
//   //   for (var component in noteComponents.children) {
//   //     if (component is Asset) {
//   //       component.add(OpacityEffect.fadeOut(EffectController(duration: duration)));
//   //     }
//   //   }
//   //   for (var component in ledgerHolder.children) {
//   //     if (component is Asset) {
//   //       component.add(OpacityEffect.fadeOut(EffectController(duration: duration)));
//   //     }
//   //   }
//   // }

//   Future<void> fadeAndChangeNote(NoteData newNote, {double duration = 1.0}) async {
//     await fadeOut(duration: duration);
//     Future.delayed(Duration(milliseconds: (duration * 1000).toInt()), () {
//       changeNote(newNote);
//       fadeIn(duration: duration);
//     });
//   }

//   void changeNote(NoteData newNote) {
//     if (newNote == NoteData.placeholderValue) {
//       setOpacity(0);
//     }
//     noteData = newNote;
//     noteComponents.changeNoteVisibility(noteData, arrowShowing);
//     positionCrotchetSprite();
//     drawLedgers();
//   }

//   void drawLedgers() {
//     Utils.removeAllChildren(ledgerHolder);
//     for (var i = 6; i <= noteData.posOnStave; i += 2) {
//       drawLedger(i);
//     }
//     for (var i = -6; i >= noteData.posOnStave; i -= 2) {
//       drawLedger(i);
//     }
//   }

//   void drawLedger(int p) {
//     Color colour = isGhostNote ? Colors.grey : Colors.black;
//     LedgerLine newLine = LedgerLine(
//       size: Vector2(ledgerLength, lineWidth),
//       paint: Paint()..color = colour,
//       position: Vector2(-13, -p / 2 * lineGap),
//     );
//     ledgerHolder.add(newLine);
//   }

//   void positionCrotchetSprite() {
//     noteComponents.positionCrotchetSprite(noteData);
//   }

//   void addArrow() {
//     noteComponents.add(noteComponents.arrowSprite);
//   }

//   @override
//   List<PositionComponent> get fadeableComponents => [noteComponents, ledgerHolder];
// }

// class LedgerLine extends RectangleComponent implements OpacityProvider {
//   double _opacity = 1.0;

//   LedgerLine({
//     required Vector2 super.size,
//     required Paint super.paint,
//     super.position,
//     super.priority,
//   });

//   @override
//   double get opacity => _opacity;

//   @override
//   set opacity(double value) {
//     _opacity = value.clamp(0.0, 1.0);
//     paint.color = paint.color.withOpacity(_opacity);
//   }
// }
