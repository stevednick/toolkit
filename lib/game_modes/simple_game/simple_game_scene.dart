import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/components.dart';
import 'package:toolkit/game_modes/simple_game/game_timer.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/models/key_signature.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/tools.dart';

class SimpleGameScene extends FlameGame {
  final SimpleGameController gameController;
  final GameStateManager stateManager = GameStateManager();

  late Note ghostNote;
  int previousGhostNote = -556;
  bool ghostNoteLoadStarted = false;

  final NoteGenerator noteGenerator = NoteGenerator();

  bool loadComplete = false;

  late NoteData currentNoteData;
  late NoteData nextNote;
  bool noteChangeQueued = false;
  late Note note;

  late Asset clefSprite;
  PositionComponent clefHolder = PositionComponent();

  PositionComponent noteHolder = PositionComponent();
  PositionComponent ghostNoteHolder = PositionComponent();

  double width = 1000;
  double screenWidthRatio = 3;

  late PositionManager positionManager;

  Tick tick = Tick();

  final BouncyBall bouncyBall = BouncyBall();
  Tempo tempo = Tempo(key: 'simple_game_tempo');
  double beatSeconds = 1000;
  double gameTime = 0;

  late KeySignature keySignature;
  PositionComponent keySignatureHolder = PositionComponent();

  SimpleGameScene(
    this.gameController,
  );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    gameController.player.currentNote.addListener(() {
      queueNewNote(gameController.player.currentNote.value);
    });
    gameController.state.addListener(() {
      if (gameController.state.value == GameState.correctNoteHeard) {
        tick.showTick();
      }
    });

    stateManager.showGhostNotes = //  todo Move loading to state manager?
        await Settings.getSetting(Settings.ghostNoteString);
    stateManager.showBall = await Settings.getSetting(Settings.tempoKey);
    keySignature = await gameController.player.loadKeySignature();
    positionManager = PositionManager(keySignature, stateManager);
    await buildAllElements();
    gameController.noteChecker.noteNotifier.addListener(() {
      if (stateManager.showGhostNotes) {
        showGhostNote();
      }
    });
    camera.viewfinder.zoom = positionManager.scaleFactor(width, screenWidthRatio);
    print("Width: $width");
    camera.viewfinder.anchor = Anchor.center;
    loadComplete = true;
    gameController.changeNote();
    beatSeconds = await tempo.loadBeatSeconds();
  }

  Future<void> buildAllElements() async {
    
    keySignatureHolder.position = positionManager.keySignatureHolderPosition();
    world.add(keySignatureHolder);
    clefHolder.position = positionManager.clefHolderPosition();
    world.add(clefHolder);
    world.add(tick);
    tick.position = Vector2(250, -90);
    drawLines();
    currentNoteData = gameController.currentNote.value;
    bouncyBall.position = positionManager.bouncyBallPosition();
    world.add(bouncyBall);
    bouncyBall.isVisible = stateManager.showBall;
    await addGhostNote();
    await addNote();

  }

  Future<void> addGhostNote() async {
    ghostNote = Note(NoteData.octave[0], isGhostNote: true)
      ..position = positionManager.ghostNotePosition();

    world.add(ghostNoteHolder);
    ghostNoteHolder.add(ghostNote); // Add this line
    ghostNote.isVisible = false;
  }

  Future<void> addNote() async {
    world.add(noteHolder);
    note = Note(currentNoteData)
      ..position = positionManager.notePosition();
    noteHolder.add(note);
  }

  void queueNewNote(NoteData newNoteData) {
    nextNote = newNoteData;
    noteChangeQueued = true;
  }

  void changeNote() {
    if (loadComplete && noteChangeQueued) {
      currentNoteData = nextNote;
      currentNoteData = keySignature.noteModifier(currentNoteData);
      note.changeNote(currentNoteData);
      noteChangeQueued = false;
      Utils.removeAllChildren(clefHolder);
      clefSprite = currentNoteData.clef.sprite..positionSprite();
      clefHolder.add(clefSprite);
      Utils.removeAllChildren(keySignatureHolder);
      keySignatureHolder.add(keySignature.displayKeySignature(currentNoteData.clef));
    }
  }

  void showGhostNote() {
    int num = gameController.noteChecker.noteNotifier.value;
    num -= gameController
        .player.selectedInstrument.currentTransposition.pitchModifier;
    if (num == previousGhostNote) return;
    if (num < -500) {
      previousGhostNote = -1001;
      ghostNote.isVisible = false;
      return;
    }
 
    NoteData d = noteGenerator.noteFromNumber(num, currentNoteData.clef);
    d = keySignature.noteModifier(d, ghostNote: true);
    if (num ==
        gameController.noteChecker.noteToCheck -
            gameController
                .player.selectedInstrument.currentTransposition.pitchModifier) {
      d = currentNoteData;
    }

    ghostNote.changeNote(d);
    ghostNote.isVisible = true;
    previousGhostNote = num;
  }

  void updateBallPosition(double dt) {
    if (stateManager.showBall) {
      gameTime += dt; // todo extract this timing shit.
      while (gameTime > beatSeconds) {
        gameTime -= beatSeconds;
      }
      if (gameTime < 0) {
        gameTime = 0;
      }
      bouncyBall.positionBall(gameTime / beatSeconds);
    }
  }

  @override
  void update(double dt) {
    changeNote();
    updateBallPosition(dt);
    super.update(dt);
  }

  void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: positionManager.staffLineSize(),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(
          positionManager.staffLinePosX(), i * lineGap);
      world.add(newLine);
    }
  }

  @override
  Color backgroundColor() => Colors.white;
}

class GameStateManager {
  bool showGhostNotes = true;
  bool showBall = false;
}

class PositionManager {

  final KeySignature keySignature;
  final GameStateManager stateManager;
  final double staffWidth = 280;
  final double ghostNoteExtension = 130;
  PositionManager(this.keySignature, this.stateManager);

  Vector2 staffLineSize() {
    return Vector2(staffWidth + (stateManager.showGhostNotes ? ghostNoteExtension : 0) + keySignature.clefOffset(), lineWidth);
  }

  double staffLinePosX() {
    return 20 -staffWidth/2 - keySignature.clefOffset();
  }

  Vector2 notePosition() {
    return Vector2(40, 0);
  }

  Vector2 ghostNotePosition(){
    return Vector2(180, 0);
  }

  Vector2 bouncyBallPosition(){
    return Vector2(130 - (stateManager.showGhostNotes ? ghostNoteExtension / 2 : 0), -70);
  }

  Vector2 clefHolderPosition(){
    return Vector2(-70 - keySignature.clefOffset(), 0);
  }

  Vector2 keySignatureHolderPosition(){
    return Vector2(25-keySignature.clefOffset(), 0);
  }

  double scaleFactor(double width, double screenWidthRatio) {  // Move this to pos Man
    return width /
        ((staffWidth + (stateManager.showGhostNotes ? ghostNoteExtension : 0) + keySignature.clefOffset())*
            screenWidthRatio);
  }
}