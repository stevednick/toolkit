import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/models/transposition.dart';

class TranspositionNotifier extends StateNotifier<Transposition> {
  TranspositionNotifier() : super(Transposition.f); // Default to F if no transposition selected.

  // Method to set the transposition
  Future<void> setTransposition(Transposition transposition, Player player) async{
    state = transposition;
    player.saveInstrumentAndTransposition(transposition);

  }

  // Method to load transposition data, here just a placeholder
  Future<void> loadCurrentTransposition(Player player) async {
    // Load your transposition data here
    // For now, let's assume it's loading the default one.
    await player.selectedInstrument.loadCurrentTransposition();
    state = player.selectedInstrument.currentTransposition;
  }
}

// Create a provider for TranspositionNotifier
final transpositionProvider =
    StateNotifierProvider<TranspositionNotifier, Transposition>((ref) {
  return TranspositionNotifier();
});
