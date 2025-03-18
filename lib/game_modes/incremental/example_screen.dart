import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/incremental/incremental_view.dart';
import 'package:toolkit/game_modes/incremental/unlockables/idle_note.dart';
import 'package:toolkit/game_modes/incremental/unlockables/idle_note_list.dart';

class ExampleScreen extends StatelessWidget {
  late List<IdleNote> notes; // Your list of idle notes

  ExampleScreen({
    super.key
  }){
    notes = IdleNoteList().list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note List'),
      ),
      body: TestNoteList(idleNotes: notes),
    );
  }
}