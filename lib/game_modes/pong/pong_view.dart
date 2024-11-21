import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/pong/pong_controller.dart';
import 'package:toolkit/game_modes/pong/pong_scene.dart';
import 'package:toolkit/models/game_mode.dart';
import 'package:toolkit/scenes/range_selection_scene.dart';
import 'package:toolkit/widgets/clef_selection_button.dart';
import 'package:toolkit/widgets/enhanced_clef_selection_button.dart';
import 'package:toolkit/widgets/score_text.dart';
import 'package:toolkit/widgets/tick.dart';
import 'package:toolkit/widgets/transposition_drop_down.dart';

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
  late Animation<double> _animation;

  final TextStyle playerTextStyle =
      const TextStyle(fontSize: 36, color: Colors.black);
  final TextStyle countdownTextStyle = const TextStyle(fontSize: 60);
  List<bool> showTicks = [false, false];

  @override
  void initState() {
    leftPongScene = PongScene(gameController, 0);
    rightPongScene = PongScene(gameController, 1);

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

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    super.initState();
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

  Widget _buildFlashCircle() {
    return Center(
      child: Visibility(
        visible: gameController.mode.value == GameMode.running,
        child: FadeTransition(
          opacity: _animation,
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameWidgets() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
          bottom: 30,
          left: 30,
          child: EnhancedClefSelectionButton(
              gameController.players[0], refreshScene),
        ),
        Positioned(
          bottom: 30,
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
          bottom: 40,
          left: 40,
          child: Visibility(
            visible: gameController.mode.value != GameMode.waitingToStart,
            child: ScoreText(
              player: gameController.players[0],
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          right: 40,
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
              FilledButton(
                onPressed: _startButtonPressed,
                child: Text(gameController.buttonText),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildTicks() {
  //   return Stack(
  //     children: [
  //       Align(
  //         alignment: const Alignment(-0.3, -0.5),
  //         child: tick,
  //       ),
  //       Align(
  //         alignment: const Alignment(0.3, -0.5),
  //         child: tick,
  //       )
  //     ],
  //   );
  // }

  Widget _buildTicksAndFeedbackText() {
    // todo remove feedback text!
    return Visibility(
      visible: gameController.mode.value == GameMode.running,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.5),
            child: ValueListenableBuilder(
                valueListenable: gameController.leftFeedbackText,
                builder: (context, text, child) {
                  return Text(
                    text,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  );
                }),
          ),
          Align(
            alignment: const Alignment(0, -0.5),
            child: ValueListenableBuilder(
                valueListenable: gameController.rightFeedbackText,
                builder: (context, text, child) {
                  return Text(
                    text,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  );
                }),
          ),
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
          _buildFlashCircle(),
          _buildGameWidgets(),
          _buildTranspositionDropDowns(),
          if (gameController.mode.value == GameMode.waitingToStart)
            _buildClefSelectionButton(),
          _buildScoreTexts(),
          _buildPlayerText(),
          _buildCountdownText(),
          _buildStartButton(),
          //_buildTicksAndFeedbackText(),
          const BackButton(),
        ],
      ),
    );
  }
}
