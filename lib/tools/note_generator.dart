import 'dart:math';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/clef_selection.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';

class NoteGenerator {  // todo Next sort out the list for random selection.. 
//todo then ensure that note selection stops once there are fewer than two options. 
// todo maybe use the list to do that check? Needs to be modified every time anyway... 
  Random random = Random();
  List<NoteData> availableNotes = []; // todo fill this. 

  NoteGenerator();

  void buildNoteList(Player player){
    availableNotes = [];
    for (int i = player.range.bottom; i <= player.range.top; i++){
      availableNotes.addAll(NoteData.findNotesByNumber(i));
    }
  }

  bool checkValidChange(Player player, bool isTop, bool isUp){
    List<NoteData> availables = [];
    int top = player.range.top;
    top += isTop ? isUp ? 1 : -1 : 0;
    int bottom = player.range.bottom;
    bottom += !isTop ? isUp ? 1 : -1 : 0;
    for (int i = bottom; i <= top; i++){
      availables.addAll(NoteData.findNotesByNumber(i));
    }
    return availables.length >= 2;
  }

  NoteData noteFromNumberOld(int num, bool clean, ClefSelection clefSelection) {
    // Tidy this up when settled on how this class works.

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
    noteToReturn = NoteData.octave[
            getNoteInOctave(num)] // Todo replace this with value that works!!!!
        .copyWith(clef: clef);
    noteToReturn.noteNum = num;
    noteToReturn.pos += getOctaveNumber(num) * 7;
    //print("num: ${noteToReturn.noteNum}, pos: ${noteToReturn.pos}");
    return noteToReturn;
  }

  NoteData noteFromNumber(int num, bool clean, Clef clef) {
    NoteData? noteToReturn;
    noteToReturn = NoteData.octave[
            getNoteInOctave(num)] // Todo replace this with value that works!
        .copyWith(clef: clef);
    noteToReturn.noteNum = num;
    noteToReturn.pos += getOctaveNumber(num) * 7;
    //print("num: ${noteToReturn.noteNum}, pos: ${noteToReturn.pos}");
    return noteToReturn;
  }

  int getNoteInOctave(int num) {
    return wrapAround(num, 12);
  }

  NoteData getNextAvailableNote(int num, bool isUp, Player player) {
    int increment = isUp ? 1 : -1;
    for (int i = num; true; i += increment) {
      
      if (NoteData.findNotesByNumber(i).isNotEmpty) {
        NoteData noteToReturn = NoteData.findNotesByNumber(i).first;
        noteToReturn.clef = _getDisplayClef(i, player);
        return noteToReturn;
      }
    }
  }

  NoteData randomNoteFromRange(Player player) {
    buildNoteList(player);
    NoteData noteToReturn = availableNotes[random.nextInt(availableNotes.length)];
    noteToReturn.clef = _getClef(noteToReturn.noteNum, player);
    return noteToReturn;
  }

  Clef _getClef(int note, Player player) {
    if (player.clefSelection == ClefSelection.treble) {
      return Clef.treble();
    } else if (player.clefSelection == ClefSelection.bass) {
      return Clef.bass();
    }
    if (note > player.clefThreshold.bassClefThreshold) {
      return Clef.treble();
    } else if (note >= player.clefThreshold.trebleClefThreshold) {
      int rand = random.nextInt(2);
      return rand == 0 ? Clef.treble() : Clef.bass();
    }
    return Clef.bass();
  }

  Clef _getDisplayClef(int note, Player player){
    if (player.clefSelection == ClefSelection.treble) {
      return Clef.treble();
    } else if (player.clefSelection == ClefSelection.bass) {
      return Clef.bass();
    }
    return note >= 0 ? Clef.treble() : Clef.bass();
  }

  int getOctaveNumber(int num) {
    return (num / 12).floor();
  }

  int wrapAround(int value, int modulo) {
    return (value % modulo + modulo) % modulo;
  }
}
