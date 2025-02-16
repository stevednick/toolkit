import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/components/stave/stave_position_manager.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/tools/config.dart';

class StaveLines extends PositionComponent {

  late StavePositionManager positionManager;

  StaveLines(this.positionManager){
    drawLines();
  }

   void drawLines() {
    for (var i = -2; i < 3; i++) {
      RectangleComponent newLine = RectangleComponent(
        size: positionManager.staffLineSize(),
        paint: Paint()..color = Colors.black,
      )..position = Vector2(positionManager.staffLinePosX(), i * lineGap);
      add(newLine);
    }
  }

    Future<void> sequentialFade(
      Asset outSprite, Asset inSprite, double duration) async {
    await outSprite
        .add(OpacityEffect.fadeOut(EffectController(duration: duration)));
    await inSprite.add(OpacityEffect.fadeIn(DelayedEffectController(
        EffectController(duration: duration),
        delay: duration)));
  }
}