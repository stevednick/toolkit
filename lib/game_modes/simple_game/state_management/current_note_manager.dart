// Todo Start this. Have a little think about how this will all work. Does it work with custom data types?

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/tools/tools.dart';

class NoteState {
  final NoteData currentNote;

  NoteState({required this.currentNote});

  NoteState copyWith({NoteData? currentNote}) {
    return NoteState(currentNote: currentNote ?? this.currentNote);
  }
}

class NoteStateManager extends StateNotifier<NoteState> {
  NoteStateManager() : super(NoteState(currentNote: NoteData.placeholderValue));

  final NoteGenerator noteGenerator = NoteGenerator();

  void setNote(NoteData note) {
    print("setNote called with ${note.noteNum}");
    state = state.copyWith(currentNote: note);
  }

  void generateNewNote(Player player, bool isBigJumpsMode) {
    NoteData note =
        noteGenerator.randomNoteFromRange(player, bigJumps: isBigJumpsMode);
    print("Note Generated");
    setNote(note);
  }
}

final noteStateProvider =
    StateNotifierProvider<NoteStateManager, NoteState>((ref) {
  return NoteStateManager();
});