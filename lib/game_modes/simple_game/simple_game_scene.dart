import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/bouncy_ball.dart';
import 'package:toolkit/components/note.dart';
import 'package:toolkit/components/tick.dart';
import 'package:toolkit/config.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/settings.dart';
import 'package:toolkit/models/tempo.dart';
import 'package:toolkit/tools/note_generator.dart';

class SimpleGameScene extends FlameGame {
  final SimpleGameController gameController;

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

  SimpleGameScene(this.gameController) {
    getGhostNotesOn();
    getTempoOn();
    gameController.player.currentNote.addListener(() {
      getAndSetNote();
    });
    gameController.state.addListener(() {
      if (gameController.state.value == GameState.correctNoteHeard) {
        tick.showTick();
      }
    });
    gameController.gameMode.addListener(() {
      setTempo();
    });
  }

  Future<bool> getGhostNotesOn() async {
    Settings settings = Settings();
    showGhostNotes =  await settings.getGhostNotesOn();
    return showGhostNotes;
  }

  Future<void> setGhostNotesOn() async {
    Settings settings = Settings();
    settings.saveGhostNotesOn(showGhostNotes);
  }

    Future<bool> getTempoOn() async {
    Settings settings = Settings();
    showGhostNotes =  await settings.getTempoOn();
    return showGhostNotes;
  }

  Future<void> setTempoOn() async {
    Settings settings = Settings();
    settings.saveTempoOn(showBall);
  }

  void rebuild() {
    world.children.toList().forEach((child) {
      child.removeFromParent();
    });
    world.add(componentHolder);
    if (showGhostNotes) world.add(ghostNoteHolder);
    drawLines();
    world.add(tick);
    world.add(bouncyBall);
    rebuildQueued = false;
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    world.add(componentHolder);
    world.add(ghostNoteHolder);
    camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.anchor = Anchor.center;
    drawLines();
    world.add(bouncyBall); // todo extract bouncyBall stuff...
    bouncyBall.position = Vector2(-120, -70);
    tick.position = Vector2(230, -90);
    world.add(tick); // todo extract tick stuff...
    // arrow.position = Vector2(190, 0);
    // world.add(arrow); // todo you know...
    await setTempo();
  }

  Future<void> setTempo() async {
    Settings settings = Settings();
    showBall = await settings.getTempoOn();
    bouncyBall.isVisible = showBall;
    beatSeconds = await tempo.loadBeatSeconds();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (showGhostNotes) {
      showGhostNote(gameController.noteChecker.noteNotifier.value);
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
  }

  @override
  void onDispose() {
    super.onDispose();
    gameController.player.currentNote.removeListener(getAndSetNote);
    gameController.dispose();
  }

  void newNote(NoteData data) {
    // Change this to just change the note.
    componentHolder.children.toList().forEach((child) {
      child.removeFromParent();
    });
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
    num -= gameController
        .player.selectedInstrument.currentTransposition.pitchModifier;
    if (num == previousGhostNote) return;
    ghostNoteHolder.children.toList().forEach((child) {
      child.removeFromParent();
    });
    if (num < -500) {
      previousGhostNote = -1001;
      return;
    }
    NoteData d = noteGenerator.noteFromNumber(num, noteData.clef);
    if (num == gameController.noteChecker.noteToCheck - gameController
        .player.selectedInstrument.currentTransposition.pitchModifier){
      d = noteData;
    }
    ghostNote = Note(d, isGhostNote: true)..position = Vector2(170, 0);
    
    ghostNoteHolder.add(ghostNote);
    previousGhostNote = num;
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
    noteData = gameController.getNoteDataFromPlayer();
    newNote(noteData);
  }

  @override
  Color backgroundColor() => Colors.white;
}
