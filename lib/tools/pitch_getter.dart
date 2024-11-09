import 'package:flutter/foundation.dart';
import 'package:toolkit/tools/yin_pitch_detection.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
// Find a way to add an observer to this in the code. 

// Test once back in internet/company. 

class PitchGetter {

  PitchGetter(){ // add monitor to something here in to detect pitch change... hmm 
    _requestMicrophonePermission();
    _audioCapture.init();
  }
  final pitchDetector = YINPitchDetection();
  final FlutterAudioCapture _audioCapture = FlutterAudioCapture();

  bool _isListening = false;

  final ValueNotifier<double> pitchNotifier = ValueNotifier<double>(0.0);

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Microphone permission not granted');
    }
  }

    void toggleListening() {
      _isListening = !_isListening;
    if (_isListening) {
      startListening();
    } else {
      stopListening();
    }
  }

  void startListening() {
    _audioCapture.start(
          (Float32List obj) {
        final (pitch, confidence) = pitchDetector.detectPitchWithConfidence(obj);

        // print("detectPitchWithConfidence $pitch $confidence");
        if (pitch > 0 && pitch.isFinite && (pitch > 1500 || confidence > 0.51) ) {

            pitchNotifier.value = pitch;
        } else {
          pitchNotifier.value = -10000;
        }
      },
          (Object e) {
        print("Error: ${e.toString()}");
      },
      sampleRate: mySampleRate,
      bufferSize: myBufferSize,
    );
  }

  void stopListening() {
    _audioCapture.stop();
  }
}