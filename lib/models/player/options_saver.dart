import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/models/clef_selection.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/models/transposition.dart';

class OptionsSaver {
  final Player player;
  OptionsSaver(this.player);

  Future<bool> saveOptions(GameOptions options) async {
    try {
      player.clefSelection = ClefSelection.values[options.cS];
      for (int i = 0; i < options.nS.length; i++) {
        NoteData.octave[i].isActive = options.nS[i];
        await NoteData.octave[i].saveIsActive();
      }
      player.clefThreshold
        ..trebleClefThreshold = options.tCT
        ..bassClefThreshold = options.bCT
        ..saveValues();
      player.range
        ..top = options.t
        ..bottom = options.b
        ..saveValues();
      await player.saveKeySignature(options.kS);
      await player.saveInstrumentAndTransposition(
        Transposition.getByName(options.tr) ??
            player.selectedInstrument.currentTransposition,
      
        );
        return true;
      } catch (error) {
        return false;
    }
  }
}
