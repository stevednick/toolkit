import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signatures.dart';
import 'package:toolkit/models/key_signature/key_signature_selector_data.dart';
import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/providers/key_signature_provider.dart';

class KeySignatureDropdown extends ConsumerWidget {
  final Player player;
  final Function() onChanged;

  const KeySignatureDropdown({super.key, required this.player, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keySignature = ref.watch(keySignatureProvider(player));
    final keySelectorData = KeySignatureSelectorData();

    return DropdownMenu<KeySignature>(
      enableFilter: false,
      enableSearch: false,
      initialSelection: keySignature,
      requestFocusOnTap: false,
      onSelected: (KeySignature? newKey) {
        if (newKey != null) {
          ref.read(keySignatureProvider(player).notifier).changeKey(newKey);
          onChanged();
        }
      },
      dropdownMenuEntries: KeySignatures.list
          .map((key) => DropdownMenuEntry<KeySignature>(
                value: key,
                label: keySelectorData.getLocalizedName(ref, key.name),
              ))
          .toList(),
    );
  }
}
