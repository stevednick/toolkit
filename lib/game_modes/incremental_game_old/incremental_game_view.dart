import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/incremental_game_old/incremental_game_controller.dart';
import 'package:toolkit/game_modes/incremental_game_old/incremental_game_scene.dart';
import 'package:toolkit/game_modes/incremental_game_old/models/unlockable_note.dart';
import 'package:toolkit/widgets/fade_text.dart';
import 'package:toolkit/widgets/nice_button.dart';

class IncrementalGameView extends StatefulWidget {
  const IncrementalGameView({super.key});

  @override
  State<IncrementalGameView> createState() => _IncrementalGameViewState();
}

class _IncrementalGameViewState extends State<IncrementalGameView> {
  final String _currentTransposition = "Horn in F";
  late final IncrementalGameController controller;
  late final IncrementalGameScene scene;

  @override
  void initState() {
    controller = IncrementalGameController();
    scene = IncrementalGameScene(controller);
    super.initState();

    //_currentText = "New Value";
  }

  Widget _buildGameScene() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 500,
        child: GameWidget(
          game: scene,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 15,
      left: 15,
      child: BackButton(
        onPressed: () {
          controller.dispose();
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildTranspositionText() {
    return Positioned(
      top: 30,
      left: 60,
      child: FadeText(
        text: _currentTransposition,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildMoneyText() {
    return Positioned(
      top: 30,
      right: 30,
      child: ValueListenableBuilder(
        valueListenable: controller.money,
        builder: (context, money, child) {
          return Text("Cash: £$money");
        },
      ),
    );
  }

  Widget _buildNoteUnlockButton() {
    return Positioned(
      top: 70,
      right: 30,
      child: NiceButton(onPressed: controller.unlockNote, text: "Unlock Note"),
    );
  }

  Widget _buildStartButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          NiceButton(
            text: "Start",
            onPressed: () {
              setState(() {
                controller.startButtonPressed();
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: NiceButton(
        onPressed: UnlockableNote.relockAll,
        text: "Reset",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildMoneyText(),
          _buildGameScene(),
          _buildTranspositionText(),
          _buildNoteUnlockButton(),
          _buildBackButton(),
          _buildStartButton(),
          _buildResetButton(),
        ],
      ),
    );
  }
}
