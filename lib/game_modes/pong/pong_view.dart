import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/home_screen/home_view.dart';
import 'package:toolkit/game_modes/pong/pong_controller.dart';
import 'package:toolkit/game_modes/pong/pong_scene_new.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/scenes/range_selection/range_selection_scene.dart';
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

  double sceneWidthRatio = 0.33;

  late PongScaleManager scaleManager;

  @override
  void initState() {
    super.initState();

    initializeGameElements();
  }

  double scaledValue(double value) {
    return value * scaleManager.scaleFactor();
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
    setState(() {});
  }

  void reloadRangeSelection(int i) {
    setState(() {
      rangeSelectionScenes[i] = RangeSelectionScene(gameController.players[i]);
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
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.1,
          ),
          _buildRangeSelectionScene(1),
        ],
      ),
    );
  }

  Widget _buildRangeSelectionScene(int playerIndex) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 3,
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
    return Positioned(
      top: scaledValue(30),
      left: alignment == Alignment.topLeft ? scaledValue(40) : null,
      right: alignment == Alignment.topRight ? scaledValue(40) : null,
      child: Transform.scale(
        scale: scaleManager.scaleFactor(),
        child: gameController.mode.value == GameMode.waitingToStart ||
                gameController.mode.value == GameMode.finished
            ? TranspositionDropDown(player: player)
            : Text(
                "Horn in ${player.selectedInstrument.currentTransposition.name}",
                style: const TextStyle(fontSize: 24),
              ),
      ),
    );
  }

  Widget _buildClefSelectionButton() {
    return Stack(
      children: [
        Positioned(
          bottom: scaledValue(20),
          left: scaledValue(30),
          child: Transform.scale(
            scale: scaleManager.scaleFactor(),
            child: EnhancedClefSelectionButton(gameController.players[0], () {
              reloadRangeSelection(0);
            }),
          ),
        ),
        Positioned(
          bottom: scaledValue(20),
          right: scaledValue(30),
          child: Transform.scale(
            scale: scaleManager.scaleFactor(),
            child: EnhancedClefSelectionButton(gameController.players[1], () {
              reloadRangeSelection(1);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreTexts() {
    return Stack(
      children: [
        Positioned(
          bottom: scaledValue(30),
          left: scaledValue(170),
          child: Visibility(
            visible: gameController.mode.value != GameMode.waitingToStart,
            child: Transform.scale(
              scale: scaleManager.scaleFactor(),
              child: ScoreText(
                player: gameController.players[0],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: scaledValue(30),
          right: scaledValue(170),
          child: Visibility(
            visible: gameController.mode.value != GameMode.waitingToStart,
            child: Transform.scale(
              scale: scaleManager.scaleFactor(),
              child: ScoreText(
                player: gameController.players[1],
              ),
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
    // todo finish transferring over to scaleValue();
    return Positioned(
      left: scaledValue(30),
      bottom: scaledValue(70),
      child: Transform.scale(
        scale: scaleManager.scaleFactor(),
        child: TempoSelector(
            onTempoChanged: (int newTempo) {}, keyString: 'pong_tempo'),
      ),
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
    double width = MediaQuery.sizeOf(context).width;
    scaleManager = PongScaleManager(width);
    rangeSelectionScenes[0].setWidth(width / 3);
    rangeSelectionScenes[1].setWidth(width / 3);
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
          BackButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PongScaleManager {
  final double screenWidth;
  final double minimumAcceptableWidth = 800;

  PongScaleManager(this.screenWidth);

  double scaleFactor() {
    return min(screenWidth / minimumAcceptableWidth, 1);
  }
}
