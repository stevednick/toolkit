import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/incremental/credits/incremental_formulas.dart';
import 'package:toolkit/game_modes/incremental/unlockables/idle_note.dart';

class TestNoteSegment extends StatefulWidget {

  final IdleNote idleNote;
  
  const TestNoteSegment({super.key, required this.idleNote});

  @override
  State<TestNoteSegment> createState() => _TestNoteSegmentState();
}

class _TestNoteSegmentState extends State<TestNoteSegment> {
  final IncrementalFormulas formulas = IncrementalFormulas();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.idleNote.data.name),
        Text(formulas.production(widget.idleNote).toString()),
        Text(widget.idleNote.owned.toString()),
        Text(formulas.cost(widget.idleNote).toString()),
      ],
    );
  }
}