import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/scenes/range_selection/range_selection_note_manager.dart';

class RangeSelectionDataManager {
  late Player player;
  bool isClefThresholds = false;
  late RangeSelectionNoteManager noteManager;

  RangeSelectionDataManager(this.player, this.noteManager, this.isClefThresholds);

  void changeValue(bool isTop, bool up) {
    if (!isClefThresholds) {
      if (noteManager.isValidChange(isTop, up)) {
        player.range.increment(isTop, up);
      }
    } else {
      player.clefThreshold.increment(isTop, up);
    }
  }
}