import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class DragHandler {
  final Function(bool isTop, bool up) onValueChange;
  final List<Vector2> dragBoxStarts;
  final Vector2 dragBoxSize;
  final double dragCutOff;
  final double clefOffset;

  List<bool> isDragging = [false, false];
  double dragValue = 0;

  DragHandler({
    required this.onValueChange,
    required this.dragBoxStarts,
    required this.dragBoxSize,
    this.dragCutOff = 25,
    this.clefOffset = 0,
  });

  void onVerticalDragStart(DragStartInfo info) {
    Vector2 pos = info.eventPosition.widget;
    for (var i = 0; i < 2; i++) {
      if (pos.x > dragBoxStarts[i].x &&
          pos.x < dragBoxStarts[i].x + dragBoxSize.x + (i == 1 ? clefOffset + 100 : 0)) {
        if (pos.y > dragBoxStarts[i].y && pos.y < dragBoxStarts[i].y + dragBoxSize.y) {
          isDragging[i] = true;
          dragValue = 0;
        }
      }
    }
    print("Dragging");
  }

  void onVerticalDragUpdate(DragUpdateInfo info) {
    void checkDragging(bool isIncrementingUp) {
      for (var i = 0; i < 2; i++) {
        if (isDragging[i]) {
          onValueChange(i == 0, isIncrementingUp);
        }
      }
    }

    dragValue -= info.delta.global.y;
    if (dragValue > dragCutOff) {
      dragValue -= dragCutOff;
      checkDragging(true);
    }
    if (dragValue < -dragCutOff) {
      dragValue += dragCutOff;
      checkDragging(false);
    }
  }

  void onVerticalDragEnd(DragEndInfo info) {
    isDragging = [false, false];
  }
}
