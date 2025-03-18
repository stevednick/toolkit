import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/incremental_game_old/models/incremental_formulas.dart';
import 'package:toolkit/game_modes/incremental_game_old/models/models.dart';
import 'package:toolkit/game_modes/incremental_game_old/models/unlockable_note.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/tools.dart';

class IncrementalGameController {
  final String currencyName = "Bravo Bucks";
  ValueNotifier<double> money = ValueNotifier(1000.0);
  late ValueNotifier<UnlockableNote> currentNote = ValueNotifier(UnlockableNote.noteList[0]);

  late NoteChecker noteChecker;

  List<UnlockableNote> noteList = UnlockableNote.noteList;

  GameMode mode = GameMode.waitingToStart;

  IncrementalGameController() {
    noteChecker = NoteChecker(correctNoteHeard, (int _) {});
    //loadNote();
  }

  void startButtonPressed() {
    mode = GameMode.running;
    noteChecker.initialize();
    loadNote();
  }

  void correctNoteHeard() {
    loadNote();
    money.value += IncrementalFormulas.playingReward(currentNote.value.num, getNumberOfUnlockedNotes(noteList)); // todo sort the money thing. 
    // if (state.value == GameState.listening) {
    //   triggerTick();
    //   _incrementScore();
    //   _waitAndChangeNote();
    //   state.value = GameState.correctNoteHeard;
    // }
  }

  void unlockNote(){
    int unlockedNotes = getNumberOfUnlockedNotes(noteList);
    double cost = IncrementalFormulas.noteUnlockCost(unlockedNotes);
    if (money.value > cost && unlockedNotes < noteList.length -1){
      money.value -= cost;
      noteList[unlockedNotes+1].unlock();
    }
  }

  Future<void> loadNote() async {
    await noteList.first.loadIsUnlocked();
    currentNote.value = findRandomUnlockedNote(noteList)!;
    noteChecker.noteToCheck = currentNote.value.data.noteNum -7;
  }

  void dispose(){
    noteChecker.dispose();
  }

}

int getNumberOfUnlockedNotes(List<UnlockableNote> notes) {
  final unlockedNotes = notes.where((note) => note.isUnlocked).toList();
  return unlockedNotes.length;
}

UnlockableNote? findRandomUnlockedNote(List<UnlockableNote> notes) {
  // Filter the list to only include unlocked notes
  final unlockedNotes = notes.where((note) => note.isUnlocked).toList();

  // If there are no unlocked notes, return null
  if (unlockedNotes.isEmpty) {
    return null;
  }

  // Generate a random index
  final random = Random();
  final randomIndex = random.nextInt(unlockedNotes.length);

  // Return the randomly selected unlocked note
  return unlockedNotes[randomIndex];
}
