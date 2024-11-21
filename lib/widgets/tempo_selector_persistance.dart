import 'package:flutter/material.dart';
import 'package:toolkit/models/tempo.dart';

class TempoSelector extends StatefulWidget {
  final Function(int) onTempoChanged;

  const TempoSelector({super.key, required this.onTempoChanged});

  @override
  _TempoSelectorState createState() => _TempoSelectorState();
}

class _TempoSelectorState extends State<TempoSelector> {
  int _selectedTempo = 60; // Default tempo
  final Tempo tempo = Tempo();

  @override
  void initState() {
    super.initState();
    _loadSavedTempo();
  }

  Future<void> _loadSavedTempo() async {
    _selectedTempo = await tempo.loadSavedTempo();
    setState((){
    });
    widget.onTempoChanged(_selectedTempo);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showTempoMenu(context);
      },
      child: Text('Tempo: $_selectedTempo BPM'),
    );
  }

  void _showTempoMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<int>(
      context: context,
      position: position,
      items: tempo.tempos.map((int tempo) {
        return PopupMenuItem<int>(
          value: tempo,
          child: Text('$tempo BPM'),
        );
      }).toList(),
    ).then((int? selectedTempo) {
      if (selectedTempo != null) {
        setState(() {
          _selectedTempo = selectedTempo;
        });
        tempo.saveTempo(selectedTempo);
        widget.onTempoChanged(selectedTempo);
      }
    });
  }
}