import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';

class ServerLoader {
  final supabase = Supabase.instance.client;
Stream<List<Map<String, dynamic>>> getData(int categoryId) {
  return supabase
      .from('single_player_data')
      .stream(primaryKey: ['id'])  // Stream starts here
      .eq('category_id', categoryId); // Apply filter before assigning
}
  Future<GameOptions> loadGameOptions(
      GameOptions currentOptions, int id) async {
    final response = await supabase
        .from('single_player_data')
        .select()
        .eq('id', id)
        .single();
    GameOptions newGameOptions = GameOptions(
      version: currentOptions.version,
      t: response['top'],
      b: response['bottom'],
      tr: response['transposition'],
      tCT: response['treble_clef_threshold'],
      bCT: response['bass_clef_threshold'],
      cS: response['clef_selection'],
      nS: response['notes'].cast<bool>(),
      kS: response['key_signature'],
    );
    return newGameOptions;
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await supabase.from('categories').select();

    return response;
  }
}
