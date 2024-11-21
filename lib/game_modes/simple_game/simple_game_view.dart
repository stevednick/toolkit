import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/home_screen/advanced_options_view.dart';
import 'package:toolkit/game_modes/home_screen/note_selector_view.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_scene.dart';
import 'package:toolkit/models/game_mode.dart';
import 'package:toolkit/scenes/range_selection_scene.dart';
import 'package:toolkit/widgets/toggle_button.dart';
import 'package:toolkit/widgets/enhanced_clef_selection_button.dart';
import 'package:toolkit/widgets/nice_button.dart';
import 'package:toolkit/widgets/score_text.dart';
import 'package:toolkit/widgets/tempo_selector_persistance.dart';
import 'package:toolkit/widgets/transposition_drop_down.dart';

class SimpleGameView extends StatefulWidget {
  const SimpleGameView({super.key});

  @override
  _SimpleGameViewState createState() => _SimpleGameViewState();
}

class _SimpleGameViewState extends State<SimpleGameView> {
  late final SimpleGameController gameController;
  late final SimpleGameScene pongScene;

  bool showTick = false;

  @override
  void initState() {
    super.initState();
    gameController = SimpleGameController(triggerTick);
    pongScene = SimpleGameScene(gameController);
  }

  void triggerTick() {
    setState(() {
      showTick = true;
    });
    Timer _ = Timer(const Duration(milliseconds: 1200), () {
      setState(() {
        showTick = false;
      });
    });
  }

  void refreshScene() {
    setState(() {});
  }

  @override
  void dispose() {
    gameController.dispose();
    pongScene.onDispose();
    super.dispose();
  }

  Widget _buildGameScene() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 500,
        child: GameWidget(
          game: gameController.gameMode.value != GameMode.waitingToStart
              ? pongScene
              : RangeSelectionScene(gameController.player),
        ),
      ),
    );
  }

  Widget _buildScoreText() {
    return Positioned(
      top: 40,
      right: 40,
      child: Visibility(
        visible: gameController.gameMode.value == GameMode.running,
        child: ScoreText(
          player: gameController.player,
        ),
      ),
    );
  }

  Widget _buildGameText() {
    return Align(
      alignment: Alignment.topCenter,
      child: ValueListenableBuilder(
        valueListenable: gameController.gameText,
        builder: (context, text, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              text,
              style: const TextStyle(fontSize: 30),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedbackText() {
    return Align(
        alignment: const Alignment(0.5, -0.5),
        child: ValueListenableBuilder(
            valueListenable: gameController.feedbackText,
            builder: (context, text, child) {
              return Text(
                text,
                style: const TextStyle(
                  fontSize: 30,
                ),
              );
            }));
  }

  Widget _buildTranspositionDropDown() {
    return Positioned(
      top: 40,
      left: 40,
      child: gameController.gameMode.value == GameMode.waitingToStart
          ? TranspositionDropDown(
              player: gameController.player,
            )
          : Text(
              "Horn in ${gameController.player.selectedInstrument.currentTransposition.name}",
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
    );
  }

  Widget _buildClefSelectionButton() {
    return Positioned(
      bottom: 130,
      right: 30,
      child: EnhancedClefSelectionButton(gameController.player,
          refreshScene), //ClefSelectionButton(gameController.player, refreshScene),
    );
  }

  Widget _buildStartButton() {
    return ValueListenableBuilder(
      valueListenable: gameController.noteChecker.noteNotifier,
      builder: (context, note, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () {
                  setState(() {
                    gameController.startButtonPressed();
                  });
                },
                child: Text(
                    gameController.gameMode.value == GameMode.waitingToStart
                        ? "Start"
                        : "End"), // Transfer text duties to game controller!
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGhostNoteToggle() {
    return Align(
      alignment: const Alignment(0.7, -0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Switch(
            value: gameController.ghostNotesOn,
            onChanged: (newValue) {
              setState(() {
                gameController.ghostNotesOn = newValue;
              });
            },
          ),
          const Text("Ghost Notes"),
        ],
      ),
    );
  }

  Widget _buildTickAndFeedbackText() {
    // todo Fix name!
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0.3, -0.5),
          child: Visibility(
            visible: gameController.gameMode.value == GameMode.running,
            child: ValueListenableBuilder(
              valueListenable: gameController.feedbackText,
              builder: (context, text, child) {
                return Text(
                  text,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTempoOnButton() {
    return Positioned(
      left: 30,
      bottom: 90,
      child: ToggleButton(
        text: "Show Beat",
        initialState: gameController.showTempo,
        onToggle: (newValue) {
          gameController.showTempo = newValue;
        },
      ),
    );
  }

  Widget _buildSettingsButton() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: NiceButton(
        text: "Clef Thresholds",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdvancedOptionsView(gameController.player),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoteSelectorButton() {
    return Positioned(
      bottom: 78,
      right: 30,
      child: NiceButton(
        text: "Note Selection",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteSelectorView(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBigJumpSwitch() {
    return Positioned(
      bottom: 190,
      right: 30,
      child: ToggleButton(
        text: "Big Jumps",
        initialState: gameController.bigJumpsMode,
        onToggle: (value) {
          gameController.bigJumpsMode = value;
        },
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

  Widget _buildTempoSelectorButton() {
    return Positioned(
      left: 30,
      bottom: 30,
      child: TempoSelector(onTempoChanged: (int newTempo) {}),
    );
  }

  Widget _buildSettingsButtons() {
    return Stack(
      children: [
        _buildBigJumpSwitch(),
        _buildClefSelectionButton(),
        _buildSettingsButton(),
        _buildNoteSelectorButton(),
        _buildTempoSelectorButton(),
        _buildTempoOnButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildGameScene(),
          _buildScoreText(),
          _buildGameText(),
          _buildTranspositionDropDown(),
          if (gameController.gameMode.value == GameMode.waitingToStart)
            _buildSettingsButtons(),
          _buildStartButton(),
          //_buildTickAndFeedbackText(),
          _buildBackButton(),
        ],
      ),
    );
  }
}
