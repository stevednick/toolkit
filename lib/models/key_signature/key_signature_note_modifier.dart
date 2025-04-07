import 'package:toolkit/models/accidental.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signature_builder_data.dart';
import 'package:toolkit/models/note_data.dart';

class KeySignatureNoteModifier {
  final KeySignatureBuilderData data = KeySignatureBuilderData();

  final KeySignature key;

  final List<NoteData> referenceOctave = NoteData.octave;

  final List<int> sharpModifiers = [6, 1, 8, 3, 10, 5, 0];
  final List<int> flatModifiers = [10, 3, 8, 1, 6, 11, 4];

  KeySignatureNoteModifier(this.key);

  NoteData modifyNote(NoteData note,
      {bool rangeSelection = false, bool ghostNote = false}) {
        //print("Note: $note");
    for (int i = 0; i < key.sharps; i++) {
      if (NoteData.wrapAround(note.noteNum, 12) == sharpModifiers[i]) {
        if (note.accidental != Accidental.sharp) {
          bool adjustNote = false;
          if (rangeSelection) {
            List<NoteData> noteToCheck = searchNoteData(
                Accidental.sharp, NoteData.wrapAround(note.pos, 7) - 1);
            if (noteToCheck.isNotEmpty) adjustNote = noteToCheck.first.isActive;
          }

          if (ghostNote || adjustNote) {
            note.accidental = Accidental.sharp;
            note.pos -= 1;
          }
        }
      }
      if (NoteData.wrapAround(note.pos, 7) == data.sharpOrder[i]) {
        if (note.accidental == Accidental.sharp) {
          note.accidental = Accidental.none;
        } else if (note.accidental == Accidental.none) {
          note.accidental = Accidental.natural;
        }
      }
    }
    for (int i = 0; i < key.flats; i++) {
      if (NoteData.wrapAround(note.noteNum, 12) == flatModifiers[i]) {
        if (note.accidental != Accidental.flat) {
          bool adjustNote = false;
          if (rangeSelection) {
            List<NoteData> noteToCheck = searchNoteData(
                Accidental.flat, NoteData.wrapAround(note.pos, 7) + 1);
            if (noteToCheck.isNotEmpty) adjustNote = noteToCheck.first.isActive;
          }

          if (ghostNote || adjustNote) {
            note.accidental = Accidental.flat;
            note.pos += 1;
          }
        }
      }
      if (NoteData.wrapAround(note.pos, 7) == data.flatOrder[i]) {
        if (note.accidental == Accidental.flat) {
          note.accidental = Accidental.none;
        } else if (note.accidental == Accidental.none) {
          note.accidental = Accidental.natural;
        }
      }
    }
    return note;
  }

  List<NoteData> searchNoteData(Accidental targetAccidental, int targetPos) {
    return referenceOctave
        .where((note) =>
            note.accidental == targetAccidental && note.pos == targetPos)
        .toList();
  }
}
