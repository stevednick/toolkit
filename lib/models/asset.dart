import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/flame.dart';

class Asset extends SpriteComponent with HasGameReference, HasVisibility {
  final Vector2 pos;
  final Vector2 sca;
  final String imagePath;
  final Color colour;

  //final Completer<void> _loadCompleter = Completer<void>();

  Asset(this.pos, this.sca, this.imagePath, this.colour);

  @override
Future<void> onLoad() async {
    final image = AssetManager().getImage(imagePath);
    sprite = Sprite(image);
    size = sca;
    position = pos;
    changeColour(colour);
    await super.onLoad();
  }

  /// Waits for the asset to finish loading
  //Future<void> get onLoaded => _loadCompleter.future;

  void positionSprite() {
    position = pos;
  }

  void changePosition(Vector2 adjustment) {
    position += adjustment;
  }

  void changeColour(Color colour) {
    paint = Paint()..colorFilter = ColorFilter.mode(colour, BlendMode.srcIn);
  }

  static Asset createCrotchet({Color colour = Colors.black}) =>
      Asset(Vector2(0, -87), Vector2(34, 100), 'crotchet.png', colour);

  static Asset createInvertedCrotchet({Color colour = Colors.black}) =>
      Asset(Vector2(0, -11), Vector2(34, 100), 'invertedCrotchet.png', colour);

  static Asset createSharp({Color colour = Colors.black}) =>
      Asset(Vector2(-40, -27), Vector2(28, 56), 'sharp.png', colour);

  static Asset createDoubleSharp({Color colour = Colors.black}) =>
      Asset(Vector2(-42, -14), Vector2(25, 29), 'doubleSharp.png', colour);

  static Asset createFlat({Color colour = Colors.black}) =>
      Asset(Vector2(-38, -35), Vector2(25, 51), 'flat.png', colour);

  static Asset createDoubleFlat({Color colour = Colors.black}) =>
      Asset(Vector2(-44, -40), Vector2(40, 55), 'doubleFlat.png', colour);

  static Asset createTrebleClef() =>
      Asset(Vector2(-50, -88), Vector2(100, 185), 'treble.png', Colors.black);

  static Asset createNatural({Color colour = Colors.black}) =>
      Asset(Vector2(-60, -30), Vector2(66, 62), 'natural.png', colour);

  static Asset createBassClef() =>
      Asset(Vector2(-30, -49), Vector2(70, 81), 'bass.png', Colors.black);

  static Asset createArrow() =>
      Asset(Vector2(49, -19), Vector2(20, 40), 'arrows.png', Colors.blue);

  static Asset createTick() =>
      Asset(Vector2.zero(), Vector2(70, 80), 'tick.png', Colors.green);

  static Asset createFeedbackArrow() => Asset(
      Vector2.zero(),
      Vector2(100, 100),
      'arrow.png',
      const Color.fromRGBO(234, 199, 199, 1));
}



class AssetManager {
  static final AssetManager _instance = AssetManager._internal();
  factory AssetManager() => _instance;
  AssetManager._internal();

  final Map<String, Image> _loadedImages = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final imagePaths = [
      'crotchet.png',
      'invertedCrotchet.png',
      'sharp.png',
      'flat.png',
      'doubleSharp.png',
      'doubleFlat.png',
      'natural.png',
      'arrows.png',
      'treble.png',
      'bass.png',
      'tick.png',
      'arrow.png',
    ];

    for (final path in imagePaths) {
      _loadedImages[path] = await Flame.images.load(path);
    }

    _isInitialized = true;
  }

  Image getImage(String path) {
    if (!_isInitialized) {
      throw StateError('AssetManager is not initialized');
    }
    return _loadedImages[path]!;
  }
}
