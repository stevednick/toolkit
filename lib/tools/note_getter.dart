import 'dart:math';

import 'package:toolkit/tools/shared_prefs_manager.dart';

class NoteGetter {

  late int aPitch;
  bool aPitchLoaded = false;

  NoteGetter(){
    getAPitch();
  }

  Future<int> getAPitch() async{
    aPitch = await SharedPrefsManager.load<int>('aPitch') ?? 440;
    aPitchLoaded = true;
    return aPitch;
  }

  Future<void> setAPitch(int newAPitch) async{
    await SharedPrefsManager.save<int>('aPitch', newAPitch);
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
