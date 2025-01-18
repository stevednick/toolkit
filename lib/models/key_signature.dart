import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toolkit/localization/localization_provider.dart';
import 'package:toolkit/models/accidental.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/tools/config.dart';

class KeySignature {
  
  final String name;
  final int sharps;
  final int flats;

  final double spacing = 27;

  final List<int> sharpOrder = [3, 0, 4, 1, 5, 2, 6];
  final List<int> flatOrder = [
    6,
    2,
    5,
    1,
    4,
    0,
    3
  ]; // Interestingly, just reversed.

  final List<NoteData> referenceOctave = NoteData.octave;

  final List<int> sharpModifiers = [6, 1, 8, 3, 10, 5, 0];
  final List<int> flatModifiers = [10, 3, 8, 1, 6, 11, 4];

  KeySignature({required this.name, required this.sharps, required this.flats});

  String getLocalizedName(BuildContext context) {  // todo add major to name
    final localization = Provider.of<LocalizationProvider>(context, listen: false);
    return "${localization.translate(name)} ${localization.translate('Major')}";
  }

  NoteData noteModifier(NoteData note,
      {bool rangeSelection = false, bool ghostNote = false}) {
    for (int i = 0; i < sharps; i++) {
      if (NoteData.wrapAround(note.noteNum, 12) == sharpModifiers[i]) {

        if (note.accidental != Accidental.sharp) {

          bool adjustNote = false;
          if (rangeSelection){
            List<NoteData> noteToCheck = searchNoteData(Accidental.sharp, NoteData.wrapAround(note.pos, 7)-1);
            if (noteToCheck.isNotEmpty) adjustNote = noteToCheck.first.isActive;
          }

          if (ghostNote || adjustNote) {
            note.accidental = Accidental.sharp;
            note.pos -= 1;
          }
        }
      }
      if (NoteData.wrapAround(note.pos, 7) == sharpOrder[i]) {
        if (note.accidental == Accidental.sharp) {
          note.accidental = Accidental.none;
        } else if (note.accidental == Accidental.none) {
          note.accidental = Accidental.natural;
        }
      }
    }
  for (int i = 0; i < flats; i++) {
      if (NoteData.wrapAround(note.noteNum, 12) == flatModifiers[i]) {

        if (note.accidental != Accidental.flat) {

          bool adjustNote = false;
          if (rangeSelection){
            List<NoteData> noteToCheck = searchNoteData(Accidental.flat, NoteData.wrapAround(note.pos, 7)+1);
            if (noteToCheck.isNotEmpty) adjustNote = noteToCheck.first.isActive;
          }

          if (ghostNote || adjustNote) {
            note.accidental = Accidental.flat;
            note.pos += 1;
          }
        }
      }
      if (NoteData.wrapAround(note.pos, 7) == flatOrder[i]) {
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
  return referenceOctave.where((note) => 
    note.accidental == targetAccidental && note.pos == targetPos
  ).toList();
}


  double clefOffset() {
    return spacing * (sharps + flats) + 20;
  }

  PositionComponent displayKeySignature(Clef clef) {
    final double spacing = 27;
    final List<int> sharpPositions = [10, 7, 11, 8, 5, 9, 6];
    final List<int> flatPositions = [6, 9, 5, 8, 4, 7, 3];
    PositionComponent holder = PositionComponent();
    for (int i = 0; i < sharps; i++) {
      Asset sharp = Asset.createSharp();
      PositionComponent sharpHolder = PositionComponent()
        ..position = Vector2(
            spacing * i,
            -lineGap *
                (sharpPositions[i] +
                    clef.offset -
                    (clef.name == "Bass" ? 14 : 0)) /
                2);
      sharpHolder.add(sharp);
      holder.add(sharpHolder);
    }
    for (int i = 0; i < flats; i++) {
      Asset flat = Asset.createFlat();
      PositionComponent flatHolder = PositionComponent()
        ..position = Vector2(
            spacing * i,
            -lineGap *
                (flatPositions[i] +
                    clef.offset -
                    (clef.name == "Bass" ? 14 : 0)) /
                2);
      flatHolder.add(flat);
      holder.add(flatHolder);
    }
    return holder;
  }

  static List<KeySignature> keySignatures = [
    KeySignature(name: "C", sharps: 0, flats: 0),
    KeySignature(name: "G", sharps: 1, flats: 0),
    KeySignature(name: "F", sharps: 0, flats: 1),
    KeySignature(name: "D", sharps: 2, flats: 0),
    KeySignature(name: "Bb", sharps: 0, flats: 2),
    KeySignature(name: "A", sharps: 3, flats: 0),
    KeySignature(name: "Eb", sharps: 0, flats: 3),
    KeySignature(name: "E", sharps: 4, flats: 0),
    KeySignature(name: "Ab", sharps: 0, flats: 4),
    KeySignature(name: "B", sharps: 5, flats: 0),
    KeySignature(name: "Db", sharps: 0, flats: 5),
    KeySignature(name: "F#", sharps: 6, flats: 0),
    KeySignature(name: "Gb", sharps: 0, flats: 6),
    KeySignature(name: "C#", sharps: 7, flats: 0),
    KeySignature(name: "Cb", sharps: 0, flats: 7),
  ];
}
