import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:math';

const mySampleRate = 44100;
const myBufferSize = 2500;
// const myBufferSize = 1500;
// const myBufferSize = 1024;
const myThreshold = 0.2; // threshold of detected base

class YINPitchDetection {
  final int sampleRate;
  final int windowLength;
  final double minFreq;
  final double maxFreq;
  final double harmonicThreshold;

  YINPitchDetection({
    this.sampleRate = mySampleRate,
    this.windowLength = myBufferSize,
    this.minFreq = 40,
    this.maxFreq = 3000,
    this.harmonicThreshold = myThreshold,
  });

  static const int _historySize = 3;
  final List<double> _recentPitches = [];
  final List<double> _recentConfidences = [];
  double _lastValidPitch = 0.0;
  int _pitchChangeCounter = 0;
  static const int _maxPitchChangeCount = 3;

  (double, double) detectPitchWithConfidence(Float32List buffer) {
    final int tauMin = (sampleRate / maxFreq).floor();
    final int tauMax = (sampleRate / minFreq).floor();

    List<double> df = _differenceFunction(buffer, windowLength, tauMax);
    List<double> cmdf = _cumulativeMeanNormalizedDifferenceFunction(df, tauMax);
    int p = _getPitch(cmdf, tauMin, tauMax, harmonicThreshold);

    // if pitch is 0 just return
    if (p == 0){
      return (0,0);
    }


    double pitch = p != 0 ? sampleRate / p : 0.0;

    if (p > 0 && p < cmdf.length - 1) {
      double alpha = cmdf[p-1];
      double beta = cmdf[p];
      double gamma = cmdf[p+1];
      double peakIndex = p + 0.5 * (alpha - gamma) / (alpha - 2*beta + gamma);
      pitch = sampleRate / peakIndex;
    }

    double rawConfidence = _calculateRawConfidence(buffer, pitch, cmdf[p]);
    double smoothedConfidence = _smoothConfidence(rawConfidence, pitch);

    _updateHistory(pitch, smoothedConfidence);

    return (pitch, smoothedConfidence);
  }

  double _calculateRawConfidence(Float32List buffer, double pitch, double cmdfValue) {
    if (pitch == 0) return 0.0;

    double confidence = 1.0;

    // Factor 1: Signal-to-Noise Ratio (SNR)
    double rms = _calculateRMS(buffer);
    double snr = 20 * log10(rms / 0.0001);
    confidence *= _mapToConfidence(snr, 5, 30);

    // Factor 2: Clarity of pitch (based on CMDF value)
    confidence *= 1 - cmdfValue;

    // Factor 3: Frequency range consideration
    if (pitch < minFreq) {
      confidence *= _mapToConfidence(pitch, minFreq, 80);
    } else if (pitch > maxFreq) {
      confidence *= _mapToConfidence(maxFreq, pitch, maxFreq * 1.2);
    }

    // Factor 4: Pitch stability
    if (_lastValidPitch > 0) {
      double pitchRatio = pitch / _lastValidPitch;
      if (pitchRatio > 1.2 || pitchRatio < 0.8) {
        confidence *= 0.8; // Reduce confidence for large jumps
      }
    }

    return confidence.clamp(0.0, 1.0);
  }

  double _smoothConfidence(double rawConfidence, double pitch) {
    if (_recentConfidences.isEmpty || _lastValidPitch == 0) {
      _lastValidPitch = pitch;
      return rawConfidence;
    }

    double pitchChangeRatio = (pitch - _lastValidPitch).abs() / _lastValidPitch;
    bool isSignificantChange = pitchChangeRatio > 0.2;

    if (isSignificantChange) {
      _pitchChangeCounter = 0;
      _lastValidPitch = pitch;
      return 0.0; // Reset confidence to 0 for significant changes
    }

    _pitchChangeCounter = min(_pitchChangeCounter + 1, _maxPitchChangeCount);

    // Gradual increase in confidence
    double confidenceIncreaseFactor = _pitchChangeCounter / _maxPitchChangeCount;
    double smoothedConfidence = rawConfidence * confidenceIncreaseFactor;

    // Update last valid pitch
    _lastValidPitch = pitch;

    return smoothedConfidence.clamp(0.0, 1.0);
  }

  void _updateHistory(double pitch, double confidence) {
    _recentPitches.add(pitch);
    _recentConfidences.add(confidence);
    if (_recentPitches.length > _historySize) {
      _recentPitches.removeAt(0);
      _recentConfidences.removeAt(0);
    }
  }


  double _calculateRMS(Float32List buffer) {
    double sum = 0;
    for (var sample in buffer) {
      sum += sample * sample;
    }
    return sqrt(sum / buffer.length);
  }

  double _mapToConfidence(double value, double min, double max) {
    return ((value - min) / (max - min)).clamp(0.0, 1.0);
  }

  double log10(double x) => log(x) / ln10;

  List<double> _differenceFunction(Float32List x, int N, int tauMax) {
    List<double> df = List<double>.filled(tauMax + 1, 0);
    for (int tau = 1; tau <= tauMax; tau++) {
      for (int j = 0; j < N - tau; j++) {
        double diff = x[j] - x[j + tau];
        df[tau] += diff * diff;
      }
    }
    return df;
  }

  List<double> _cumulativeMeanNormalizedDifferenceFunction(List<double> df, int N) {
    List<double> cmdf = List<double>.filled(N + 1, 0);
    cmdf[0] = 1.0;
    double runningSum = 0.0;
    for (int tau = 1; tau <= N; tau++) {
      runningSum += df[tau];
      cmdf[tau] = df[tau] * tau / runningSum;
    }
    return cmdf;
  }

  int _getPitch(List<double> cmdf, int tauMin, int tauMax, double harmonicThreshold) {
    int tau = tauMin;
    while (tau < tauMax) {
      if (cmdf[tau] < harmonicThreshold) {
        while (tau + 1 < tauMax && cmdf[tau + 1] < cmdf[tau]) {
          tau++;
        }
        return tau;
      }
      tau++;
    }
    return 0; // No pitch found
  }
}