import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/tools/config.dart';
import 'package:toolkit/tools/utils.dart';

class KeySignatureComponent extends PositionComponent implements OpacityProvider{

  final int sharps;
  final int flats;

  KeySignatureComponent(this.sharps, this.flats);
  
  void displayKeySignature(Clef clef){
    Utils.removeAllChildren(this);
    final double spacing = 27;
    final List<int> sharpPositions = [10, 7, 11, 8, 5, 9, 6];
    final List<int> flatPositions = [6, 9, 5, 8, 4, 7, 3];
    PositionComponent holder = PositionComponent();
    for (int i = 0; i < sharps; i++) {
      Asset sharp = Asset.createSharp();
      PositionComponent sharpHolder = PositionComponent()
        ..position = Vector2(
            spacing * i,
            -lineGap *
                (sharpPositions[i] +
                    clef.offset -
                    (clef.name == "Bass" ? 14 : 0)) /
                2);
      sharpHolder.add(sharp);
      holder.add(sharpHolder);
    }
    for (int i = 0; i < flats; i++) {
      Asset flat = Asset.createFlat();
      PositionComponent flatHolder = PositionComponent()
        ..position = Vector2(
            spacing * i,
            -lineGap *
                (flatPositions[i] +
                    clef.offset -
                    (clef.name == "Bass" ? 14 : 0)) /
                2);
      flatHolder.add(flat);
      holder.add(flatHolder);
    }
    add(holder);
  }

  @override
  double opacity = 0;
}