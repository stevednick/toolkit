import 'package:flame/components.dart';
import 'package:flame/effects.dart';

mixin Fadeable on PositionComponent {
  List<PositionComponent> get fadeableComponents;
  List<PositionComponent> get noteComponents;

  Future<void> fadeIn({double duration = 1.0, bool fadeNotes = false}) async {
    add(OpacityEffect.fadeIn(EffectController(duration: duration)));
    List<PositionComponent> componentsToFade = fadeNotes ? noteComponents : fadeableComponents;
    for (var component in componentsToFade) {
      if (component is OpacityProvider) {
        component.add(OpacityEffect.fadeIn(EffectController(duration: duration)));
      }
      for (var child in component.children) {
        if (child is OpacityProvider) {
          child.add(OpacityEffect.fadeIn(EffectController(duration: duration)));
        }
      }
    }
  }

  Future<void> fadeOut({double duration = 1.0, bool fadeNotes = false}) async {
    add(OpacityEffect.fadeOut(EffectController(duration: duration)));
    List<PositionComponent> componentsToFade = fadeNotes ? noteComponents : fadeableComponents;
    for (var component in componentsToFade) {
      if (component is OpacityProvider) {
        component.add(OpacityEffect.fadeOut(EffectController(duration: duration)));
      }
      for (var child in component.children) {
        if (child is OpacityProvider) {
          child.add(OpacityEffect.fadeOut(EffectController(duration: duration)));
        }
      }
    }
  }
}