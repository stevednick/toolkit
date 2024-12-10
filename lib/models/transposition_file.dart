import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/note_data.dart';

class TranspositionFile {
  List<NoteData> notes = [];
  late List<NoteData>? extras = [];
  late String name;
  //late String piece;
  late List<int> noteNums;

  TranspositionFile(this.noteNums, this.name, {this.extras}) {
    buildNoteList();
  }

  void buildNoteList() {
    for (final noteNum in noteNums) {
      notes.add(NoteData.findFirstChoiceByNumber(noteNum, Clef.neutral()));
      if(extras != null){
        notes.addAll(extras!);
      }
    }
  }

  static TranspositionFile majorArpeggio = TranspositionFile(
    [-24, -20, -17, -12, -8, -5, 0, 4, 7, 12, 16, 19, 24, 28, 31],
    "Major Arpeggio",
  );
}
