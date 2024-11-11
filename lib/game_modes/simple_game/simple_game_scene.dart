import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/note.dart';
import 'package:toolkit/config.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/models/accidental.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/tools/note_generator.dart';

class SimpleGameScene extends FlameGame {
final SimpleGameController gameController;

  final Vector2 viewSize = Vector2(300, 500);
  double staffWidth() {
    return 250;
  }
  late Note note;
  late Asset clefSprite;
  PositionComponent componentHolder = PositionComponent();
  final NoteGenerator noteGenerator = NoteGenerator();

  // final bool _ghostNotesOn = false;

  NoteData noteData = NoteData.placeholderValue;

  SimpleGameScene(this.gameController) {
    //getAndSetNote();

    gameController.player.currentNote.addListener(() {
      getAndSetNote();
    });
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    world.add(componentHolder);
    camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.anchor = Anchor.center;

    drawLines();

  }

  @override
  void onDispose() {
    super.onDispose();
    gameController.player.currentNote.removeListener(getAndSetNote);
    gameController.dispose();
  }

  void newNote(NoteData data) { // Change this to just change the note.
    componentHolder.children.clear();
    clefSprite = noteData.clef.sprite..positionSprite();
    PositionComponent clefHolder = PositionComponent();
    componentHolder.add(clefHolder);
    noteData = data;
    note = Note(noteData)..position = Vector2(40, 0);
    componentHolder.add(note);
    clefHolder.add(clefSprite);
    clefHolder.position = Vector2(-70, 0);
  }

  void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: Vector2(staffWidth(), lineWidth),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(-staffWidth() / 2, i * lineGap);
      world.add(newLine);
    }
  }

  void getAndSetNote() {

    noteData = gameController.getNoteDataFromPlayer();
    newNote(noteData);
  }

  @override
  Color backgroundColor() => Colors.white;
}
