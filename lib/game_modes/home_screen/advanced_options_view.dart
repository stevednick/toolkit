import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/models/player.dart';
import 'package:toolkit/scenes/range_selection_scene.dart';

class AdvancedOptionsView extends StatefulWidget {
  final Player player;
  const AdvancedOptionsView(this.player, {super.key});

  @override
  State<AdvancedOptionsView> createState() => _AdvancedOptionsViewState();
}

class _AdvancedOptionsViewState extends State<AdvancedOptionsView> {
  Widget _buildMainText() {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "Choose how low treble clef and high bass clef notes should go.",
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildClefThresholdsScene() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 500,
        child: GameWidget(
            game: RangeSelectionScene(widget.player, isClefThresholds: true)),
      ),
    );
  }

  Widget _buildBackButton() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: BackButton(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildClefThresholdsScene(),
          _buildMainText(),
          _buildBackButton(),
        ],
      ),
    );
  }
}
