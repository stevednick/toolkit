import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:toolkit/scenes/range_selection/range_selection_position_manager.dart';

class DragHandler {
  final Function(bool isTop, bool up) onValueChange;
  final RangeSelectionPositionManager positionManager;
  final double dragCutOff;

  List<bool> isDragging = [false, false];
  double dragValue = 0;

  DragHandler({
    required this.onValueChange,
    required this.positionManager,
    this.dragCutOff = 25,
  });

  void onVerticalDragStart(DragStartInfo info) {
    Vector2 pos = info.eventPosition.widget;
    for (var i = 0; i < 2; i++) {
      if (pos.x > positionManager.dragBoxStart()[i].x &&
          pos.x < positionManager.dragBoxStart()[i].x + positionManager.dragBoxSize().x) {
        if (pos.y > positionManager.dragBoxStart()[i].y && pos.y < positionManager.dragBoxStart()[i].y + positionManager.dragBoxSize().y) {
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
