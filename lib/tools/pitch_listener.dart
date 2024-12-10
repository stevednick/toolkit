// import 'dart:async';
// import 'package:pitch_detector_dart/pitch_detector.dart';
// import 'package:pitch_detector_plus/pitch_detector_plus.dart';
// import 'note_getter.dart';


// todo kept for posterity... 
// class PitchListener {  
//   final pitchDetectorDart = PitchDetectorPlus();
//   late PitchDetector pitchDart;
//   StreamSubscription? streamSub;
//   Function(int) onNoteDetected;

//   PitchListener({required this.onNoteDetected});

//   Future<void> initialize() async {
//     final data = await pitchDetectorDart.initialize();
//     print(data.bufferSize);
//     pitchDart = PitchDetector(
//       data.sampleRate.toDouble(),
//       data.bufferSize,
//     );
//   }

//   Future<void> startCapture() async {
//     await pitchDetectorDart.startRecording();
//     streamSub = pitchDetectorDart.listenToPitchData().listen((event) {
//       _listener(List<double>.from(event['data']));
//     });
//   }

//   Future<void> stopCapture() async {
//     await pitchDetectorDart.stopRecording();
//     streamSub?.cancel();
//   }

//   void _listener(List<double> audioSample) {
//     final result = pitchDart.getPitch(audioSample);
//     final int note = NoteGetter().getNotefromFrequency(result.pitch);
//     onNoteDetected(note);
//   }
// }