import 'package:flutter/material.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signature_selector_data.dart';
import 'package:toolkit/models/key_signature/key_signatures.dart';
import 'package:toolkit/models/player.dart';

class KeySignatureDropdown extends StatefulWidget {
  final Player player;
  final Function() onChanged;

  const KeySignatureDropdown({super.key, required this.player, required this.onChanged});

  @override
  State<KeySignatureDropdown> createState() => KeySignatureDropdownState();
}

class KeySignatureDropdownState extends State<KeySignatureDropdown> {
  late Future<int> _futureCurrentKeySignature;

  final KeySignatureSelectorData keySignatureSelectorData = KeySignatureSelectorData();

  @override
  void initState() {
    super.initState();
    _loadCurrentKey();
  }

  void _loadCurrentKey(){
    _futureCurrentKeySignature =
        widget.player.loadKeySignatureInt();
  }

   void refresh() {
    print("Drop Down Refreshed!");
    setState(() {
      _loadCurrentKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _futureCurrentKeySignature,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return DropdownMenu<KeySignature>(
            enableFilter: false,
            enableSearch: false,
            initialSelection: KeySignatures.list[snapshot.data!],
            requestFocusOnTap: false,
            onSelected: (KeySignature? newKey) {
              if (newKey != null) {
                setState(() {
                  widget.player.saveKeySignature(KeySignatures.list.indexOf(newKey));
                  widget.onChanged();
                });
              }
            },
            dropdownMenuEntries: KeySignatures.list
                .map<DropdownMenuEntry<KeySignature>>((KeySignature key) {
              return DropdownMenuEntry<KeySignature>(
                value: key,
                label: keySignatureSelectorData.getLocalizedName(context, key.name)
              );
            }).toList(),
          );
        } else {
          return const Text('No transpositions available');
        }
      },
    );
  }
}
