import 'dart:math';

import 'package:toolkit/models/models.dart';

class DifficultyManager {
  final Player player;
  final List<NoteData> octave = NoteData.octave;

  DifficultyManager({required this.player});

  Future<double> calculateDifficulty() async {
    await player.range.loadValues();
    await player.loadInstrumentAndTransposition();
    final rangeCount = player.range.top - player.range.bottom;
    final activeNoteCount = getActiveNotesInOctave();
    final clefThresholds = await player.clefThreshold.getValues();
    clefThresholds[0] = max(clefThresholds[0], player.range.bottom);
    clefThresholds[1] = min(clefThresholds[1], player.range.top);
    int clefThresholdCount = clefThresholds[1] - clefThresholds[0];
    if (player.clefSelection != ClefSelection.trebleBass) clefThresholdCount = 0;
    // print("Clef Threshold Count $clefThresholdCount, range: $rangeCount, active notes: $activeNoteCount");
    return (1 + (rangeCount-1)/24) * (1 + (activeNoteCount-1)/17) * (1 + (clefThresholdCount/12));
  }

  int getActiveNotesInOctave(){
    int total = 0;
    for (NoteData note in octave){
      if (note.isActive) total += 1;
    }
    return total;
  }
}