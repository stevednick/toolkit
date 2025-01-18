import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class NoteGetter {

  late int aPitch;
  bool aPitchLoaded = false;

  NoteGetter(){
    getAPitch();
  }

  Future<int> getAPitch() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    aPitch = prefs.getInt('aPitch') ?? 440;
    aPitchLoaded = true;
    return aPitch;
  }

  Future<void> setAPitch(int newAPitch) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('aPitch', newAPitch);
    aPitch = newAPitch;
  }

  int getNotefromFrequency(double frequency){
    return getNoteWithTuningFromFrequency(frequency).round();
  }

  double getNoteWithTuningFromFrequency(double frequency){
    if (frequency < 1 || !aPitchLoaded){
      return -1000.0;
    }
    double ratio = frequency/aPitch;
    double logBase(num x, num base) => log(x) / log(base);
    double log2(num x) => logBase(x, 2);
    double noteNum = 12 * log2(ratio) + 9;
    return noteNum;
  }
}
