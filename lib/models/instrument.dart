import 'dart:async';

import 'package:toolkit/models/transposition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolkit/tools/shared_prefs_manager.dart';

class Instrument {
  final String name;
  final Transposition preferredTransposition;
  final List<Transposition> availableTranspositions;
  final String playerKey;

  late Transposition currentTransposition;

  Instrument({
    required this.name,
    required this.preferredTransposition,
    required this.availableTranspositions,
    required this.playerKey,
  }) {
    _loadTransposition();
  }

  // Method to change the current transposition and persist it
  Future<void> setTransposition(Transposition transposition) async {
    if (availableTranspositions.contains(transposition)) {
      currentTransposition = transposition;
      await _saveTransposition();
    } else {
      throw Exception(
          "$transposition is not available for the instrument $name.");
    }
  }

  Future<Transposition> getTransposition() async {
    await _loadTransposition();
    return currentTransposition;
  }

  // Check if a specific transposition is available
  bool isTranspositionAvailable(Transposition transposition) {
    return availableTranspositions.contains(transposition);
  }

  // Save the current transposition to persistent storage
  Future<void> _saveTransposition() async {
    await SharedPrefsManager.save<String>('$playerKey-$name-transposition', currentTransposition.name);
  }

  // Load the transposition from persistent storage
  Future<void> _loadTransposition() async {
    String? savedTransposition = await SharedPrefsManager.load<String>('$playerKey-$name-transposition');
    if (savedTransposition != null) {
      currentTransposition = Transposition.transpositions.firstWhere(
        (transposition) => transposition.name == savedTransposition,
        orElse: () => preferredTransposition,
      );
    } else {
      currentTransposition = preferredTransposition;
    }
  }



  // Factory methods to create new instances of instruments with a player's key
  static Instrument createHorn(String playerKey) {
    return Instrument(
      name: "Horn",
      preferredTransposition: Transposition.f,
      availableTranspositions: Transposition.transpositions,
      playerKey: playerKey,
    );
  }

  static Instrument createTrumpet(String playerKey) {
    return Instrument(
      name: "Trumpet",
      preferredTransposition: Transposition.bFlatAlto,
      availableTranspositions: [
        Transposition.bFlatAlto,
        //Transposition.c,
      ],
      playerKey: playerKey,
    );
  }

  static Instrument createClarinet(String playerKey) {
    return Instrument(
      name: "Clarinet",
      preferredTransposition: Transposition.eFlat,
      availableTranspositions: [
        Transposition.eFlat,
        Transposition.bFlatAlto,
      ],
      playerKey: playerKey,
    );
  }
    Future<Transposition> loadCurrentTransposition() async {
    await _loadTransposition(); // Existing method to load from storage
    return currentTransposition;
  }
  //   static List<Instrument> instruments = [
  //   horn,
  //   trumpet,
  //   //clarinet,
  // ];
  //   static Instrument? getInstrumentByName(String name) {
  //   return instruments.firstWhere((instrument) => instrument.name == name, orElse: () => Instrument.horn);
  // }
}
