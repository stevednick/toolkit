// import 'package:flutter/material.dart';

// class TempoSelector extends StatefulWidget {
//   final Function(int) onTempoChanged;

//   const TempoSelector({Key? key, required this.onTempoChanged}) : super(key: key);

//   @override
//   _TempoSelectorState createState() => _TempoSelectorState();
// }

// class _TempoSelectorState extends State<TempoSelector> {
//   int _selectedTempo = 120; // Default tempo
//   final List<int> _tempos = [
//     40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 63, 66, 69, 72, 76, 80, 84, 88, 92, 96, 
//     100, 104, 108, 112, 116, 120, 126, 132, 138, 144, 152, 160, 168, 176, 184, 192, 200
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         _showTempoMenu(context);
//       },
//       child: Text('Tempo: $_selectedTempo BPM'),
//     );
//   }

//   void _showTempoMenu(BuildContext context) {
//     final RenderBox button = context.findRenderObject() as RenderBox;
//     final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
//     final RelativeRect position = RelativeRect.fromRect(
//       Rect.fromPoints(
//         button.localToGlobal(Offset.zero, ancestor: overlay),
//         button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
//       ),
//       Offset.zero & overlay.size,
//     );

//     showMenu<int>(
//       context: context,
//       position: position,
//       items: _tempos.map((int tempo) {
//         return PopupMenuItem<int>(
//           value: tempo,
//           child: Text('$tempo BPM'),
//         );
//       }).toList(),
//     ).then((int? selectedTempo) {
//       if (selectedTempo != null) {
//         setState(() {
//           _selectedTempo = selectedTempo;
//         });
//         widget.onTempoChanged(selectedTempo);
//       }
//     });
//   }
// }