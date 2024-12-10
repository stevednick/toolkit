import 'package:toolkit/models/models.dart';

class UnlockableNote {
  final NoteData data;
  bool isUnlocked = true;
  int num;

  UnlockableNote(this.data, this.num, {bool unlockByDefault = false}){
    if (!unlockByDefault) {
      loadIsUnlocked();
    } else {
      unlock();
    }
    
  }

  Future<void> loadIsUnlocked() async {
    isUnlocked = await Settings.getSetting(keyString());
  }

  Future<void> unlock({bool relock = false}) async {
    isUnlocked = !relock;
    await Settings.saveSetting(keyString(), !relock);
  }

  static Future<void> relockAll() async {
    for (UnlockableNote note in noteList){
      if (note.num != 0){
        note.unlock(relock: true);
      }
    }
  }

  String keyString(){
    return "${data.name}-${data.noteNum}-is-unlocked";
  }

  static List<UnlockableNote> noteList = [
    UnlockableNote(NoteData.findFirstChoiceByNumber(0, Clef.treble()), 0, unlockByDefault: true),
    UnlockableNote(NoteData.findFirstChoiceByNumber(2, Clef.treble()), 1),
    UnlockableNote(NoteData.findFirstChoiceByNumber(4, Clef.treble()), 2),
    UnlockableNote(NoteData.findFirstChoiceByNumber(5, Clef.treble()), 3),
    UnlockableNote(NoteData.findFirstChoiceByNumber(3, Clef.treble()), 4),
    UnlockableNote(NoteData.findFirstChoiceByNumber(1, Clef.treble()), 5),
  ];

}