import 'dart:math';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/clef_selection.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';

class NoteGenerator {
  Random random = Random();

  NoteGenerator();

  NoteData noteFromNumberOld(int num, bool clean, ClefSelection clefSelection) { // Tidy this up when settled on how this class works. 

    NoteData? noteToReturn;
    Clef clef; 
    switch (clefSelection) {
      case ClefSelection.treble:
        clef = Clef.treble();
        break;
      case ClefSelection.trebleBass:
        clef = num >= 0 ? Clef.treble() : Clef.bass();
      default:
        clef = Clef.bass();
    }
    noteToReturn = NoteData.firstChoiceOctave[getNoteInOctave(num)]
      .copyWith(clef: clef);
    noteToReturn.noteNum = num;
    noteToReturn.pos += getOctaveNumber(num) * 7;
    //print("num: ${noteToReturn.noteNum}, pos: ${noteToReturn.pos}");
    return noteToReturn;
  }

    NoteData noteFromNumber(int num, bool clean, Clef clef) {

    NoteData? noteToReturn;
    noteToReturn = NoteData.firstChoiceOctave[getNoteInOctave(num)]
      .copyWith(clef: clef);
    noteToReturn.noteNum = num;
    noteToReturn.pos += getOctaveNumber(num) * 7;
    //print("num: ${noteToReturn.noteNum}, pos: ${noteToReturn.pos}");
    return noteToReturn;
  }

  int getNoteInOctave(int num) {
    return wrapAround(num, 12);
  }


  NoteData randomNoteFromRange(Player player){
    int nextNote = player.range.bottom + random.nextInt(player.range.top + 1 - player.range.bottom);
    print(nextNote);
    NoteData note = noteFromNumber(nextNote, true, _getClef(nextNote, player));
    return note;
  }

  Clef _getClef(int note, Player player){
    if (player.clefSelection == ClefSelection.treble){
      return Clef.treble();
    } else if (player.clefSelection == ClefSelection.bass){
      return Clef.bass();
    }
    if(note > player.clefThreshold.bassClefThreshold) {
      return Clef.treble();
    } else if (note >= player.clefThreshold.trebleClefThreshold){
      int rand = random.nextInt(2);
      return rand == 0 ? Clef.treble() : Clef.bass();
    }
    return Clef.bass();
  }

  int getOctaveNumber(int num) {
    return (num / 12).floor();
  }

  int wrapAround(int value, int modulo) {
    return (value % modulo + modulo) % modulo;
  }
}
