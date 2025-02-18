import 'package:toolkit/models/key_signature/key_signature.dart';

class KeySignatureBuilderData {
  final double spacing = 27;

  final List<int> sharpOrder = [3, 0, 4, 1, 5, 2, 6];
  final List<int> flatOrder = [6, 2, 5, 1, 4, 0, 3]; // Interestingly, just reversed.

  final List<int> sharpPositions = [10, 7, 11, 8, 5, 9, 6];
  final List<int> flatPositions = [6, 9, 5, 8, 4, 7, 3];

  double clefOffset(KeySignature keySignature) {
    return spacing * (keySignature.sharps + keySignature.flats) + 20;
  }
}
