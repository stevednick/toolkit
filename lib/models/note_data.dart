import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/shared_prefs_manager.dart';

class NoteData {
  int pos;
  late Accidental accidental;
  Clef clef;
  int noteNum;
  late String name = "";
  late int priority;
  late bool isActive = true;
  late bool isActiveAtFirstStart;
  late String key = "";

  NoteData(
      {required this.name,
      required this.pos,
      required this.accidental,
      required this.clef,
      required this.noteNum,
      required this.priority,
      required this.isActiveAtFirstStart}) {
    loadIsActive();
  }
    static Future<void> init() async {
    for (final note in octave) {
      await note.loadIsActive();
    }
  }

  int get posOnStave => pos + clef.offset;

  Future<void> saveIsActive() async {
    await SharedPrefsManager.save<bool>('isActive_$name', isActive);
  }

  Future<void> loadIsActive() async {
    isActive = await SharedPrefsManager.load<bool>('isActive_$name') ??
        isActiveAtFirstStart;
  }

  NoteData copyWith({Clef? clef}) {
    return NoteData(
        name: name,
        pos: pos,
        accidental: accidental,
        clef: clef ?? this.clef,
        noteNum: noteNum,
        priority: priority,
        isActiveAtFirstStart: isActiveAtFirstStart);
  }

  static NoteData findFirstChoiceByNumber(int number, Clef clef) {
    List<NoteData> matchingNotes =
        octave.where((note) => note.noteNum == wrapAround(number, 12)).toList();
    matchingNotes.sort((a, b) => a.priority.compareTo(b.priority));
    NoteData noteToReturn = matchingNotes.first.copyWith(clef: clef);
    noteToReturn.noteNum = number;
    noteToReturn.pos += getOctaveNumber(number) * 7;
    return noteToReturn;
  }

  static List<NoteData> findNotesByNumber(int number) {
    List<NoteData> matchingNotes = octave
        .where(
            (note) => note.noteNum == wrapAround(number, 12) && note.isActive)
        .toList();
    matchingNotes.sort((a, b) => a.priority.compareTo(b.priority));
    List<NoteData> notesToReturn = [];
    for (NoteData note in matchingNotes) {
      NoteData noteToReturn = note.copyWith(clef: Clef.neutral());
      noteToReturn.noteNum = number;
      noteToReturn.pos += getOctaveNumber(number) * 7;
      notesToReturn.add(noteToReturn);
    }
    return notesToReturn;
  }

  static int getOctaveNumber(int num) {
    return (num / 12).floor();
  }

  static int wrapAround(int value, int modulo) {
    return (value % modulo + modulo) % modulo;
  }

  static bool checkValidSwitch() {
    for (NoteData noteToCheck in octave) {
      if (noteToCheck.isActive) return true;
    }
    return false;
  }

  static List<NoteData> octave = [
    NoteData(
        name: "C",
        pos: 0,
        accidental: Accidental.none,
        clef: Clef.neutral(),
        noteNum: 0,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "D",
        pos: 1,
        accidental: Accidental.none,
        clef: Clef.neutral(),
        noteNum: 2,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "E",
        pos: 2,
        accidental: Accidental.none,
        clef: Clef.neutral(),
        noteNum: 4,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "F",
        pos: 3,
        accidental: Accidental.none,
        clef: Clef.neutral(),
        noteNum: 5,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "G",
        pos: 4,
        accidental: Accidental.none,
        clef: Clef.neutral(),
        noteNum: 7,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "A",
        pos: 5,
        accidental: Accidental.none,
        clef: Clef.neutral(),
        noteNum: 9,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "B",
        pos: 6,
        accidental: Accidental.none,
        clef: Clef.neutral(),
        noteNum: 11,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "C#",
        pos: 0,
        accidental: Accidental.sharp,
        clef: Clef.neutral(),
        noteNum: 1,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "D#",
        pos: 1,
        accidental: Accidental.sharp,
        clef: Clef.neutral(),
        noteNum: 3,
        priority: 1,
        isActiveAtFirstStart: true),
    NoteData(
        name: "E#",
        pos: 2,
        accidental: Accidental.sharp,
        clef: Clef.neutral(),
        noteNum: 5,
        priority: 1,
        isActiveAtFirstStart: false),
    NoteData(
        name: "F#",
        pos: 3,
        accidental: Accidental.sharp,
        clef: Clef.neutral(),
        noteNum: 6,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "G#",
        pos: 4,
        accidental: Accidental.sharp,
        clef: Clef.neutral(),
        noteNum: 8,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "A#",
        pos: 5,
        accidental: Accidental.sharp,
        clef: Clef.neutral(),
        noteNum: 10,
        priority: 1,
        isActiveAtFirstStart: true),
    NoteData(
        name: "B#",
        pos: -1,
        accidental: Accidental.sharp,
        clef: Clef.neutral(),
        noteNum: 0,
        priority: 1,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Cb",
        pos: 7,
        accidental: Accidental.flat,
        clef: Clef.neutral(),
        noteNum: 11,
        priority: 1,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Db",
        pos: 1,
        accidental: Accidental.flat,
        clef: Clef.neutral(),
        noteNum: 1,
        priority: 1,
        isActiveAtFirstStart: true),
    NoteData(
        name: "Eb",
        pos: 2,
        accidental: Accidental.flat,
        clef: Clef.neutral(),
        noteNum: 3,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "Fb",
        pos: 3,
        accidental: Accidental.flat,
        clef: Clef.neutral(),
        noteNum: 4,
        priority: 1,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Gb",
        pos: 4,
        accidental: Accidental.flat,
        clef: Clef.neutral(),
        noteNum: 6,
        priority: 1,
        isActiveAtFirstStart: true),
    NoteData(
        name: "Ab",
        pos: 5,
        accidental: Accidental.flat,
        clef: Clef.neutral(),
        noteNum: 8,
        priority: 1,
        isActiveAtFirstStart: true),
    NoteData(
        name: "Bb",
        pos: 6,
        accidental: Accidental.flat,
        clef: Clef.neutral(),
        noteNum: 10,
        priority: 0,
        isActiveAtFirstStart: true),
    NoteData(
        name: "C##",
        pos: 0,
        accidental: Accidental.doubleSharp,
        clef: Clef.neutral(),
        noteNum: 2,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "D##",
        pos: 1,
        accidental: Accidental.doubleSharp,
        clef: Clef.neutral(),
        noteNum: 4,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "E##",
        pos: 2,
        accidental: Accidental.doubleSharp,
        clef: Clef.neutral(),
        noteNum: 6,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "F##",
        pos: 3,
        accidental: Accidental.doubleSharp,
        clef: Clef.neutral(),
        noteNum: 7,
        priority: 1,
        isActiveAtFirstStart: false),
    NoteData(
        name: "G##",
        pos: 4,
        accidental: Accidental.doubleSharp,
        clef: Clef.neutral(),
        noteNum: 9,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "A##",
        pos: 5,
        accidental: Accidental.doubleSharp,
        clef: Clef.neutral(),
        noteNum: 11,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "B##",
        pos: -1,
        accidental: Accidental.doubleSharp,
        clef: Clef.neutral(),
        noteNum: 1,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Cbb",
        pos: 7,
        accidental: Accidental.doubleFlat,
        clef: Clef.neutral(),
        noteNum: 10,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Dbb",
        pos: 1,
        accidental: Accidental.doubleFlat,
        clef: Clef.neutral(),
        noteNum: 0,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Ebb",
        pos: 2,
        accidental: Accidental.doubleFlat,
        clef: Clef.neutral(),
        noteNum: 2,
        priority: 1,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Fbb",
        pos: 3,
        accidental: Accidental.doubleFlat,
        clef: Clef.neutral(),
        noteNum: 3,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Gbb",
        pos: 4,
        accidental: Accidental.doubleFlat,
        clef: Clef.neutral(),
        noteNum: 5,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Abb",
        pos: 5,
        accidental: Accidental.doubleFlat,
        clef: Clef.neutral(),
        noteNum: 7,
        priority: 2,
        isActiveAtFirstStart: false),
    NoteData(
        name: "Bbb",
        pos: 6,
        accidental: Accidental.doubleFlat,
        clef: Clef.neutral(),
        noteNum: 9,
        priority: 1,
        isActiveAtFirstStart: false),
  ];

  static NoteData placeholderValue = NoteData(
      name: "Holder",
      pos: 0,
      accidental: Accidental.doubleSharp,
      clef: Clef.neutral(),
      noteNum: 0,
      priority: 0,
      isActiveAtFirstStart: true);
}
