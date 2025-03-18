import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/incremental/unlockables/idle_note.dart';
import 'package:toolkit/game_modes/incremental/widgets/test_note_segment.dart';

class TestNoteList extends StatelessWidget {
  final List<IdleNote> idleNotes;
  
  const TestNoteList({
    super.key,
    required this.idleNotes,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optional header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(width: 100, child: Text('Note')),
                  SizedBox(width: 100, child: Text('Production')),
                  SizedBox(width: 80, child: Text('Owned')),
                  SizedBox(width: 100, child: Text('Cost')),
                ],
              ),
            ),
            // List of segments
            ...idleNotes.map((note) => TestNoteSegment(idleNote: note)),
          ],
        ),
      ),
    );
  }
}