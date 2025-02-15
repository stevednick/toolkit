
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class LedgerLine extends RectangleComponent implements OpacityProvider {
  double _opacity = 1.0;

  LedgerLine({
    required Vector2 super.size,
    required Paint super.paint,
    super.position,
    super.priority,
  });

  @override
  double get opacity => _opacity;

  @override
  set opacity(double value) {
    _opacity = value.clamp(0.0, 1.0);
    paint.color = paint.color.withOpacity(_opacity);
  }
}