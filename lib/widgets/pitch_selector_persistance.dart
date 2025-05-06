import 'package:flutter/material.dart';
import 'package:toolkit/tools/note_getter.dart';
import 'package:toolkit/widgets/nice_button.dart';

class PitchSelector extends StatefulWidget {
  const PitchSelector({super.key});

  @override
  _PitchSelectorState createState() => _PitchSelectorState();
}

class _PitchSelectorState extends State<PitchSelector> {
  List<int> pitches = [435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446];
  int _selectedPitch = 440; // Default tempo
  late NiceButton button;

  NoteGetter noteGetter = NoteGetter();

  @override
  void initState() {
    // widget.isActive.addListener((){
    //   button.isActive.value = widget.isActive.value;
    // });
    button = NiceButton(
      text: 'A = $_selectedPitch Hz',
      onPressed: () {
        _showPitchMenu(context);
      },
    );
    super.initState();
    _loadSavedTempo();
  }

  Future<void> _loadSavedTempo() async {
    _selectedPitch = await noteGetter.getAPitch();
    setState(() {
      // Update the button text when the pitch is loaded
      button = NiceButton(
        text: 'A = $_selectedPitch Hz',
        onPressed: () {
          _showPitchMenu(context);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return button;
  }

  void _showPitchMenu(BuildContext context) {
    RenderBox renderButton = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        renderButton.localToGlobal(Offset.zero, ancestor: overlay),
        renderButton.localToGlobal(renderButton.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<int>(
      context: context,
      position: position,
      items: pitches.map((int pitch) {
        return PopupMenuItem<int>(
          value: pitch,
          child: Text('$pitch Hz'),
        );
      }).toList(),
    ).then((int? selectedPitch) {
      if (selectedPitch != null) {
        setState(() {
          _selectedPitch = selectedPitch;
          // Update the button text when a new pitch is selected
          button = NiceButton(
            text: 'A = $_selectedPitch Hz',
            onPressed: () {
              _showPitchMenu(context);
            },
          );
        });
        noteGetter.setAPitch(selectedPitch);
      }
    });
  }
}
