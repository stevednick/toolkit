import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit/models/clef_selection.dart';
import 'package:toolkit/models/clef_threshold.dart';

import 'package:toolkit/models/instrument.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signatures.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/range.dart';
import 'package:toolkit/tools/shared_prefs_manager.dart';

import '../transposition.dart';

class Player {
  final String playerKey;
  late Range range;
  late ClefThreshold clefThreshold;
  late Instrument selectedInstrument;
  late ClefSelection clefSelection;
  ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<NoteData> currentNote = ValueNotifier(NoteData.placeholderValue);
  late KeySignature keySignature;


  Player({required this.playerKey}) {
    selectedInstrument = Instrument.createHorn(playerKey);
    clefSelection = ClefSelection.treble; // Default to treble
    loadKeySignature();
    loadRange();
    loadInstrumentAndTransposition();
    //('Player created with key: $playerKey');
  }

  Future<KeySignature> loadKeySignature() async {
    int keySigInt = await loadKeySignatureInt();
    keySignature = KeySignatures.list[keySigInt];
    return keySignature;
  }

  Future<int> loadKeySignatureInt() async {
    try{

      int keySignatureInt = await SharedPrefsManager.load<int>('${playerKey}_key_signature') ?? 0;
      return keySignatureInt;
    }  catch (e) {
      print('Error loading key signature: $e');
      return -1;
    }
  }

  Future<void> saveKeySignature(int newValue) async {
    try{
      await SharedPrefsManager.save<int>('${playerKey}_key_signature', newValue);
    }  catch (e) {
      print('Error saving key signature: $e');
    }
  }

  Future<bool> loadInstrumentAndTransposition() async {
    try {
      String? transpositionName = await SharedPrefsManager.load<String>('${playerKey}_transposition');

      // Load the transposition
      if (transpositionName != null) {
        Transposition? transposition = Transposition.getByName(transpositionName);
        if (transposition != null && selectedInstrument.isTranspositionAvailable(transposition)) {
          selectedInstrument.setTransposition(transposition);
        }
      }

      // Load the clef
      String? clefName = await SharedPrefsManager.load<String>('${playerKey}_clef');
      if (clefName != null) {
        clefSelection = ClefSelection.values.firstWhere(
          (e) => e.toString().split('.').last == clefName,
          orElse: () => ClefSelection.treble,
        );
      }

      return true;
    } catch (e) {
      print('Error loading instrument, transposition, or clef: $e');
      return false;
    }
  }

  void loadRange() {
    range = Range(
        bottomKey: '${playerKey}_bottom_key', topKey: '${playerKey}_top_key');
    clefThreshold = ClefThreshold(
      trebleKey: '${playerKey}_treble_threshold_key', bassKey: '${playerKey}_bass_threshold_key'
    );
    //print(range.top);
  }

  Future<bool> saveInstrumentAndTransposition(Transposition transposition) async {
    try {
      selectedInstrument.setTransposition(transposition);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool transpositionSaved = await prefs.setString('${playerKey}_transposition', transposition.name);

      // Save the clef selection
      bool clefSaved = await prefs.setString('${playerKey}_clef', clefSelection.toString().split('.').last);
      // print("Clef Saved: $clefSaved");
      return transpositionSaved && clefSaved;
    } catch (e) {
      print('Error saving instrument, transposition, or clef: $e');
      return false;
    }
  }

  Future<ClefSelection> getClefSelection() async{
    await loadInstrumentAndTransposition();
    return clefSelection;
  }

  int getNoteToCheck(){
    return currentNote.value.noteNum + selectedInstrument.currentTransposition.pitchModifier;
  }

  int addPitchModifier(int num){
    return num + selectedInstrument.currentTransposition.pitchModifier;
  }

  void incrementScore(int by){
    score.value += by;
  }
}
