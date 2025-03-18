import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signature_builder_data.dart';
import 'package:toolkit/models/key_signature/key_signature_note_modifier.dart';
import 'package:toolkit/models/key_signature/key_signatures.dart';
import 'package:toolkit/scenes/range_selection/range_selection.dart';
import 'package:toolkit/models/player/player.dart';

class RangeSelectionScene extends FlameGame  // todo sort key signature not loading properly at start. 
    with TapCallbacks, VerticalDragDetector, HasVisibility {
  final Player player;

  late DragHandler dragHandler;

  late RangeSelectionStave stave;

  late RangeSelectionPositionManager positionManager;

  late RangeSelectionNoteManager noteManager;

  late RangeSelectionNoteComponent noteComponent;

  late RangeSelectionClefComponent clefComponent;

  late RangeSelectionKeySignatureComponent keySignatureComponent;

  late RangeSelectionDataManager dataManager;

  late KeySignatureBuilderData data = KeySignatureBuilderData();

  final RangeSelectionBarLine barLine = RangeSelectionBarLine();

  double width = 1000;

  bool isSetUp = false;

  // List<bool> isDragging = [false, false];

  final bool isClefThresholds;

  late KeySignature keySignature;
  late KeySignatureNoteModifier keySignatureNoteModifier;

  RangeSelectionScene(this.player, {this.isClefThresholds = false});

  Future<void> setUp() async {
    await loadKeySignature();

    List<int> _ = await player.range.getValues(); // Delay for Timings.
    loadComponents();
    addComponents();
    sortScale();
    noteManager.checkAndHideBottomClef();
  }

  Future<void> loadKeySignature() async {
    keySignature = await player.loadKeySignature();
    if (isClefThresholds) {
      keySignature = KeySignatures.list[0];
    }
  }

  void loadComponents() {
    positionManager = RangeSelectionPositionManager(keySignature, width);
    stave = RangeSelectionStave(positionManager);
    keySignatureNoteModifier = KeySignatureNoteModifier(keySignature);
    keySignatureComponent =
        RangeSelectionKeySignatureComponent(keySignature, positionManager);

    // Wonky setup, but it works.
    noteManager = RangeSelectionNoteManager(keySignatureNoteModifier, player,
        isClefThresholds, keySignatureComponent, barLine);
    noteComponent = RangeSelectionNoteComponent(noteManager, positionManager);
    clefComponent = RangeSelectionClefComponent(noteManager, positionManager);
    noteManager.noteComponent = noteComponent;
    noteManager.clefComponent = clefComponent;
    dataManager =
        RangeSelectionDataManager(player, noteManager, isClefThresholds);
    noteManager.dataManager = dataManager;
    dragHandler = DragHandler(
      onValueChange: noteManager.changeValue,
      positionManager: positionManager,
    );
  }

  void sortScale() {
    camera = CameraComponent.withFixedResolution(width: positionManager.extendedStaveWidth(), height: positionManager.extendedStaveWidth());
    //camera.viewfinder.zoom = positionManager.scaleFactor();
    camera.viewfinder.anchor = Anchor.center;
  }

  void addComponents() {
    world.add(barLine);
    world.add(noteComponent);
    world.add(clefComponent);
    world.add(keySignatureComponent);
    world.add(stave);
  }

  Future<void> setWidth(double w) async {
    print("Setting width to $w");
    width = w;
    if (!isSetUp) {
      isSetUp = true;
      await setUp();
    }
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

  @override
  Color backgroundColor() => Colors.white;
}
