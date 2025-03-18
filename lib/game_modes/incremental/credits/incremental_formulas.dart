import 'dart:math';

import 'package:toolkit/game_modes/incremental/unlockables/idle_note.dart';

class IncrementalFormulas {
  double cost(IdleNote note){
    return note.baseCost * pow(note.growthRate, note.owned);
  }
  double production(IdleNote note, {double multipliers = 1}){
    return note.baseEarnings * note.owned * multipliers;
  }
}