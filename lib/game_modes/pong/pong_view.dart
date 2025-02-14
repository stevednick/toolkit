import 'dart:async';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/pong/pong_controller.dart';
import 'package:toolkit/game_modes/pong/pong_scene.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/scenes/range_selection_scene.dart';
import 'package:toolkit/tools/scaled_positioned.dart';
import 'package:toolkit/tools/utils.dart';
import 'package:toolkit/widgets/widgets.dart';

class PongView extends StatefulWidget {
  const PongView({super.key});

  @override
  _PongViewState createState() => _PongViewState();
}

class _PongViewState extends State<PongView>
    with SingleTickerProviderStateMixin {
  late PongController gameController;
  late PongScene pongScene;

  final TextStyle playerTextStyle =
      const TextStyle(fontSize: 36, color: Colors.black);
  final TextStyle countdownTextStyle = const TextStyle(fontSize: 60);
  List<bool> showTicks = [false, false];
  late List<RangeSelectionScene> rangeSelectionScenes = [];
  double width = 1000;
  ScaleManager scaleManager = ScaleManager();

  @override
  void initState() {
    super.initState();
    
    initializeGameElements();
  }

  Future<void> initializeGameElements() async {
    gameController = PongController();
    rangeSelectionScenes.add(RangeSelectionScene(gameController.players[0]));
    rangeSelectionScenes.add(RangeSelectionScene(gameController.players[1]));

    gameController.countDownText.addListener(() {
      if (gameController.countDownText.value == "Go!") {
        refreshScene();
      }
    });
    //gameController.currentBeat.addListener(triggerFlash);
    gameController.players[0].score.addListener(() {
      triggerTick(0);
    });
    gameController.players[1].score.addListener(() {
      triggerTick(1);
    });
    pongScene = PongScene(gameController);
    
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

  void _startButtonPressed() {
    setState(() {
      gameController.startButtonPressed();
    });
  }

  void refreshScene() {
    setState(() {
      for (int i = 0; i < 2; i++) {
        rangeSelectionScenes[i].changeNote(true);
      }
    });
  }

  Widget _buildGameWidgets() {
    return gameController.mode.value == GameMode.running ||
            gameController.mode.value == GameMode.countingDown
        ? _buildPongScene()
        : _buildRangeSelectionScenes();
  }

  Widget _buildPongScene() {
    return SizedBox.expand(
      child: GameWidget(
        game: pongScene,
      ),
    );
  }

  Widget _buildRangeSelectionScenes() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRangeSelectionScene(0),
          SizedBox(width: 100 * scaleManager.scaleFactor()),
          _buildRangeSelectionScene(1),
        ],
      ),
    );
  }

  Widget _buildRangeSelectionScene(int playerIndex) {
    print(width);
    return SizedBox(
      width: width / 3,
      height: 500,
      child: GameWidget(
        game: rangeSelectionScenes[playerIndex],
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
    return ScaledPositioned(
      top: 30,
      left: alignment == Alignment.topLeft ? 40: null,
      right: alignment == Alignment.topRight ? 40: null,
      scaleFactor: scaleManager.scaleFactor(),
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
        ScaledPositioned(
          bottom: 20,
          left: 30,
          scaleFactor: scaleManager.scaleFactor(),
          child: EnhancedClefSelectionButton(
              gameController.players[0], refreshScene),
        ),
        ScaledPositioned(
          bottom: 20,
          right: 30,
          scaleFactor: scaleManager.scaleFactor(),
          child: EnhancedClefSelectionButton(
              gameController.players[1], refreshScene),
        ),
      ],
    );
  }

  Widget _buildScoreTexts() {
    return Stack(
      children: [
        ScaledPositioned(
          bottom: 30,
          left: 170,
          scaleFactor: scaleManager.scaleFactor(),
          child: Visibility(
            visible: gameController.mode.value != GameMode.waitingToStart,
            child: ScoreText(
              player: gameController.players[0],
            ),
          ),
        ),
        ScaledPositioned(
          bottom: 30,
          right: 170,
          scaleFactor: scaleManager.scaleFactor(),
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
          child: Transform.scale(
            scale: scaleManager.scaleFactor(), 
            child: Text(
              gameController.gameText.value,
              style: playerTextStyle,
            ),
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
          child: Transform.scale(
            scale: scaleManager.scaleFactor(),
            child: Text(
              text,
              style: countdownTextStyle,
            ),
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
              Transform.scale(
                scale: scaleManager.scaleFactor(),
                child: NiceButton(
                  text: gameController.buttonText,
                  onPressed: _startButtonPressed,
                ),
              ),
              SizedBox(height: 40 * scaleManager.scaleFactor()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTempoSelectorButton() {
    return ScaledPositioned(
      left: 30,
      bottom: 70,
      scaleFactor: scaleManager.scaleFactor(),
      child: TempoSelector(
          onTempoChanged: (int newTempo) {}, keyString: 'pong_tempo'),
    );
  }

  Widget _buildMenuComponents() {
    return Stack(
      children: [
        _buildClefSelectionButton(),
        _buildTempoSelectorButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    rangeSelectionScenes[0].width = width;
    rangeSelectionScenes[1].width = width;
    pongScene.screenWidth = width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildGameWidgets(),
          _buildTranspositionDropDowns(),
          if (gameController.mode.value == GameMode.waitingToStart ||
              gameController.mode.value == GameMode.finished)
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
