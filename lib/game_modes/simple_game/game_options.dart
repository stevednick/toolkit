import 'package:json_annotation/json_annotation.dart';
import 'package:toolkit/models/player.dart';

part 'game_options.g.dart';

@JsonSerializable()
class GameOptions {
  final int top;
  final int bottom;
  // final bool soundEnabled;
  // final String playerName;

  GameOptions({
    required this.top,
    required this.bottom,
  });

  factory GameOptions.fromJson(Map<String, dynamic> json) => _$GameOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$GameOptionsToJson(this);
}