import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/ball/bouncy_ball.dart';
import 'package:toolkit/components/components.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/tools.dart';

import 'package:toolkit/game_modes/incremental_game_old/incremental_game.dart';

class IncrementalGameScene extends FlameGame {
  final IncrementalGameController gameController;

  final Vector2 viewSize = Vector2(300, 500);
  double staffWidth() {
    return 250;
  }

  double ghostNoteExtension = 130;
  late Note ghostNote;

  late Note note;
  late Asset clefSprite;
  PositionComponent componentHolder = PositionComponent();
  PositionComponent ghostNoteHolder = PositionComponent();
  final NoteGenerator noteGenerator = NoteGenerator();
  final BouncyBall bouncyBall = BouncyBall();
  double gameTime = 0.0;
  bool showBall = false;
  Tick tick = Tick();
  bool showGhostNotes = true;
  bool rebuildQueued = false;

  Tempo tempo = Tempo(key: 'simple_game_tempo');
  late double beatSeconds;

  late int previousGhostNote =
      -1000; // use this to prevent loading ghost note evey frame!

  NoteData noteData = NoteData.placeholderValue;

  IncrementalGameScene(this.gameController) {
    getSettings();
    gameController.currentNote.addListener(() {
      getAndSetNote();
    });
    // gameController.state.addListener(() {
    //   if (gameController.state.value == GameState.correctNoteHeard) {
    //     tick.showTick();
    //   }
    // });
    // gameController.gameMode.addListener(() {
    //   setTempo();
    // });
  }

  Future<void> getSettings() async{
    showGhostNotes = await Settings.getSetting(Settings.ghostNoteString);
    showBall = await Settings.getSetting(Settings.tempoKey);
  }

  Future<void> setSettings() async {
    Settings.saveSetting(Settings.ghostNoteString, showGhostNotes);
    Settings.saveSetting(Settings.tempoKey, showBall);
  }

  void rebuild() {
    Utils.removeAllChildren(world);
    world.add(componentHolder);
    if (showGhostNotes) world.add(ghostNoteHolder);
    drawLines();
    world.add(tick);
    world.add(bouncyBall);
    rebuildQueued = false;
    newNote(noteData);
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.anchor = Anchor.center;
    bouncyBall.position = Vector2(-120, -70);
    tick.position = Vector2(230, -90);
    rebuild();
    await setTempo();
  }

  Future<void> setTempo() async {
    await getSettings();
    bouncyBall.isVisible = showBall;
    beatSeconds = await tempo.loadBeatSeconds();
  }

  @override
  void update(double dt) {
    if (showGhostNotes) {
      //showGhostNote(gameController.noteChecker.noteNotifier.value);
    }
    if (showBall) {
      gameTime += dt; // todo extract this timing shit.
      while (gameTime > beatSeconds) {
        gameTime -= beatSeconds;
      }
      if (gameTime < 0) {
        gameTime = 0;
      }
      bouncyBall.positionBall(gameTime / beatSeconds);
    }
    if (rebuildQueued) rebuild();
    super.update(dt);
  }


  void newNote(NoteData data) {
    // Change this to just change the note.
    Utils.removeAllChildren(componentHolder);
    PositionComponent clefHolder = PositionComponent();
    clefSprite = noteData.clef.sprite..positionSprite();
    componentHolder.add(clefHolder);
    noteData = data;
    note = Note(noteData)..position = Vector2(40, 0);
    componentHolder.add(note);
    clefHolder.add(clefSprite);
    clefHolder.position = Vector2(-70, 0);
  }

  void showGhostNote(int num) {
    // num -= gameController
    //     .player.selectedInstrument.currentTransposition.pitchModifier;
    // if (num == previousGhostNote) return;
    // ghostNoteHolder.children.toList().forEach((child) {
    //   child.removeFromParent();
    // });
    // if (num < -500) {
    //   previousGhostNote = -1001;
    //   return;
    // }
    // NoteData d = noteGenerator.noteFromNumber(num, noteData.clef);
    // if (num == gameController.noteChecker.noteToCheck - gameController
    //     .player.selectedInstrument.currentTransposition.pitchModifier){
    //   d = noteData;
    // }
    // ghostNote = Note(d, isGhostNote: true)..position = Vector2(170, 0);
    
    // ghostNoteHolder.add(ghostNote);
    // previousGhostNote = num;
  }

  void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: Vector2(staffWidth() + (showGhostNotes ? ghostNoteExtension : 0),
            lineWidth),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(-staffWidth() / 2, i * lineGap);
      world.add(newLine);
    }
  }

  void getAndSetNote() {
    noteData = gameController.currentNote.value.data;
    newNote(noteData);
    // print(noteData.name);
  }

  @override
  Color backgroundColor() => Colors.white;
}
