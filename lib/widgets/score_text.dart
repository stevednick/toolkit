import 'package:flutter/material.dart';
import 'package:toolkit/models/player.dart';

class ScoreText extends StatelessWidget {
  const ScoreText({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: player.score,
      builder: (context, score, child) {
        return Text(
          'Score: $score',
          style: const TextStyle(fontSize: 30, color: Colors.black),
        );
      },
    );
  }
}
