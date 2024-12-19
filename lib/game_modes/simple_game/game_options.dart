import 'package:json_annotation/json_annotation.dart';

part 'game_options.g.dart';

@JsonSerializable()
class GameOptions {
  final int version;
  final int t; // top
  final int b; // bottom
  final String tr; // transposition
  final int tCT; // Treble Clef Threshold
  final int bCT; // Bass Clef Threshold
  final int cS; // Clef Selection
  final List<bool> nS; // Note Selection
  @JsonKey(defaultValue: 0)
  final int kS; // Key Signature 

  GameOptions({
    required this.version,
    required this.t,
    required this.b,
    required this.tr,
    required this.tCT,
    required this.bCT,
    required this.cS,
    required this.nS,
    this.kS = 0,
  });

  factory GameOptions.fromJson(Map<String, dynamic> json) {
    // Check if the 'version' field exists in the JSON
    if (!json.containsKey('version')) {
      // If 'version' doesn't exist, it's an old format. Add default values.
      json['version'] = 1;
      json['kS'] = 0;
    }
    return _$GameOptionsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GameOptionsToJson(this);
}

