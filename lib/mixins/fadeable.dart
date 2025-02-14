import 'package:flame/components.dart';
import 'package:flame/effects.dart';

mixin Fadeable on PositionComponent {
  List<PositionComponent> get fadeableComponents;

  Future<void> fadeIn({double duration = 1.0}) async {
    for (var component in fadeableComponents) {
      for (var child in component.children) {
        if (child is OpacityProvider) {
          child.add(OpacityEffect.fadeIn(EffectController(duration: duration)));
        }
      }
    }
  }

  Future<void> fadeOut({double duration = 1.0}) async {
    for (var component in fadeableComponents) {
      for (var child in component.children) {
        if (child is OpacityProvider) {
          child.add(OpacityEffect.fadeOut(EffectController(duration: duration)));
        }
      }
    }
  }
}