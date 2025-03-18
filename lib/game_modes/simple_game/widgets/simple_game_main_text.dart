import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state_manager.dart';

class SimpleGameMainText extends ConsumerWidget{
  const SimpleGameMainText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(simpleGameStateProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          provider.gameText,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
