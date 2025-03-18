import 'package:toolkit/models/note_data.dart';

class IdleNote {
  final NoteData data;
  final double baseCost;
  final double baseEarnings;
  final double growthRate;
  int owned = 0;

  IdleNote(this.data, this.baseCost, this.baseEarnings, this.growthRate);
}