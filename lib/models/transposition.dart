import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toolkit/localization/localization_provider.dart';

class Transposition {
  final String name;
  final String octave;
  final int pitchModifier;

  Transposition(
      {required this.name, required this.pitchModifier, this.octave = ""});

  static Transposition cAlto =
      Transposition(name: "C", octave: "Alto", pitchModifier: 0);
  static Transposition bFlatAlto =
      Transposition(name: "Bb", octave: "Alto", pitchModifier: -2);
  static Transposition aAlto =
      Transposition(name: "A", octave: "Alto", pitchModifier: -3);
  static Transposition g = Transposition(name: "G", pitchModifier: -5);
  static Transposition fSharp = Transposition(name: "F#", pitchModifier: -6);
  static Transposition f = Transposition(name: "F", pitchModifier: -7);
  static Transposition e = Transposition(name: "E", pitchModifier: -8);
  static Transposition eFlat = Transposition(name: "Eb", pitchModifier: -9);
  static Transposition d = Transposition(name: "D", pitchModifier: -10);
  static Transposition dFlat = Transposition(name: "Db", pitchModifier: -11);
  static Transposition c = Transposition(name: "C", pitchModifier: -12);
  static Transposition bBasso =
      Transposition(name: "B", octave: "Basso", pitchModifier: -13);
  static Transposition bFlatBasso =
      Transposition(name: "Bb", octave: "Basso", pitchModifier: -14);
  static Transposition aBasso =
      Transposition(name: "A", octave: "Basso", pitchModifier: -15);
  static Transposition aFlatBasso =
      Transposition(name: "Ab", octave: "Basso", pitchModifier: -16);

  // List of all predefined transpositions
  static List<Transposition> transpositions = [
    cAlto,
    bFlatAlto,
    aAlto,
    g,
    fSharp,
    f,
    e,
    eFlat,
    d,
    dFlat,
    c,
    bBasso,
    bFlatBasso,
    aBasso,
    aFlatBasso,
  ];

  // Method to get a transposition by name
  static Transposition? getByName(String name) {
    return transpositions.firstWhere(
        (transposition) => transposition.name == name,
        orElse: () => Transposition.f);
  }

  String getLocalizedName(BuildContext context) {
    // todo add major to name
    final localization =
        Provider.of<LocalizationProvider>(context, listen: false);
    return "Horn in ${localization.translate(name)} $octave";
  }
}
