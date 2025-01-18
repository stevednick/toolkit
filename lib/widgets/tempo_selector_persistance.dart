import 'package:flutter/material.dart';
import 'package:toolkit/models/tempo.dart';
import 'package:toolkit/widgets/nice_button.dart';

class TempoSelector extends StatefulWidget {
  final Function(int) onTempoChanged;
  final String keyString;
  ValueNotifier<bool> isActive = ValueNotifier(true);

  TempoSelector({super.key, required this.onTempoChanged, required this.keyString});

  @override
  _TempoSelectorState createState() => _TempoSelectorState();
}

class _TempoSelectorState extends State<TempoSelector> {
  int _selectedTempo = 60; // Default tempo
  late Tempo tempo = Tempo(key: widget.keyString);
  late NiceButton button;

  @override
  void initState() {
    widget.isActive.addListener((){
      button.isActive.value = widget.isActive.value;
    });
    setButton(_selectedTempo);
    _loadSavedTempo();
    super.initState();
  }

  Future<void> _loadSavedTempo() async {
    _selectedTempo = await tempo.loadSavedTempo();

    setButton(_selectedTempo);

    widget.onTempoChanged(_selectedTempo);
  }

  void setButton(int selectedTempo){
    setState(() {
      button = NiceButton(
        text: 'Tempo: $selectedTempo BPM',
        onPressed: () {
          _showTempoMenu(context);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return button;
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
        _selectedTempo = selectedTempo;
        setButton(selectedTempo);

        tempo.saveTempo(selectedTempo);
        widget.onTempoChanged(selectedTempo);
      }
    });
  }
}