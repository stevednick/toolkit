import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state_manager.dart';
import 'package:toolkit/models/game_mode.dart';
import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/widgets/transposition_drop_down.dart';

class SimpleGameTranspositionDropdown extends ConsumerWidget {
  final Player player;
  const SimpleGameTranspositionDropdown({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(simpleGameStateProvider);
    return Positioned(
      top: 40,
      left: 40,
      child: provider.gameMode == GameMode.waitingToStart
          ? TranspositionDropDown(
              player: player,
            )
          : Text(
              "Horn in ${player.selectedInstrument.currentTransposition.name}",
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
    );
  }

}
