import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/components.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/tools.dart';
import 'package:toolkit/tools/config.dart';

class NoteIcon extends FlameGame {

  final Vector2 viewSize = Vector2(300, 500);
  double staffWidth = 250;
  final NoteData noteData;
  late Note note;
  late Asset clefSprite;
  PositionComponent componentHolder = PositionComponent();
  final NoteGenerator noteGenerator = NoteGenerator();


  NoteIcon(this.noteData);



  void build() {
    world.add(componentHolder);
    drawLines();
    newNote();
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.anchor = Anchor.center;
    build();
  }

  void newNote() {
    // Change this to just change the note.
    PositionComponent clefHolder = PositionComponent();
    clefSprite = noteData.clef.sprite..positionSprite();
    componentHolder.add(clefHolder);
    note = Note(noteData)..position = Vector2(40, 0);
    componentHolder.add(note);
    clefHolder.add(clefSprite);
    clefHolder.position = Vector2(-70, 0);
  }

  void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: Vector2(staffWidth,
            lineWidth),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(-staffWidth / 2, i * lineGap);
      world.add(newLine);
    }
  }

  @override
  Color backgroundColor() => Colors.white;
}
