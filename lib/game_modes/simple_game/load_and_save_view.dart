import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/widgets/qr_code_generator.dart';
import 'package:toolkit/widgets/qr_scanner.dart';
import 'package:toolkit/widgets/widgets.dart';

class LoadAndSaveView extends StatefulWidget {
  late GameOptions gameOptions;
  late Player player;
  final Function() refreshScene;
  LoadAndSaveView(
      {super.key,
      required this.gameOptions,
      required this.player,
      required this.refreshScene});

  @override
  State<LoadAndSaveView> createState() => _LoadAndSaveViewState();
}

class _LoadAndSaveViewState extends State<LoadAndSaveView> {
  Widget _buildQRScannerButton() {
    return Align(
      alignment: Alignment(0.5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              textAlign: TextAlign.center,
              "Use the QR scanner to load settings from a QR code."
            ),),
          SizedBox(
            height: 40,
          ),
          NiceButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrScanner(
                      player: widget.player,
                    ),
                  ),
                );
              },
              text: "Scan Code"),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BackButton(
        onPressed: () {
          widget.refreshScene();
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildQRCodeGenerator() {
    return Align(
      alignment: Alignment(-0.5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              "Scan this code from your from Toolkit on another device to share your game settings,",
              //ssoftWrap: true,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          QRCodeGenerator(gameOptions: widget.gameOptions),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackButton(),
          _buildQRScannerButton(),
          _buildQRCodeGenerator(),
        ],
      ),
    );
  }
}
