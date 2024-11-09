import 'package:flutter/material.dart';
import 'package:toolkit/tools/note_getter.dart';
import 'package:toolkit/tools/pitch_getter.dart';

class NoteChecker {

  PitchGetter pitchGetter = PitchGetter();
  int noteToCheck = -999;
  int requiredCorrectValues = 6;

  ValueNotifier<int> noteNotifier = ValueNotifier(0);

  Function() onNoteHeard;
  Function(int) noteFeedback;
  final List<int> lastDetectedNotes = [];

  NoteChecker(this.onNoteHeard, this.noteFeedback) {
    print("Note Checker Opened");
    pitchGetter.pitchNotifier.addListener(_onPitchDetected);
  }

  void _onPitchDetected() {
    noteNotifier.value =
        NoteGetter().getNotefromFrequency(pitchGetter.pitchNotifier.value);
    print(noteNotifier.value);
    noteFeedback(noteNotifier.value-noteToCheck);
    lastDetectedNotes.add(noteNotifier.value);
    if (lastDetectedNotes.length > 8) {
      lastDetectedNotes.removeAt(0); // Remove the oldest note
    }
    int count = lastDetectedNotes.where((note) => note == noteToCheck).length;
    if (count >= requiredCorrectValues) {
      onNoteHeard();
    }
  }

  void initialize() async {
    pitchGetter.startListening();
    print("Note Checker Initialised");
  }
 
  void dispose() async {
    pitchGetter.stopListening();
  }
}
