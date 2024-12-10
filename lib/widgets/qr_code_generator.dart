import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';

class QRCodeGenerator extends StatelessWidget { // todo move this somewhere more appropriate?
  final GameOptions gameOptions;

  const QRCodeGenerator({super.key, required this.gameOptions});

  @override
  Widget build(BuildContext context) {
    final optionsJson = jsonEncode(gameOptions.toJson());

    return Center(
      child: QrImageView(
        data: optionsJson,
        version: QrVersions.auto,
        size: 200.0,
      ),
    );
  }
}