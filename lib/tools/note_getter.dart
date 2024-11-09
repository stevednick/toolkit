import 'dart:math';

class NoteGetter {
  int getNotefromFrequency(double frequency){
    return getNoteWithTuningFromFrequency(frequency).round();
  }

  double getNoteWithTuningFromFrequency(double frequency){
    if (frequency < 1){
      return -1000.0;
    }
    const aPitch = 440;
    double ratio = frequency/aPitch;
    double logBase(num x, num base) => log(x) / log(base);
    double log2(num x) => logBase(x, 2);
    double noteNum = 12 * log2(ratio) + 9;
    return noteNum;
  }
}
