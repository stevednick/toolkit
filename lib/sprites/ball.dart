import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class Ball extends CircleComponent {
  @override
  Future<void> onLoad() {
    radius = 30;
    return super.onLoad();
  }

  void hide(){
    _changeColour(Colors.white);
  }

  void show(){
    _changeColour(Colors.red);
  }

  void goGreen(){
    _changeColour(Colors.green);
  }

  void goRedAndDissappear(){
    _changeColour(Colors.red);
    // todo fix timer for dissapear;
    // todo remove rather than turn white?
  }

  void _changeColour(Color newColour){
    paint = Paint()
      ..color = newColour
      ..style = PaintingStyle.fill;
  }
}
