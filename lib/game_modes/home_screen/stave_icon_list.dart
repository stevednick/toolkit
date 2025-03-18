import 'package:flutter/material.dart';
import 'package:toolkit/components/stave/stave_icon.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player/player.dart';

class StaveIconList extends StatelessWidget {
  late Player player;
  
  StaveIconList({
    super.key, 
  }){
    player = Player(playerKey: "staveTest");
  } 

  @override
  Widget build(BuildContext context) {
    final renderer = StaveImageRenderer(
      player: player,
      width: 120,
      height: 80,
    );

    // Use it as an icon in your UI
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: renderer.buildStaveImage(
          noteData: NoteData.placeholderValue, // Or any specific note
        ),
      ),
    );
  }
}