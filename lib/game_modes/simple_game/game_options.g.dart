// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameOptions _$GameOptionsFromJson(Map<String, dynamic> json) => GameOptions(
      version: (json['version'] as num).toInt(),
      t: (json['t'] as num).toInt(),
      b: (json['b'] as num).toInt(),
      tr: json['tr'] as String,
      tCT: (json['tCT'] as num).toInt(),
      bCT: (json['bCT'] as num).toInt(),
      cS: (json['cS'] as num).toInt(),
      nS: (json['nS'] as List<dynamic>).map((e) => e as bool).toList(),
      kS: (json['kS'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GameOptionsToJson(GameOptions instance) =>
    <String, dynamic>{
      'version': instance.version,
      't': instance.t,
      'b': instance.b,
      'tr': instance.tr,
      'tCT': instance.tCT,
      'bCT': instance.bCT,
      'cS': instance.cS,
      'nS': instance.nS,
      'kS': instance.kS,
    };
