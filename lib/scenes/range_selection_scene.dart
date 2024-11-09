import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/note.dart';
import 'package:toolkit/config.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/clef_selection.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/tools/note_generator.dart';

class RangeSelectionScene extends FlameGame
    with TapCallbacks, VerticalDragDetector, HasVisibility {
  final Vector2 viewSize = Vector2(450, 500);
  final double staffWidth = 450;
  final Player player;

  final Vector2 dragBoxSize = Vector2(150, 500);
  final List<Vector2> dragBoxStart = [Vector2(5, 0), Vector2(170, 0)];
  List<RectangleComponent> barLines = [];
  List<bool> isDragging = [false, false];
  double dragValue = 0;
  double dragCutOff = 15;
  List<String> currentClefs = ["None", "None"];

  final NoteGenerator noteGenerator = NoteGenerator();
  final bool isClefThresholds;

  late List<Note> notes;
  late List<Asset?> clefSprites = [];
  List<PositionComponent> clefHolders = [
    PositionComponent(),
    PositionComponent()
  ];

  List<Vector2> notePositions = [Vector2(-75, 0), Vector2(150, 0)];
  List<Vector2> clefPositions = [Vector2(-170, 0), Vector2(50, 0)];

  PositionComponent componentHolder = PositionComponent();

  RangeSelectionScene(this.player, {this.isClefThresholds = false}); // Todo, set to false for reals!

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.anchor = Anchor.center;
    drawLines();
    world.add(componentHolder);
    List<int> _ = await player.range.getValues();
    drawItems();
  }

  void drawItems() {
    notes = [];
    clefSprites = [];
    List<NoteData> noteData = _getNotes();
    for (var i = 0; i < 2; i++) {
      currentClefs[i] = noteData[i].clef.name;
      notes.add(Note(noteData[i], arrowShowing: true)..position = notePositions[i]);
      clefSprites.add(noteData[i].clef.sprite);
      componentHolder.add(notes[i]);
      componentHolder.add(clefHolders[i]);
      clefHolders[i].position = clefPositions[i];
      addClef(clefSprites[i], noteData[i], clefHolders[i]);
      notes[i].changeNote(noteData[i]);
    }
    checkAndHideBottomClef();
  }

  List<NoteData> _getNotes(){
    List<NoteData> noteData = [
      noteGenerator.noteFromNumberOld(player.range.top, true, player.clefSelection),
      noteGenerator.noteFromNumberOld(player.range.bottom, true, player.clefSelection)
    ];
    if(isClefThresholds){
      noteData = [noteGenerator.noteFromNumberOld(player.clefThreshold.trebleClefThreshold, true, ClefSelection.treble), 
      noteGenerator.noteFromNumberOld(player.clefThreshold.bassClefThreshold, true, ClefSelection.bass)];
    }
    return noteData;
  }

  void changeValue(bool isTop, bool up){
    if(!isClefThresholds){
      player.range.increment(isTop, up);
    } else {
      player.clefThreshold.increment(isTop, up);
    }
    changeNote(isTop);
  }

  void changeNote(bool isTop) {
    List<NoteData> data = _getNotes();

    for (var i = 0; i < 2; i++) {
      notes[i].changeNote(data[i]);
      if (data[i].clef.name != currentClefs[i]) {
        changeClef(clefSprites[i]!, data[i], i);
        currentClefs[i] = data[i].clef.name;
      }
    }
    checkAndHideBottomClef();
  }

  void checkAndHideBottomClef() {
    if (currentClefs[0] == currentClefs[1]) {
      clefHolders[1].scale = Vector2(0, 0);
      barLines[1].setAlpha(255);
    } else {
      clefHolders[1].scale = Vector2(1, 1);
      barLines[1].setAlpha(0);
    }
  }

  void changeClef(Asset sprite, NoteData data, int n) {
    addClef(sprite, data, clefHolders[n]);
  }

  void addClef(Asset? sprite, NoteData data, PositionComponent clefHolder) {
    sprite = data.clef.sprite..positionSprite();
    clefHolder.children.clear();
    clefHolder.add(sprite);
  }

  void drawLines() {
    RectangleComponent barLine = RectangleComponent(
      size: Vector2(lineWidth, lineGap * 4),
      paint: Paint()..color = Colors.black,
    )..position = Vector2(-staffWidth / 2, -2 * lineGap);
    barLines.add(barLine);
    world.add(barLine);
    barLine.position = Vector2(50, -2 * lineGap);
    barLines.add(barLine);
    world.add(barLine);
    barLines[1].setAlpha(0);
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: Vector2(staffWidth, lineWidth),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(-staffWidth / 2, i * lineGap);
      world.add(newLine);
    }
  }

  @override
  void onVerticalDragStart(DragStartInfo info) {
    Vector2 pos = info.eventPosition.widget;
    for (var i = 0; i < 2; i++) {
      if (pos.x > dragBoxStart[i].x &&
          pos.x < dragBoxStart[i].x + dragBoxSize.x) {
        if (pos.y > dragBoxStart[i].y &&
            pos.y < dragBoxStart[i].y + dragBoxSize.y) {
          isDragging[i] = true;
          dragValue = 0;
        }
      }
    }
    super.onVerticalDragStart(info);
  }

  @override
  void onVerticalDragUpdate(DragUpdateInfo info) {
    void checkDragging(bool isIncrementingUp) {
      for (var i = 0; i < 2; i++) {
        if (isDragging[i]) {
          changeValue(i == 0, isIncrementingUp);
        }
      }
    }

    dragValue -= info.delta.global.y;
    if (dragValue > dragCutOff) {
      dragValue -= dragCutOff;
      checkDragging(true);
    }
    if (dragValue < -dragCutOff) {
      dragValue += dragCutOff;
      checkDragging(false);
    }
    super.onVerticalDragUpdate(info);
  }

  @override
  void onVerticalDragEnd(DragEndInfo info) {
    isDragging = [false, false];
    super.onVerticalDragEnd(info);
  }

  @override
  Color backgroundColor() => Colors.white;
}
