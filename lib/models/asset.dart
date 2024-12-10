import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Asset extends SpriteComponent with HasGameReference, HasVisibility {
  final Vector2 pos;
  final Vector2 sca;
  final String imagePath;
  final Color colour;

  Asset(this.pos, this.sca, this.imagePath, this.colour);
  @override
  Future<FutureOr<void>> onLoad() async {
    await super.onLoad(); 
    changeColour(colour);
     // Ensure base class's onLoad is awaited
    sprite = await game.loadSprite(imagePath);
    size = sca;
    position = pos;
  }

  void positionSprite() {
    position = pos;  // Ensure 'pos' is defined
  }

  void changePosition(Vector2 adjustment) {
    position += adjustment;  // Adjust position by the given vector
  }

  void changeColour(Color colour) {
    paint = Paint()..colorFilter = ColorFilter.mode(colour, BlendMode.srcIn);
  }

  static Asset createCrotchet({Color colour = Colors.black}) => Asset(Vector2(0, -87), Vector2(34, 100), 'crotchet.png', colour);
  static Asset createInvertedCrotchet({Color colour = Colors.black}) => Asset(Vector2(0, -11), Vector2(34, 100), 'invertedCrotchet.png', colour);
  static Asset createSharp({Color colour = Colors.black}) => Asset(Vector2(-40, -27), Vector2(28, 56), 'sharp.png', colour);
  static Asset createDoubleSharp({Color colour = Colors.black}) => Asset(Vector2(-42, -14), Vector2(25, 29), 'doubleSharp.png', colour);
  static Asset createFlat({Color colour = Colors.black}) => Asset(Vector2(-38, -35), Vector2(25, 51), 'flat.png', colour);
  static Asset createDoubleFlat({Color colour = Colors.black}) => Asset(Vector2(-44, -40), Vector2(40, 55), 'doubleFlat.png', colour);
  static Asset createTrebleClef() => Asset(Vector2(-50, -88), Vector2(100, 185), 'treble.png', Colors.black);
  static Asset createBassClef() => Asset(Vector2(-30, -49), Vector2(70, 81), 'bass.png', Colors.black);
  static Asset createArrow() => Asset(Vector2(49, -19), Vector2(20, 40), 'arrows.png', Colors.blue);
  static Asset createTick() => Asset(Vector2.zero(), Vector2(70, 80), 'tick.png', Colors.green);
  static Asset createFeedbackArrow() => Asset(Vector2.zero(), Vector2(100, 100), 'arrow.png', Colors.black);
}
