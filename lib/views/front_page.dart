// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:toolkit/components/static_stave.dart';
// import 'package:toolkit/models/accidental.dart';
// import 'package:toolkit/models/clef.dart';
// import 'package:toolkit/models/note_data.dart';
// import 'package:toolkit/views/farkas_jr.dart';

// class FrontPage extends StatelessWidget {
//   const FrontPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("The Hornplayer's Toolkit"),
//             SizedBox(
//               height: 400,
//               width: 250,
//               child: GameWidget(
//                 game: StaticStave(
//                   noteData: NoteData(
//                       name: "C",
//                       pos: -8,
//                       accidental: Accidental.sharp,
//                       clef: Clef.treble(),
//                       noteNum: 3),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const FarkasJr()),
//                 );
//               },
//               child: const Text("Start"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
