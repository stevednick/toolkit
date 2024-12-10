import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/scenes/note_icon.dart';

class NoteIconHolder extends StatelessWidget {
  final NoteData note;
  const NoteIconHolder(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 166,
      child: GameWidget(
        game: NoteIcon(note),
      )
    );
  }
}