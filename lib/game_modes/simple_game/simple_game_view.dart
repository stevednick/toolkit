import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/home_screen/advanced_options_view.dart';
import 'package:toolkit/game_modes/home_screen/note_selector_view.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_scene.dart';
import 'package:toolkit/models/game_mode.dart';
import 'package:toolkit/scenes/range_selection_scene.dart';
import 'package:toolkit/widgets/future_builder_toggle.dart';
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
  late final SimpleGameScene scene;

  bool showTick = false;

  @override
  void initState() {
    super.initState();
    gameController = SimpleGameController(triggerTick);
    scene = SimpleGameScene(gameController);
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
    scene.onDispose();
    super.dispose();
  }

  Widget _buildGameScene() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 500,
        child: GameWidget(
          game: gameController.gameMode.value != GameMode.waitingToStart
              ? scene
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
    return EnhancedClefSelectionButton(gameController.player, refreshScene);
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
              NiceButton(
                text: gameController.gameMode.value == GameMode.waitingToStart
                    ? "Start"
                    : "End",
                onPressed: () {
                  setState(() {
                    gameController.startButtonPressed();
                  });
                },
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

  Widget _buildTempoOnButton() {
    return FutureBuilderToggle(
      getInitialState: scene.getTempoOn,
      onToggle: (newValue) async {
        scene.showBall = newValue;
        scene.setTempoOn();
        scene.rebuildQueued = true;
        // If you need to persist this change, you might want to call a method here
        // await scene.saveGhostNotesState(newValue);
      },
      text: "Show Beat",
    );
  }

  Widget _buildSettingsButton() {
    return NiceButton(
      text: "Clef Thresholds",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvancedOptionsView(gameController.player),
          ),
        );
      },
    );
  }

  Widget _buildNoteSelectorButton() {
    return NiceButton(
      text: "Note Selection",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NoteSelectorView(),
          ),
        );
      },
    );
  }

  Widget _buildBigJumpSwitch() {
    return ToggleButton(
      text: "Big Jumps",
      initialState: gameController.bigJumpsMode,
      onToggle: (value) {
        gameController.bigJumpsMode = value;
      },
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
    return TempoSelector(
      onTempoChanged: (int newTempo) {},
      keyString: 'simple_game_tempo',
    );
  }

  Widget _buildGhostNoteButton() {
    return FutureBuilderToggle(
      getInitialState: scene.getGhostNotesOn,
      onToggle: (newValue) async {
        scene.showGhostNotes = newValue;
        scene.setGhostNotesOn();
        scene.rebuildQueued = true;
      },
      text: 'Ghost Notes',
    );
  }

  Widget _buildSettingsButtons() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildGhostNoteButton(),
              const SizedBox(
                height: 5,
              ),
              _buildTempoOnButton(),
              const SizedBox(
                height: 5,
              ),
              _buildTempoSelectorButton(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildBigJumpSwitch(),
                const SizedBox(
                  height: 5,
                ),
                _buildClefSelectionButton(),
                const SizedBox(
                  height: 5,
                ),
                _buildSettingsButton(),
                const SizedBox(
                  height: 5,
                ),
                _buildNoteSelectorButton(),
              ],
            ),
          ),
        ),
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
