import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';

class ServerSaver {
Future<void> saveGameOptions(GameOptions gameOptions, String name, int categoryId) async {
  final supabase = Supabase.instance.client;
  print('Saving game options');

  await supabase.from('single_player_data').insert({
    'name': name,
    'top': gameOptions.t,
    'bottom': gameOptions.b,
    'transposition': gameOptions.tr,
    'treble_clef_threshold': gameOptions.tCT,
    'bass_clef_threshold': gameOptions.bCT,
    'clef_selection': gameOptions.cS,
    'key_signature': gameOptions.kS,
    'notes': gameOptions.nS,
    'category_id': categoryId, // Add category ID
  });
}

  Future<void> testConnection() async {
    try {
      print('🔍 Sending request to Supabase...');
      final response =
          await Supabase.instance.client.from('single_player_data').select();

      print('✅ Response received: $response');

      if (response.isEmpty) {
        print('⚠️ No data found. Check if your table has data.');
      } else {
        print('🎉 Data retrieved successfully: $response');
      }
    } catch (error, stacktrace) {
      print('❌ Supabase connection error: $error');
      print('Stacktrace: $stacktrace');
    }
  }
}
