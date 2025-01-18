import 'package:flutter/material.dart';
import 'package:toolkit/models/key_signature.dart';
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
            initialSelection: KeySignature.keySignatures[snapshot.data!],
            requestFocusOnTap: false,
            onSelected: (KeySignature? newKey) {
              if (newKey != null) {
                setState(() {
                  widget.player.saveKeySignature(KeySignature.keySignatures.indexOf(newKey));
                  widget.onChanged();
                });
              }
            },
            dropdownMenuEntries: KeySignature.keySignatures
                .map<DropdownMenuEntry<KeySignature>>((KeySignature key) {
              return DropdownMenuEntry<KeySignature>(
                value: key,
                label: key.getLocalizedName(context),
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
