import 'package:toolkit/models/asset.dart';

class Clef {
  final String name;
  final int offset;
  final Asset sprite;

  Clef({required this.name, required this.offset, required this.sprite});

  static Clef treble() => Clef(name: "Treble", offset: -6, sprite: Asset.createTrebleClef());
  static Clef bass() => Clef(name: "Bass", offset: 6, sprite: Asset.createBassClef());
  static Clef neutral() => Clef(name: "neutral", offset: 0, sprite: Asset.createSharp()); // Make empty asset for this?
}