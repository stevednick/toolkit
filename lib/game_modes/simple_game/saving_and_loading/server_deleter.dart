import 'package:supabase_flutter/supabase_flutter.dart';

class ServerDeleter {
  final supabase = Supabase.instance.client;
  Future<void> delete(int id) async{
    await supabase.from('single_player_data').delete().eq('id', id);
  }
}