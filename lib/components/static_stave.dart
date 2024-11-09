// import 'dart:async';

// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:toolkit/components/note.dart';
// import 'package:toolkit/config.dart';
// import 'package:toolkit/models/asset.dart';
// import 'package:toolkit/models/note_data.dart';
// import 'package:toolkit/tools/note_generator.dart';

// import 'package:toolkit/tools/pitch_listener.dart';
// import 'package:permission_handler/permission_handler.dart';

// class StaticStave extends FlameGame with KeyboardEvents{

//   late PitchListener pitchListener;
//   var noteDetected = -1;

//   final Vector2 viewSize = Vector2(300, 500);
//   final double staffWidth = 250;

//   late Note note;
//   late Asset clefSprite;
//   NoteGenerator noteGenerator = NoteGenerator();

//   late NoteData noteData;

//   StaticStave(
//       {super.children, super.world, super.camera, required this.noteData});
//   @override
//   FutureOr<void> onLoad() async{
//     super.onLoad();

//     pitchListener = PitchListener(onNoteDetected: (n) {
//       noteDetected = n;
//       if(noteDetected == noteData.noteNum){
//         newNote(noteGenerator.randomNoteFromRange(10, -10)); // Fix thois!
//       }
//     });
//     await Permission.microphone.request();
//     await pitchListener.initialize();
//     camera.viewfinder.visibleGameSize = viewSize;
//     camera.viewfinder.anchor = Anchor.center;
//     drawLines();
//     addNote();
//     addClef();
//     newNote(noteGenerator.randomNoteFromRange(14, -13));
//     await pitchListener.startCapture();
//   }

//   @override
//   void onDispose() async {

//     super.onDispose();
//     await pitchListener.startCapture();
//   }

//   @override
//   KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
//     final isSpace = keysPressed.contains(LogicalKeyboardKey.space);
//     if (isSpace){
//       newNote(noteGenerator.randomNoteFromRange(10, -10));
//     }
//     return super.onKeyEvent(event, keysPressed);
//   }
  
//   void newNote(NoteData newNote){
//     world.remove(clefSprite);
//     world.remove(note); 
//     noteData = newNote;
//     addNote();
//     addClef();
//   }

//   void drawLines() {
//     for (var i = -2; i < 3; i++) {
//       RectangleComponent newLine = RectangleComponent(
//         size: Vector2(staffWidth, lineWidth),
//         paint: Paint()..color = Colors.black,
//       )..position = Vector2(-staffWidth / 2, i * lineGap);
//       world.add(newLine);
//     }
//   }

//   void addNote(){
//     note = Note(
//       noteData,
//     )..position = Vector2(40, 0);
//     world.add(note);
//   }

//   void addClef() {
//     clefSprite = noteData.clef.sprite..positionSprite();
//     world.add(clefSprite);
//     clefSprite.position -= Vector2(70, 0);
//   }

//   @override
//   Color backgroundColor() => Colors.white;
// }
