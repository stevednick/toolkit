import 'package:flutter/material.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';

class NoteSelectorView extends StatefulWidget {
  const NoteSelectorView({super.key});

  @override
  _NoteSelectorViewState createState() => _NoteSelectorViewState();
}

class _NoteSelectorViewState extends State<NoteSelectorView> {
  final List<String> notes = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  final List<String> accidentals = ['♮', '♯', '♭', '𝄪', '𝄫'];
  final List<NoteData> octave = NoteData.octave;
  //final List<List<bool>> selectedNotes = List.generate(7, (_) => List.generate(5, (_) => false));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        title: const Text('Note Selector'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: notes.length * accidentals.length,
        itemBuilder: (context, index) {
          final noteIndex = index % 7;
          final accidentalIndex = index ~/ 7;
          return NoteToggleButton(
            note: notes[noteIndex],
            accidental: accidentals[accidentalIndex],
            isSelected: octave[index].isActive,
            onPressed: () {
              setState(() {
                octave[index].isActive = !octave[index].isActive;
                octave[index].saveIsActive();
                //selectedNotes[noteIndex][accidentalIndex] = !selectedNotes[noteIndex][accidentalIndex];
              });
            },
          );
        },
      ),
    );
  }
}

class NoteToggleButton extends StatelessWidget {
  final String note;
  final String accidental;
  final bool isSelected;
  final VoidCallback onPressed;

  const NoteToggleButton({
    super.key,
    required this.note,
    required this.accidental,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (accidental) {
      case '𝄫':
        backgroundColor = isSelected ? Colors.purple[200]! : Colors.purple[50]!;
        textColor = Colors.purple[700]!;
        break;
      case '♭':
        backgroundColor = isSelected ? Colors.blue[200]! : Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        break;
      case '♮':
        backgroundColor = isSelected ? Colors.green[200]! : Colors.green[50]!;
        textColor = Colors.green[700]!;
        break;
      case '♯':
        backgroundColor = isSelected ? Colors.orange[200]! : Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        break;
      case '𝄪':
        backgroundColor = isSelected ? Colors.red[200]! : Colors.red[50]!;
        textColor = Colors.red[700]!;
        break;
      default:
        backgroundColor = isSelected ? Colors.grey[300]! : Colors.grey[100]!;
        textColor = Colors.grey[700]!;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor, backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '$note$accidental',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
