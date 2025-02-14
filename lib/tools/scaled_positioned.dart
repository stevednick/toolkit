import 'package:flutter/material.dart';

class ScaledPositioned extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final Widget child;
  final double scaleFactor;

  const ScaledPositioned({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.scaleFactor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left != null ? left! * scaleFactor : null,
      top: top != null ? top! * scaleFactor : null,
      right: right != null ? right! * scaleFactor : null,
      bottom: bottom != null ? bottom! * scaleFactor : null,
      child: Transform.scale(
        scale: scaleFactor,
        child: child,
      ),
    );
  }
}