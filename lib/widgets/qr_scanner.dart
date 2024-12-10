import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/models/player.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key, required this.player});
  final Player player;

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  GameOptions? scannedOptions;

  Future<void> saveValues() async {
    if (scannedOptions != null){
      widget.player.range.top = scannedOptions!.top;
      widget.player.range.bottom = scannedOptions!.bottom;
      await widget.player.range.saveValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackButton(),
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: scannedOptions == null
                      ? const Text('Scan a code')
                      : Text('Scanned Options: ${scannedOptions!.top}'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      try {
        final jsonData = jsonDecode(scanData.code);
        setState(() {
          scannedOptions = GameOptions.fromJson(jsonData);
        });
      } catch (e) {
        print('Error parsing QR code data: $e');
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
