import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signatures.dart';
import 'package:toolkit/models/player/player.dart';

final keySignatureProvider = StateNotifierProvider.family<KeySignatureNotifier, KeySignature, Player>(
  (ref, player) => KeySignatureNotifier(player),
);

class KeySignatureNotifier extends StateNotifier<KeySignature> {
  final Player _player;

  KeySignatureNotifier(this._player) : super(KeySignatures.list.first) {
    _loadCurrentKey();
  }

  Future<void> _loadCurrentKey() async {
    final index = await _player.loadKeySignatureInt();
    if (index < KeySignatures.list.length) {
      state = KeySignatures.list[index];
    }
  }

  void changeKey(KeySignature newKey) {
    _player.saveKeySignature(KeySignatures.list.indexOf(newKey));
    state = newKey;
  }
}
