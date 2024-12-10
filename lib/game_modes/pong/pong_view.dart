import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/pong/pong_controller.dart';
import 'package:toolkit/game_modes/pong/pong_scene.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/scenes/range_selection_scene.dart';
import 'package:toolkit/widgets/widgets.dart';

class PongView extends StatefulWidget {
  const PongView({super.key});

  @override
  _PongViewState createState() => _PongViewState();
}

class _PongViewState extends State<PongView>
    with SingleTickerProviderStateMixin {
  final PongController gameController = PongController();
  late PongScene leftPongScene, rightPongScene;
  late AnimationController _controller;

  final TextStyle playerTextStyle =
      const TextStyle(fontSize: 36, color: Colors.black);
  final TextStyle countdownTextStyle = const TextStyle(fontSize: 60);
  List<bool> showTicks = [false, false];

  @override
  void initState() {
    super.initState();

    gameController.countDownText.addListener(() {
      if (gameController.countDownText.value == "Go!") {
        refreshScene();
      }
    });
    gameController.currentBeat.addListener(triggerFlash);
    gameController.players[0].score.addListener(() {
      triggerTick(0);
    });
    gameController.players[1].score.addListener(() {
      triggerTick(1);
    });

    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 300), // Duration of the fade in/out
    );

    leftPongScene = PongScene(gameController, 0);
    rightPongScene = PongScene(gameController, 1);
  }
  
  void triggerTick(int side) {
    setState(() {
      showTicks[side] = true;
    });
    Timer _ = Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        showTicks[side] = false;
      });
    });
  }

  void triggerFlash() {
    _controller.forward(from: 0);
  }

  void _startButtonPressed() {
    setState(() {
      gameController.startButtonPressed();
    });
  }

  void refreshScene() {
    setState(() {});
  }

  Widget _buildGameWidgets() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.max,
        children: [
          _buildPongScene(0, leftPongScene),
          const SizedBox(width: 100),
          _buildPongScene(1, rightPongScene),
        ],
      ),
    );
  }

  Widget _buildPongScene(int playerIndex, PongScene scene) {
    return SizedBox(
      width: 300,
      height: 500,
      child: GameWidget(
        game: gameController.mode.value == GameMode.running ||
                gameController.mode.value == GameMode.countingDown
            ? scene
            : RangeSelectionScene(gameController.players[playerIndex]),
      ),
    );
  }

  Widget _buildTranspositionDropDowns() {
    return Stack(
      children: [
        _buildTranspositionDropDownForPlayer(0, Alignment.topLeft),
        _buildTranspositionDropDownForPlayer(1, Alignment.topRight),
      ],
    );
  }

  Widget _buildTranspositionDropDownForPlayer(
      int playerIndex, Alignment alignment) {
    final player = gameController.players[playerIndex];
    return Positioned(
      top: 30,
      left: alignment == Alignment.topLeft ? 40 : null,
      right: alignment == Alignment.topRight ? 40 : null,
      child: gameController.mode.value == GameMode.waitingToStart ||
              gameController.mode.value == GameMode.finished
          ? TranspositionDropDown(player: player)
          : Text(
              "Horn in ${player.selectedInstrument.currentTransposition.name}",
              style: const TextStyle(fontSize: 24),
            ),
    );
  }

  Widget _buildClefSelectionButton() {
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          left: 30,
          child: EnhancedClefSelectionButton(
              gameController.players[0], refreshScene),
        ),
        Positioned(
          bottom: 20,
          right: 30,
          child: EnhancedClefSelectionButton(
              gameController.players[1], refreshScene),
        ),
      ],
    );
  }

  Widget _buildScoreTexts() {
    return Stack(
      children: [
        Positioned(
          bottom: 30,
          left: 170,
          child: Visibility(
            visible: gameController.mode.value != GameMode.waitingToStart,
            child: ScoreText(
              player: gameController.players[0],
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 170,
          child: Visibility(
            visible: gameController.mode.value != GameMode.waitingToStart,
            child: ScoreText(
              player: gameController.players[1],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerText() {
    return ValueListenableBuilder(
      valueListenable: gameController.currentPlayer,
      builder: (context, player, child) {
        return Align(
          alignment: const Alignment(0, -0.9),
          child: Text(
            gameController.gameText.value,
            style: playerTextStyle,
          ),
        );
      },
    );
  }

  Widget _buildCountdownText() {
    return ValueListenableBuilder(
      valueListenable: gameController.countDownText,
      builder: (context, text, child) {
        return Align(
          alignment: const Alignment(0, 0),
          child: Text(
            text,
            style: countdownTextStyle,
          ),
        );
      },
    );
  }

  Widget _buildStartButton() {
    return ValueListenableBuilder(
      valueListenable: gameController.mode,
      builder: (context, mode, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NiceButton(
                text: gameController.buttonText,
                onPressed: _startButtonPressed,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTempoSelectorButton(){
    return Positioned(
      left: 30,
      bottom: 70,
      child: TempoSelector(onTempoChanged: (int newTempo){}, keyString: 'pong_tempo'),);
  }

  Widget _buildMenuComponents(){
    return Stack(
      children: [
        _buildClefSelectionButton(),
        _buildTempoSelectorButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildGameWidgets(),
          _buildTranspositionDropDowns(),
          if (gameController.mode.value == GameMode.waitingToStart || gameController.mode.value == GameMode.finished)
            _buildMenuComponents(),
          _buildScoreTexts(),
          _buildPlayerText(),
          _buildCountdownText(),
          _buildStartButton(),
          const BackButton(),
        ],
      ),
    );
  }
}
