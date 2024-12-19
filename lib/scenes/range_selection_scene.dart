import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/note.dart';
// import 'package:toolkit/models/highlight_box.dart';
import 'package:toolkit/models/key_signature.dart';
import 'package:toolkit/tools/config.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/tools/note_generator.dart';

class RangeSelectionScene extends FlameGame
    with TapCallbacks, VerticalDragDetector, HasVisibility {
  final Vector2 viewSize = Vector2(350, 500);
  final double staffWidth = 450;
  final Player player;

  Vector2 dragBoxSize(){
    print("Width: $width");
    return Vector2(width/(screenWidthRatio*2), 1000);
  }
  List<Vector2> dragBoxStart(){
    return [Vector2(5, 0), Vector2(width/(screenWidthRatio*2)+ 5, 0)];
  }
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
  late List<PositionComponent> keySignatureHolder = [PositionComponent(), PositionComponent()];

  List<Vector2> notePositions = [Vector2(-75, 0), Vector2(150, 0)];
  List<Vector2> clefPositions = [Vector2(-170, 0), Vector2(50, 0)];

  PositionComponent componentHolder = PositionComponent();

  RangeSelectionScene(this.player, {this.isClefThresholds = false}); // Todo, set to false for reals!

  double width = 1000;
  double screenWidthRatio = 3;

  double scaleFactor(){
    return width/((staffWidth+keySignature.clefOffset()*2)*screenWidthRatio);
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    await setUp();
  }


  Future<void> setUp() async {
    //Utils.removeAllChildren(world);
    //Utils.removeAllChildren(componentHolder);
    keySignature = await player.loadKeySignature();
    width = width;
    camera.viewfinder.zoom = scaleFactor();
    camera.viewfinder.anchor = Anchor.center;
    drawLines();
    world.add(componentHolder);
    List<int> _ = await player.range.getValues();
    drawItems();
    //add(HighlightBox(Vector2(5, 0), dragBoxSize()));
  }

  void onClefChange(){
    drawKeySignatures(0);
    drawKeySignatures(1);
    notes[1].position = notePositions[1] + ((currentClefs[0] != currentClefs[1]) ? Vector2(keySignature.clefOffset(),0) : Vector2.zero());
  }

  Future<void> drawItems() async {
    notes = [];
    clefSprites = [];
    world.add(keySignatureHolder[0]);
    world.add(keySignatureHolder[1]);
    List<NoteData> noteData = getNotes();
    for (var i = 0; i < 2; i++) {
      currentClefs[i] = noteData[i].clef.name;
      Vector2 noteOffset = Vector2.zero();
      if (i == 1){
        noteOffset = (currentClefs[0] != currentClefs[1]) ? Vector2(keySignature.clefOffset(),0) : Vector2.zero();
      }
      notes.add(Note(noteData[i], arrowShowing: true)..position = notePositions[i] + noteOffset);
      clefSprites.add(noteData[i].clef.sprite);
      componentHolder.add(notes[i]);
      componentHolder.add(clefHolders[i]);
      clefHolders[i].position = clefPositions[i] - (i == 0 ? Vector2(keySignature.clefOffset(), 0): Vector2.zero());
      addClef(clefSprites[i], noteData[i], clefHolders[i]);
      notes[i].changeNote(noteData[i]);
      drawKeySignatures(i);
    }
    checkAndHideBottomClef();
  }

  void drawKeySignatures(int i){
    world.remove(keySignatureHolder[i]);
    List<Vector2> positions = [Vector2(-80 - keySignature.clefOffset(), 0), Vector2(150, 0)];
    keySignatureHolder[i] = keySignature.displayKeySignature(notes[i].noteData.clef);
    keySignatureHolder[i].position = positions[i];
    world.add(keySignatureHolder[i]);
  }

  List<NoteData> getNotes(){
    List<NoteData> noteData = [
      keySignature.noteModifier(noteGenerator.getNextAvailableNote(player.range.top, false, player), rangeSelection: true),
      //noteGenerator.noteFromNumberOld(player.range.top, true, player.clefSelection),
      keySignature.noteModifier(noteGenerator.getNextAvailableNote(player.range.bottom, true, player), rangeSelection: true)
    ];
    if(isClefThresholds){
      noteData = [NoteData.findFirstChoiceByNumber(player.clefThreshold.trebleClefThreshold, Clef.treble()), 
      NoteData.findFirstChoiceByNumber(player.clefThreshold.bassClefThreshold, Clef.bass())];
    }
    return noteData;
  }

  void changeValue(bool isTop, bool up){
    if(!isClefThresholds){
      if (noteGenerator.checkValidChange(player, isTop, up)){
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
    )..position = Vector2(-staffWidth / 2, -2 * lineGap);
    barLines.add(barLine);
    world.add(barLine);
    barLine.position = Vector2(50, -2 * lineGap);
    barLines.add(barLine);
    world.add(barLine);
    barLines[1].setAlpha(0);
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: Vector2(staffWidth + (keySignature.clefOffset()*2), lineWidth),
        paint: Paint()..color = Colors.black,
      )..position = Vector2((-staffWidth / 2) - keySignature.clefOffset(), i * lineGap);
      world.add(newLine);
    }
  }

  @override
  void onVerticalDragStart(DragStartInfo info) {
    Vector2 pos = info.eventPosition.widget;
    for (var i = 0; i < 2; i++) {
      if (pos.x > dragBoxStart()[i].x &&
          pos.x < dragBoxStart()[i].x + dragBoxSize().x + (i==1 ? keySignature.clefOffset() + 100:0)) {
        if (pos.y > dragBoxStart()[i].y &&
            pos.y < dragBoxStart()[i].y + dragBoxSize().y) {
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
