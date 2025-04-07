import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/widgets/key_signature_dropdown.dart';

class SimpleGameKeySignatureDropdown extends ConsumerWidget {
  final Player player;
  final dynamic Function() onChanged;

  const SimpleGameKeySignatureDropdown({super.key, required this.player, required this.onChanged});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Positioned(
      top: 40,
      right: 40,
      child: KeySignatureDropdown(
        player: player,
        onChanged: () {
          onChanged();
        },
      ),
    );
  
  }

}