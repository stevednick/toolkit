import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/note/note.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signature_builder_data.dart';
import 'package:toolkit/models/key_signature/key_signature_component.dart';
import 'package:toolkit/models/key_signature/key_signature_note_modifier.dart';
import 'package:toolkit/scenes/range_selection_scene/range_selection_drag_box.dart';
import 'package:toolkit/scenes/range_selection_scene/range_selection_position_manager.dart';
import 'package:toolkit/scenes/range_selection_scene/range_selection_stave.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/tools/config.dart';
import 'package:toolkit/tools/note_generator.dart';

class RangeSelectionScene extends FlameGame
    with TapCallbacks, VerticalDragDetector, HasVisibility {

  final Player player;

  late DragHandler dragHandler;

  late RangeSelectionStave stave;

  late RangeSelectionPositionManager positionManager;

  late KeySignatureBuilderData data = KeySignatureBuilderData();

  double width = 1000;

  

  List<RectangleComponent> barLines = [];
  List<bool> isDragging = [false, false];
  double dragValue = 0;
  double dragCutOff = 25;
  List<String> currentClefs = ["None", "None"];

  final NoteGenerator noteGenerator = NoteGenerator();
  final bool isClefThresholds;

  late List<Note> notes;
  late List<Asset?> clefSprites = [];
  List<PositionComponent> clefHolders = [
    PositionComponent(),
    PositionComponent()
  ];

  late KeySignature keySignature;
  late KeySignatureNoteModifier keySignatureNoteModifier;

  late List<KeySignatureComponent> keySignatureComponents;

  late List<PositionComponent> keySignatureHolder = [
    PositionComponent(),
    PositionComponent()
  ];

  PositionComponent componentHolder = PositionComponent();

  RangeSelectionScene(this.player,
      {this.isClefThresholds = false}); // Todo, set to false for reals!



  Future<void> setUp() async {
    keySignature = await player.loadKeySignature();
    positionManager = RangeSelectionPositionManager(keySignature, width);
    stave = RangeSelectionStave(positionManager);
    world.add(stave);
    keySignatureNoteModifier = KeySignatureNoteModifier(keySignature);

    addKeySignatures();

    camera.viewfinder.zoom = positionManager.scaleFactor();
    camera.viewfinder.anchor = Anchor.center;
    world.add(componentHolder);
    List<int> _ = await player.range.getValues();
    drawLines();
    drawItems();

    //add(HighlightBox(Vector2(5, 0), dragBoxSize()));
    dragHandler = DragHandler(
      onValueChange: changeValue,
      dragBoxStarts: positionManager.dragBoxStart(),//[positionManager.dragBoxStart()[0], dragBoxStart()[1]],
      dragBoxSize: positionManager.dragBoxSize(),//dragBoxSize(),
      clefOffset: data.clefOffset(keySignature),
    );
  }

  void addKeySignatures(){
    keySignatureComponents = [
      KeySignatureComponent(keySignature),
      KeySignatureComponent(keySignature)
    ];
    world.add(keySignatureComponents[0]);
    world.add(keySignatureComponents[1]);
    keySignatureComponents[0].displayKeySignature(Clef.treble());
    keySignatureComponents[1].displayKeySignature(Clef.bass());
    keySignatureComponents[0].position = positionManager.keySignaturePositions[0];
    keySignatureComponents[1].position = positionManager.keySignaturePositions[1];
  }

  Future<void> setWidth(double width) async {
    width = width;
    await setUp();
    
  }

  void onClefChange() {
    keySignatureComponents[0].displayKeySignature(notes[0].noteData.clef);
    keySignatureComponents[1].displayKeySignature(notes[1].noteData.clef);
    notes[1].position = positionManager.notePositions[1] +
        ((currentClefs[0] != currentClefs[1])
            ? Vector2(data.clefOffset(keySignature), 0)
            : Vector2.zero());
  }

  Future<void> drawItems() async {
    notes = [];
    clefSprites = [];
    // world.add(keySignatureHolder[0]);
    // world.add(keySignatureHolder[1]);
    List<NoteData> noteData = getNotes();
    for (var i = 0; i < 2; i++) {
      currentClefs[i] = noteData[i].clef.name;
      Vector2 noteOffset = Vector2.zero();
      if (i == 1) {
        noteOffset = (currentClefs[0] != currentClefs[1])
            ? Vector2(data.clefOffset(keySignature), 0)
            : Vector2.zero();
      }
      notes.add(Note(noteData[i], arrowShowing: true)
        ..position = positionManager.notePositions[i] + noteOffset);
      clefSprites.add(noteData[i].clef.sprite);
      componentHolder.add(notes[i]);
      componentHolder.add(clefHolders[i]);
      clefHolders[i].position = positionManager.clefPositions[i] -
          (i == 0 ? Vector2(data.clefOffset(keySignature), 0) : Vector2.zero());
      addClef(clefSprites[i], noteData[i], clefHolders[i]);
      notes[i].changeNote(noteData[i]);
    }
    checkAndHideBottomClef();
  }

  void drawKeySignatures(int i) {
    keySignatureHolder[i].add(keySignatureComponents[i]);
    List<Vector2> positions = [Vector2(-80 - data.clefOffset(keySignature), 0), Vector2(150, 0)];

    // keySignatureHolder[i] = keySignature.changeKeySignature(notes[i].noteData.clef);
    keySignatureHolder[i].position = positions[i];
    world.add(keySignatureHolder[i]);
    // world.add(keySignatureHolder[i]);
  }

  void changeKeySignature(int i) {
    keySignatureComponents[i].displayKeySignature(notes[i].noteData.clef);
  }

  List<NoteData> getNotes() {
    List<NoteData> noteData = [
      keySignatureNoteModifier.modifyNote(
          noteGenerator.getNextAvailableNote(player.range.top, false, player),
          rangeSelection: true),
      keySignatureNoteModifier.modifyNote(
          noteGenerator.getNextAvailableNote(
              player.range.bottom, false, player),
          rangeSelection: true)
    ];
    if (isClefThresholds) {
      noteData = [
        NoteData.findFirstChoiceByNumber(
            player.clefThreshold.trebleClefThreshold, Clef.treble()),
        NoteData.findFirstChoiceByNumber(
            player.clefThreshold.bassClefThreshold, Clef.bass())
      ];
    }
    return noteData;
  }

  void changeValue(bool isTop, bool up) {
    if (!isClefThresholds) {
      if (noteGenerator.checkValidChange(player, isTop, up)) {
        player.range.increment(isTop, up);
      }
    } else {
      player.clefThreshold.increment(isTop, up);
    }
    changeNote(isTop);
  }

  void changeNote(bool isTop) {
    List<NoteData> data = getNotes();

    for (var i = 0; i < 2; i++) {
      notes[i].changeNote(data[i]);
      if (data[i].clef.name != currentClefs[i]) {
        changeClef(clefSprites[i]!, data[i], i);
        currentClefs[i] = data[i].clef.name;
        onClefChange();
      }
    }
    checkAndHideBottomClef();
  }

  void checkAndHideBottomClef() {
    if (currentClefs[0] == currentClefs[1]) {
      clefHolders[1].scale = Vector2.zero();
      keySignatureHolder[1].scale = Vector2.zero();
      barLines[1].setAlpha(255);
    } else {
      clefHolders[1].scale = Vector2(1, 1);
      keySignatureHolder[1].scale = Vector2(1, 1);
      barLines[1].setAlpha(0);
    }
  }

  void changeClef(Asset sprite, NoteData data, int n) {
    addClef(sprite, data, clefHolders[n]);
  }

  void addClef(Asset? sprite, NoteData data, PositionComponent clefHolder) {
    sprite = data.clef.sprite..positionSprite();
    clefHolder.children.toList().forEach((child) {
      child.removeFromParent();
    });
    clefHolder.add(sprite);
  }

  void drawLines() {
    RectangleComponent barLine = RectangleComponent(
      size: Vector2(lineWidth, lineGap * 4),
      paint: Paint()..color = Colors.black,
    )..position = Vector2(-positionManager.staffWidth / 2, -2 * lineGap);
    barLines.add(barLine);
    world.add(barLine);
    barLine.position = Vector2(50, -2 * lineGap);
    barLines.add(barLine);
    world.add(barLine);
    barLines[1].setAlpha(0);
  }

  @override
  void onVerticalDragStart(DragStartInfo info) {
    dragHandler.onVerticalDragStart(info);
    super.onVerticalDragStart(info);
  }

  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    dragHandler.onVerticalDragUpdate(info);
    super.onVerticalDragUpdate(info);
  }

  @override
  void onVerticalDragEnd(DragEndInfo info) {
    dragHandler.onVerticalDragEnd(info);
    super.onVerticalDragEnd(info);
  }

  // @override
  // void onVerticalDragStart(DragStartInfo info) {
  //   Vector2 pos = info.eventPosition.widget;
  //   for (var i = 0; i < 2; i++) {
  //     if (pos.x > dragBoxStart()[i].x &&
  //         pos.x <
  //             dragBoxStart()[i].x +
  //                 dragBoxSize().x +
  //                 (i == 1 ? data.clefOffset(keySignature) + 100 : 0)) {
  //       if (pos.y > dragBoxStart()[i].y &&
  //           pos.y < dragBoxStart()[i].y + dragBoxSize().y) {
  //         isDragging[i] = true;
  //         dragValue = 0;
  //       }
  //     }
  //   }
  //   super.onVerticalDragStart(info);
  // }

  // @override
  // void onVerticalDragUpdate(DragUpdateInfo info) {
  //   void checkDragging(bool isIncrementingUp) {
  //     for (var i = 0; i < 2; i++) {
  //       if (isDragging[i]) {
  //         changeValue(i == 0, isIncrementingUp);
  //       }
  //     }
  //   }

  //   dragValue -= info.delta.global.y;
  //   if (dragValue > dragCutOff) {
  //     dragValue -= dragCutOff;
  //     checkDragging(true);
  //   }
  //   if (dragValue < -dragCutOff) {
  //     dragValue += dragCutOff;
  //     checkDragging(false);
  //   }
  //   super.onVerticalDragUpdate(info);
  // }

  // @override
  // void onVerticalDragEnd(DragEndInfo info) {
  //   isDragging = [false, false];
  //   super.onVerticalDragEnd(info);
  // }

  @override
  Color backgroundColor() => Colors.white;
}
