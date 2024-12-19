import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/models/clef_selection.dart';
import 'package:toolkit/models/note_data.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/models/transposition.dart';
import 'package:toolkit/widgets/nice_button.dart';
import 'dart:convert';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key, required this.player});

  final Player player;

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  GameOptions? gameOptions;
  MobileScannerController? _controller;
  bool dataSeen = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> saveOptions(GameOptions options) async {
    try {
      widget.player.clefSelection = ClefSelection.values[options.cS];
      for (int i = 0; i < options.nS.length; i++) {
        NoteData.octave[i].isActive = options.nS[i];
        await NoteData.octave[i].saveIsActive();
      }
      await widget.player.clefThreshold
        ..trebleClefThreshold = options.tCT
        ..bassClefThreshold = options.bCT
        ..saveValues();
      await widget.player.range
        ..top = options.t
        ..bottom = options.b
        ..saveValues();
      await widget.player.saveKeySignature(options.kS);
      await widget.player.saveInstrumentAndTransposition(
        Transposition.getByName(options.tr) ?? widget.player.selectedInstrument.currentTransposition,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Options saved successfully'), backgroundColor: Colors.green),
      );
    } catch (error) {
      print("Error saving options: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving options: $error'), backgroundColor: Colors.red),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _showSaveOptionsDialog(GameOptions scannedOptions) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save New Settings?'),
          content: const Text('Do you want to save the new game options?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                saveOptions(scannedOptions);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: RotatedBox(
              quarterTurns: 3,
              child: MobileScanner(
                controller: _controller,
                onDetect: (scanData) async {
                  if (dataSeen) return;
                  try {
                    final jsonData = jsonDecode(scanData.barcodes[0].rawValue!);
                    final scannedOptions = GameOptions.fromJson(jsonData);
                    dataSeen = true;
                    await _showSaveOptionsDialog(scannedOptions);
                  } catch (e) {
                    _showErrorSnackBar('Error parsing QR code: $e');
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 30,
            child: NiceButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Back",
            ),
          ),
        ],
      ),
    );
  }
}
