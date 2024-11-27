import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/buzz_cave/buzz_cave_controller.dart';
import 'package:toolkit/game_modes/buzz_cave/buzz_cave_scene.dart';
class BuzzCaveView extends StatefulWidget {
  const BuzzCaveView({super.key});

  @override
  State<BuzzCaveView> createState() => _BuzzCaveViewState();
}

class _BuzzCaveViewState extends State<BuzzCaveView> {
  final BuzzCaveController gameController = BuzzCaveController();
  late BuzzCaveScene gameScene;

  @override
  void initState() {
    gameScene = BuzzCaveScene(gameController);
    gameController.state.addListener(() {
      setState(() {
        //
      });
    });
    super.initState();
  }

  Widget _buildHeardNoteText() {
    return ValueListenableBuilder(
      valueListenable: gameController.heardNote,
      builder: (context, note, child) {
        return Positioned(
          top: 60,
          left: 30,
          child: Text(
            note.toString(),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLivesText() {
    return ValueListenableBuilder(
      valueListenable: gameController.lives,
      builder: (context, note, child) {
        return Positioned(
          top: 130,
          left: 30,
          child: Text(
            "Lives: ${gameController.lives.value.toString()}",
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameWidget() {
    return Center(
      child: SizedBox(
        width: 500,
        height: 500,
        child: GameWidget(
          game: gameScene,
        ),
      ),
    );
  }

  Widget _buildSliders() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Range"),
            _buildSlider(
              label: gameController.range.toInt().toString(),
              value: gameController.range,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (newValue) {
                setState(() {
                  gameController.range = newValue;
                });
              },
            ),
            Text(gameController.range.toInt().toString()),
            const Text("Mid Note"),
            _buildSlider(
              label: gameController.middleNote.toString(),
              value: gameController.middleNote,
              min: -20,
              max: 20,
              divisions: 40,
              onChanged: (newValue) {
                setState(() {
                  gameController.middleNote = newValue;
                });
              },
            ),
            Text(gameController.middleNote.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Slider(
      label: label,
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
    );
  }

  Widget _buildScoreText() {
    return ValueListenableBuilder(
      valueListenable: gameController.enemiesHit,
      builder: (context, score, child) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Score: $score",
              style: const TextStyle(fontSize: 40),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          child: Text(gameController.startButtonText),
          onPressed: () {
            setState(() {
              gameController.startPressed();
            });
          },
        ),
      ),
    );
  }

  Widget _buildGameOverText() {
    return Visibility(
      visible: gameController.state.value == BuzzGameState.gameOver,
      child: const Align(
        alignment: Alignment.center,
        child: Text(
          "Game Over!",
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BackButton(
        onPressed: () {
          gameController.dispose();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildHeardNoteText(),
          _buildLivesText(),
          _buildGameWidget(),
          if (gameController.state.value == BuzzGameState.waitingToStart)
            _buildSliders(),
          _buildScoreText(),
          _buildStartButton(),
          _buildGameOverText(),
          _buildBackButton(),
        ],
      ),
    );
  }
}
