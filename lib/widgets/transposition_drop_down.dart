import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/models/transposition.dart';
import 'package:toolkit/providers/transposition_provider.dart';

// The drop-down widget with Riverpod
class TranspositionDropDown extends ConsumerWidget {
  final Player player;

  const TranspositionDropDown({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the current transposition from the provider
    final currentTransposition = ref.watch(transpositionProvider);

    return FutureBuilder<void>(
      future: ref.read(transpositionProvider.notifier).loadCurrentTransposition(player),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.connectionState == ConnectionState.done) {
          return DropdownMenu<Transposition>(
            enableFilter: false,
            enableSearch: false,
            initialSelection: currentTransposition,
            requestFocusOnTap: false,
            onSelected: (Transposition? newKey) {
              if (newKey != null) {
                ref.read(transpositionProvider.notifier).setTransposition(newKey, player);
                player.saveInstrumentAndTransposition(newKey);
              }
            },
            dropdownMenuEntries: player.selectedInstrument.availableTranspositions
                .map<DropdownMenuEntry<Transposition>>(
                  (Transposition key) {
                    return DropdownMenuEntry<Transposition>(
                      value: key,
                      label: key.getLocalizedName(ref),
                    );
                  },
                ).toList(),
          );
        } else {
          return const Center(child: Text('No transpositions available'));
        }
      },
    );
  }
}
