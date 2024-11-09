import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:toolkit/components/note.dart';
import 'package:toolkit/game_modes/buzz_cave/buzz_cave_controller.dart';
import 'package:toolkit/tools/note_generator.dart';

class BuzzCaveOptionsScene extends FlameGame with VerticalDragDetector, HasVisibility {

  final Vector2 viewSize = Vector2(450, 500);
  final double staffWidth = 450;

  late BuzzCaveController gameController;

  final NoteGenerator noteGenerator = NoteGenerator();
  late Note note;

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    camera.viewfinder.visibleGameSize = viewSize;
    camera.viewfinder.anchor = Anchor.center;
  }

}