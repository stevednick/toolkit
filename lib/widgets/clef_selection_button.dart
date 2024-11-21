import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toolkit/models/clef_selection.dart';
import 'package:toolkit/models/player.dart';

class ClefSelectionButton extends StatefulWidget {
  final Player player;
  final void Function() refreshScene;

  const ClefSelectionButton(this.player, this.refreshScene, {super.key});

  @override
  State<ClefSelectionButton> createState() => _ClefSelectionButtonState();
}

class _ClefSelectionButtonState extends State<ClefSelectionButton> {
  int mode = 0;

  @override
  void initState() {
    super.initState();
    _setMode();
  }

  Future<void> _setMode() async {
    ClefSelection selection = await widget.player.getClefSelection();
    setState(() {
      mode = (ClefSelection.values.indexOf(selection));
    });
  }

  void _toggleSelection() {
    setState(() {
      mode = (mode + 1) % 3;
      widget.player.clefSelection = ClefSelection.values[mode];
      widget.player.saveInstrumentAndTransposition(
        widget.player.selectedInstrument.currentTransposition,
      );
      widget.refreshScene();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/treble.png',
            width: 30,
            height: 40,
            color: mode == 2 ? Colors.grey : Colors.blue,
          ),
          Image.asset(
            'assets/images/bass.png',
            width: 15,
            height: 25,
            color: mode == 1 ? Colors.grey : Colors.blue,
          ),
        ],
      ),
    );
  }
}
