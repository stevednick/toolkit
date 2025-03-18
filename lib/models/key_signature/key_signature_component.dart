import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:toolkit/models/asset.dart';
import 'package:toolkit/models/clef.dart';
import 'package:toolkit/models/key_signature/key_signature.dart';
import 'package:toolkit/models/key_signature/key_signature_builder_data.dart';
import 'package:toolkit/tools/config.dart';
import 'package:logging/logging.dart';

class KeySignatureComponent extends PositionComponent implements OpacityProvider {
  static const double ACCIDENTAL_SPACING = 27;
  static const int BASS_CLEF_OFFSET = 14;
  
  final KeySignature keySignature;
  final KeySignatureBuilderData data = KeySignatureBuilderData();
  final Logger _logger = Logger('KeySignatureComponent');

  late final PositionComponent trebleHolder;
  late final PositionComponent bassHolder;
  
  KeySignatureComponent(this.keySignature) {
    setUp();
  }

  void setUp() {
    bassHolder = buildKeySignatureForClef(Clef.bass());
    trebleHolder = buildKeySignatureForClef(Clef.treble());
    add(bassHolder);
    add(trebleHolder);
    displayKeySignature(Clef.neutral());
  }

  PositionComponent buildKeySignatureForClef(Clef clef) {
    PositionComponent holder = PositionComponent();
    
    try {
      _buildAccidentals(holder, clef, keySignature.sharps, data.sharpPositions, Asset.createSharp, 'Sharp');
      _buildAccidentals(holder, clef, keySignature.flats, data.flatPositions, Asset.createFlat, 'Flat');
    } catch (e) {
      _logger.warning('Error building key signature for ${clef.name} clef: $e');
    }
    
    return holder;
  }
  
  void _buildAccidentals(PositionComponent holder, Clef clef, int count, List<int> positions, Asset Function() createAsset, String accidentalType) {
    for (int i = 0; i < count; i++) {
      PositionComponent positionComponent = PositionComponent();
      double xPos = ACCIDENTAL_SPACING * i;
      double yPos = -lineGap * (positions[i] + clef.offset - (clef.name == "Bass" ? BASS_CLEF_OFFSET : 0)) / 2;
      
      Asset accidental = createAsset();

      positionComponent.add(accidental);
      
      positionComponent.position = Vector2(xPos, yPos);

      holder.add(positionComponent);
    
    }
  }
  
  void displayKeySignature(Clef clef) {
    _setVisibility(trebleHolder, clef.name == "Treble");
    _setVisibility(bassHolder, clef.name == "Bass");
    _logger.info('Displaying key signature for ${clef.name} clef');
  }
  
  void _setVisibility(PositionComponent holder, bool isVisible) {
    for (var component in holder.children) {
      for (var asset in component.children) {
        if (asset is Asset) {
          asset.isVisible = isVisible;
          _logger.info('Set visibility of ${component.runtimeType} to $isVisible');
        }
      }
    }
  }

  double _opacity = 1;

  @override
  double get opacity => _opacity;

  @override
  set opacity(double value) {
    _opacity = value;
    _setOpacity(trebleHolder, value);
    _setOpacity(bassHolder, value);
  }

  void _setOpacity(PositionComponent holder, double opacity) {
    for (var component in holder.children) {
      for (var asset in component.children) {
        if (asset is Asset) {
          asset.opacity = opacity;
          _logger.info('Set opacity of ${component.runtimeType} to $opacity');
        }
      }
    }
  }
}