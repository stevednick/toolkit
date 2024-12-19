import 'dart:math';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/models/transposition_file.dart';

class NoteGenerator {
  // todo Next sort out the list for random selection..
//todo then ensure that note selection stops once there are fewer than two options.
// todo maybe use the list to do that check? Needs to be modified every time anyway...
  Random random = Random();
  List<NoteData> availableNotes = []; // todo fill this.
  List<NoteData> fullRange = [];
  QuarterElementSelector selector = QuarterElementSelector();
  NoteGenerator();

  void buildNoteList(Player player) { // todo return code after testing;
    availableNotes = [];
    for (int i = player.range.bottom; i <= player.range.top; i++) {
      availableNotes.addAll(NoteData.findNotesByNumber(i));
    }
    //availableNotes = TranspositionFile.majorScale.notes;
  }

  void buildFullRange(){
    fullRange = [];
    for (int i = -100; i <= 100; i++) {
      fullRange.add(NoteData.findFirstChoiceByNumber(i, Clef.neutral()));
    }
    //fullRange = TranspositionFile.majorScale.notes;
  }



  bool checkValidChange(Player player, bool isTop, bool isUp) {
    List<NoteData> availables = [];
    int top = player.range.top;
    top += isTop
        ? isUp
            ? 1
            : -1
        : 0;
    int bottom = player.range.bottom;
    bottom += !isTop
        ? isUp
            ? 1
            : -1
        : 0;
    for (int i = bottom; i <= top; i++) {
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

  NoteData noteFromNumber(int num, Clef clef) {
    NoteData? noteToReturn;
    noteToReturn = NoteData.findFirstChoiceByNumber(num, clef);
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

  NoteData randomNoteFromRange(Player player, {bool bigJumps = false}) {
    buildNoteList(player);
    NoteData noteToReturn =
        availableNotes[random.nextInt(availableNotes.length)];
    if (bigJumps) {
      NoteData? note = selector.getAlternatingQuarterElement(availableNotes);
      if (note != null) noteToReturn = note;
    }
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

  Clef _getDisplayClef(int note, Player player) {
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

class QuarterElementSelector<T> {
  final Random _random = Random();
  bool _isHighTurn = true;

  T? getAlternatingQuarterElement(List<T> list) {
    // Check if the list has at least 4 elements
    if (list.length < 4) {
      // print('The list must have at least 4 elements.');
      return null;
    }

    // Calculate the size of a quarter
    final quarterSize = list.length ~/ 4;

    int randomIndex;
    if (_isHighTurn) {
      // Select a random element from the top quarter
      randomIndex = _random.nextInt(quarterSize);
    } else {
      // Select a random element from the bottom quarter
      randomIndex = list.length - quarterSize + _random.nextInt(quarterSize);
    }

    // Toggle the turn for the next call
    _isHighTurn = !_isHighTurn;

    return list[randomIndex];
  }
}
