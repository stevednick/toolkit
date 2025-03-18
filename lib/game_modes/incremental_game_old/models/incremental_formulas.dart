import 'dart:math';

class IncrementalFormulas{
  static double baseCost = 10;
  static double costGrowthRate = 1.5;
  static double baseReward = 1;
  static double growthFactor = 0.05;

  static double noteUnlockCost(int n){
    return baseCost * pow(costGrowthRate, n);
  }

  static double playingReward(int n, int unlockedNotes){
    return (baseReward + n) * scoreMultiplier(unlockedNotes);
  }

  static double scoreMultiplier(int unlockedNotes){
    return (1 + unlockedNotes * growthFactor);
  }
}