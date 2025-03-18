import 'package:toolkit/game_modes/incremental/unlockables/idle_note.dart';
import 'package:toolkit/models/note_data.dart';

class IdleNoteList {
  List<IdleNote> list = [
    IdleNote(NoteData.octave[0], 3, 1, 1.07),
    IdleNote(NoteData.octave[2], 60, 60, 1.15),
    IdleNote(NoteData.octave[4], 720, 540, 1.14),
    IdleNote(NoteData.octave[5], 8640, 4320, 1.13),   
    IdleNote(NoteData.octave[7], 103680, 51840, 1.12),  
  ];
}