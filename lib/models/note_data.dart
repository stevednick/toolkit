import 'package:toolkit/models/accidental.dart';
import 'package:toolkit/models/clef.dart';

class NoteData{
  int pos;
  final Accidental accidental;
  Clef clef; 
  int noteNum;
  late String name = "";

  NoteData({required this.name, required this.pos, required this.accidental, required this.clef, required this.noteNum});

  int get posOnStave => pos + clef.offset;

  NoteData copyWith({Clef? clef}) {
    return NoteData(
      name: name,
      pos: pos,
      accidental: accidental,
      clef: clef ?? this.clef,
      noteNum: noteNum,
    );
  }

 static List<NoteData> octave = [
    NoteData(name: "C", pos: 0, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 0),
    NoteData(name: "C#", pos: 0, accidental: Accidental.sharp, clef: Clef.neutral(), noteNum: 1),
    NoteData(name: "D", pos: 1, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 2),
    NoteData(name: "D#", pos: 1, accidental: Accidental.sharp, clef: Clef.neutral(), noteNum: 3),
    NoteData(name: "E", pos: 2, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 4),
    NoteData(name: "F", pos: 3, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 5),
    NoteData(name: "F#", pos: 3, accidental: Accidental.sharp, clef: Clef.neutral(), noteNum: 6),
    NoteData(name: "G", pos: 4, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 7),
    NoteData(name: "G#", pos: 4, accidental: Accidental.sharp, clef: Clef.neutral(), noteNum: 8),
    NoteData(name: "A", pos: 5, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 9),
    NoteData(name: "A#", pos: 5, accidental: Accidental.sharp, clef: Clef.neutral(), noteNum: 10),
    NoteData(name: "B", pos: 6, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 11),
    // Enharmonics
    NoteData(name: "Db", pos: 1, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 1),
    NoteData(name: "Eb", pos: 2, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 3),
    //NoteData(name: "E#", pos: 2, accidental: Accidental.sharp, clef: Clef.neutral(), noteNum: 5),
    //NoteData(name: "Fb", pos: 2, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 4),        
    NoteData(name: "Gb", pos: 4, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 6),
    NoteData(name: "Ab", pos: 5, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 8),
    NoteData(name: "Bb", pos: 6, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 10),
    //NoteData(name: "Cb", pos: 7, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 11),
  ];

  static List<NoteData> firstChoiceOctave = [
    NoteData(name: "C", pos: 0, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 0),
    NoteData(name: "C#", pos: 0, accidental: Accidental.sharp, clef: Clef.neutral(), noteNum: 1),
    NoteData(name: "D", pos: 1, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 2),
    NoteData(name: "Eb", pos: 2, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 3),
    NoteData(name: "E", pos: 2, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 4),
    NoteData(name: "F", pos: 3, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 5),
    NoteData(name: "F#", pos: 3, accidental: Accidental.sharp, clef: Clef.neutral(), noteNum: 6),
    NoteData(name: "G", pos: 4, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 7),
    NoteData(name: "Ab", pos: 5, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 8),
    NoteData(name: "A", pos: 5, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 9),
    NoteData(name: "Bb", pos: 6, accidental: Accidental.flat, clef: Clef.neutral(), noteNum: 10),
    NoteData(name: "B", pos: 6, accidental: Accidental.none, clef: Clef.neutral(), noteNum: 11),
  ];
}