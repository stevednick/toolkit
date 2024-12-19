import 'package:flutter/material.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/models/transposition.dart';

class TranspositionDropDown extends StatefulWidget {
  final Player player;

  const TranspositionDropDown({super.key, required this.player});

  @override
  State<TranspositionDropDown> createState() => TranspositionDropDownState();
}

class TranspositionDropDownState extends State<TranspositionDropDown> {
  late Future<Transposition> _futureCurrentTransposition;

  @override
  void initState() {
    super.initState();
    _loadCurrentTransposition();
  }

  void _loadCurrentTransposition(){
    _futureCurrentTransposition =
        widget.player.selectedInstrument.loadCurrentTransposition();
  }

   void refresh() {
    print("Drop Down Refreshed!");
    setState(() {
      _loadCurrentTransposition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Transposition>(
      future: _futureCurrentTransposition,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return DropdownMenu<Transposition>(
            enableFilter: false,
            enableSearch: false,
            initialSelection: snapshot.data,
            requestFocusOnTap: false,
            onSelected: (Transposition? newKey) {
              setState(() {
                widget.player.saveInstrumentAndTransposition(newKey!);
              });
            },
            dropdownMenuEntries: widget
                .player.selectedInstrument.availableTranspositions
                .map<DropdownMenuEntry<Transposition>>(
                    (Transposition key) {
              return DropdownMenuEntry<Transposition>(
                value: key,
                label: "Horn in ${key.name}",
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
