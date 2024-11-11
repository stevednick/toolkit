import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit/models/accidental.dart';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/clef_selection.dart';
import 'package:toolkit/models/clef_threshold.dart';

import 'package:toolkit/models/instrument.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/range.dart';

import 'transposition.dart';

class Player {
  final String playerKey;
  late Range range;
  late ClefThreshold clefThreshold;
  late Instrument selectedInstrument;
  late ClefSelection clefSelection;
  ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<NoteData> currentNote = ValueNotifier(NoteData.placeholderValue);


  Player({required this.playerKey}) {
    selectedInstrument = Instrument.createHorn(playerKey);
    clefSelection = ClefSelection.treble; // Default to treble
    _loadRange();
    _loadInstrumentAndTransposition();
  }

  Future<bool> _loadInstrumentAndTransposition() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Load the transposition
      String? transpositionName = prefs.getString('${playerKey}_transposition');
      if (transpositionName != null) {
        Transposition? transposition = Transposition.getByName(transpositionName);
        if (transposition != null && selectedInstrument.isTranspositionAvailable(transposition)) {
          selectedInstrument.setTransposition(transposition);
        }
      }

      // Load the clef
      String? clefName = prefs.getString('${playerKey}_clef');
      if (clefName != null) {
        clefSelection = ClefSelection.values.firstWhere(
          (e) => e.toString().split('.').last == clefName,
          orElse: () => ClefSelection.treble,
        );
      }
      print(ClefSelection.values);

      return true;
    } catch (e) {
      print('Error loading instrument, transposition, or clef: $e');
      return false;
    }
  }

  void _loadRange() {
    range = Range(
        bottomKey: '${playerKey}_bottom_key', topKey: '${playerKey}_top_key');
    clefThreshold = ClefThreshold(
      trebleKey: '${playerKey}_treble_threshold_key', bassKey: '${playerKey}_bass_threshold_key'
    );
  }

  Future<bool> saveInstrumentAndTransposition(Transposition transposition) async {
    try {
      selectedInstrument.setTransposition(transposition);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool transpositionSaved = await prefs.setString('${playerKey}_transposition', transposition.name);

      // Save the clef selection
      bool clefSaved = await prefs.setString('${playerKey}_clef', clefSelection.toString().split('.').last);
      print("Clef Saved: $clefSaved");
      return transpositionSaved && clefSaved;
    } catch (e) {
      print('Error saving instrument, transposition, or clef: $e');
      return false;
    }
  }

  Future<ClefSelection> getClefSelection() async{
    await _loadInstrumentAndTransposition();
    return clefSelection;
  }

  int getNoteToCheck(){
    return currentNote.value.noteNum + selectedInstrument.currentTransposition.pitchModifier;
  }

  void incrementScore(int by){
    score.value += by;
  }
}
