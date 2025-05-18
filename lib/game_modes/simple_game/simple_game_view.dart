import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/game_modes/home_screen/advanced_options_view.dart';
import 'package:toolkit/game_modes/home_screen/home_view.dart';
import 'package:toolkit/game_modes/home_screen/note_selector_view.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/game_modes/simple_game/game_over_popup.dart';
import 'package:toolkit/game_modes/simple_game/load_and_save_view.dart';
import 'package:toolkit/game_modes/simple_game/scoring/difficulty_manager.dart';
import 'package:toolkit/game_modes/simple_game/scoring/score_displayer.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_scene.dart';
import 'package:toolkit/game_modes/simple_game/state_management/score_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/state_management/single_game_high_scores_manager.dart';
import 'package:toolkit/game_modes/simple_game/state_management/timer_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/time_trial_intro_popup.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_key_signature_dropdown.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_main_text.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_score_text.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_timing_text.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_transposition_dropdown.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/scenes/range_selection/range_selection.dart';
import 'package:toolkit/widgets/widgets.dart';

class SimpleGameView extends ConsumerStatefulWidget {
  late bool isTimeTrialMode;
  SimpleGameView({super.key, required this.isTimeTrialMode});
  @override
  _SimpleGameViewState createState() => _SimpleGameViewState();
}

class _SimpleGameViewState extends ConsumerState<SimpleGameView> {
  //final ProviderContainer container = ProviderContainer();
  late final SimpleGameController gameController;
  late SimpleGameScene scene;
  late RangeSelectionScene rangeSelectionScene;

  late final EnhancedClefSelectionButton clefSelectionButton;

  late final DifficultyManager difficultyManager; // Does this need to be here?

  final GlobalKey<TimeTrialIntroPopupState> timeTrialPopupKey = GlobalKey();
  late final TimeTrialIntroPopup timeTrialIntroPopup;

  bool _hasGameOverBeenShown = false;

  late final TempoSelector tempoSelector;

  late final ProviderContainer container;

  late double width;

  final double screenWidthRatio = 0.33;
  double difficultyMultiplier = 1;

  final GlobalKey<EnhancedClefSelectionButtonState> _clefButtonKey =
      GlobalKey();

  late final NiceButton clefThresholdsButton = NiceButton(
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

  GameOptions? gameOptions; // Can this move?

  bool showTick = false;

  @override
  void initState() {
    super.initState();
    tempoSelector = TempoSelector(
      onTempoChanged: (int newTempo) {},
      keyString: 'simple_game_tempo',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // What about this?
      await Future.delayed(Duration(milliseconds: 10)); // Short delay
      ref
          .read(simpleGameStateProvider.notifier)
          .setIsTimeTrialMode(widget.isTimeTrialMode);
    });
    timeTrialIntroPopup = TimeTrialIntroPopup(
        key: timeTrialPopupKey); // Modify popup for Simple Game as well.
    gameController = SimpleGameController(triggerTick, ref);
    // or pass in manually

    //scene = SimpleGameScene(gameController, ref);
    rangeSelectionScene = RangeSelectionScene(gameController.player);
    clefSelectionButton =
        EnhancedClefSelectionButton(gameController.player, refreshScene);
    setTempoSelector();
    setClefThresholdsButton();
    difficultyManager = DifficultyManager(player: gameController.player);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    container = ProviderScope.containerOf(context);
    scene = SimpleGameScene(gameController, container);
  }

  Future<void> showGameOverDialog() async {
    final difficulty = await difficultyManager.calculateDifficulty();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GameOverPopup(
          notesPlayed: ref.read(simpleGameScoreProvider).score.toInt(),
          difficultyLevel: difficulty,
          onPlayAgain: () {
            Navigator.of(context).pop();
            restartGameFromGameOverScreen();
          },
          onExit: () {
            Navigator.of(context).pop();
            backToMenuFromGameOverScreen();
          },
        );
      },
    );
  }

  void restartGameFromGameOverScreen() {
    // Can these be tidied/simplified?
    setState(() {
      ref.read(simpleGameScoreProvider.notifier).reset();
      ref.read(simpleGameStateProvider.notifier).reset();
      _hasGameOverBeenShown = false;
      scene.onDispose();
      scene = SimpleGameScene(gameController, container);
      gameController.startButtonPressed();
    });
  }

  void backToMenuFromGameOverScreen() {
    setState(() {
      //gameController.startButtonPressed();
      ref.read(simpleGameScoreProvider.notifier).reset();
      ref.read(simpleGameStateProvider.notifier).reset();
      ref.read(timerStateProvider.notifier).resetTime();
      scene.onDispose();
      scene = SimpleGameScene(gameController, container);
    });
  }

  void endGame() {
    gameController.startButtonPressed();
    scene.onDispose();
    scene = SimpleGameScene(gameController, container);
  }

  Future<void> setTempoSelector() async {
    setState(
      () {
        tempoSelector.isActive.value = true;
      },
    );
  }

  Future<void> setClefThresholdsButton() async {
    await setTempoSelector();
    ClefSelection currentSelection = gameController.player.clefSelection;
    clefThresholdsButton.isActive.value = true;
    clefThresholdsButton.isActive.value = false;
    clefThresholdsButton.isActive.value =
        currentSelection.index == ClefSelection.trebleBass.index;
  }

  Future<void> fetchGameOptions() async {
    ClefSelection clefSelection =
        await gameController.player.getClefSelection();
    List<bool> noteActivations =
        NoteData.octave.map((note) => note.isActive).toList();
    await gameController.player.range.getValues();
    int kS = await gameController.player.loadKeySignatureInt();
    gameOptions = GameOptions(
      version: 1,
      t: gameController.player.range.top,
      b: gameController.player.range.bottom,
      tr: gameController.player.selectedInstrument.currentTransposition.name,
      tCT: gameController.player.clefThreshold.trebleClefThreshold,
      bCT: gameController.player.clefThreshold.bassClefThreshold,
      cS: ClefSelection.values.indexOf(clefSelection),
      nS: noteActivations,
      kS: kS,
    );
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
    setState(() {
      rangeSelectionScene.noteManager.changeNote(true);
    });
  }

  void clefSelectionButtonPressed() {
    rangeSelectionScene.noteManager.changeNote(true);
    setClefThresholdsButton();
  }

  @override
  void dispose() {
    gameController.dispose();
    scene.onDispose();
    super.dispose();
  }

  Future<void> _showResetHighScoreDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset High Score?'),
          content: const Text('This cannot be undone!'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                final SingleGameHighScoresManager highScoresManager =
                    SingleGameHighScoresManager();
                setState(() {
                  highScoresManager.resetScores();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHighScoreResetButton() {
    return NiceButton(
        onPressed: () async {
          await _showResetHighScoreDialog();
        },
        text: "Reset Score");
  }

  Widget _buildHighScoreText() {
    final ScoreDisplayer displayer = ScoreDisplayer();
    final SingleGameHighScoresManager highScoresManager =
        SingleGameHighScoresManager();

    return FutureBuilder(
      future: highScoresManager.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("High Score: Loading...");
        }
        return Text(
          "High ${displayer.displayScore(highScoresManager.bestScore)}",
          style: TextStyle(fontSize: 16),
        );
      },
    );
  }

  Widget _buildLoadSaveButton() {
    return NiceButton(
      onPressed: () async {
        await fetchGameOptions();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoadAndSaveView(
              gameOptions: gameOptions!,
              player: gameController.player,
              refreshScene: () {
                setState(() {
                  _clefButtonKey.currentState?.setMode();
                  rangeSelectionScene =
                      RangeSelectionScene(gameController.player);
                });
              },
            ),
          ),
        );
      },
      text: "Load or Share",
    );
  }

  Widget _buildGameScene() {
    final gameMode = ref
        .watch(simpleGameStateProvider)
        .gameMode; // Get the gameMode from the provider
    return Center(
      child: FractionallySizedBox(
        widthFactor: screenWidthRatio,
        child: GameWidget(
          game:
              gameMode != GameMode.waitingToStart ? scene : rangeSelectionScene,
        ),
      ),
    );
  }

  Widget _buildClefSelectionButton() {
    return EnhancedClefSelectionButton(
      key: _clefButtonKey,
      gameController.player,
      clefSelectionButtonPressed,
    );
  }

  Widget _buildStartButton() {
    final gameMode = ref.watch(simpleGameStateProvider).gameMode;
    return ValueListenableBuilder(
      valueListenable: gameController.noteChecker.noteNotifier,
      builder: (context, note, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NiceButton(
                text: gameMode == GameMode.waitingToStart ? "Start" : "End",
                onPressed: () async {
                  difficultyMultiplier =
                      await difficultyManager.calculateDifficulty();
                  setState(() {
                    _hasGameOverBeenShown = false;
                    endGame();
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
      getInitialState: () {
        return Settings.getSetting(Settings.tempoKey);
      },
      onToggle: (newValue) async {
        //todo add rebuold code when ready...
        await Settings.saveSetting(Settings.tempoKey, newValue);
        setState(() {
          setTempoSelector();
        });
      },
      text: "Show Beat",
    );
  }

  Widget _buildSettingsButton() {
    return clefThresholdsButton;
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
          ref.read(simpleGameStateProvider.notifier).reset();
          gameController.dispose();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTempoSelectorButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: tempoSelector.isActive,
      builder: (context, isActive, child) {
        return TempoSelector(
          onTempoChanged: (int newTempo) {},
          keyString: 'simple_game_tempo',
        );
      },
    );
  }

  Widget _buildGhostNoteButton() {
    return FutureBuilderToggle(
      getInitialState: () {
        return Settings.getSetting(Settings.ghostNoteString);
      },
      onToggle: (newValue) async {
        await Settings.saveSetting(Settings.ghostNoteString, newValue);
      },
      text: 'Ghost Notes',
    );
  }

  Widget _buildInfoButton() {
    return Positioned(
      bottom: 3,
      right: 170,
      child: IconButton(
          onPressed: () async {
            setState(() {
              timeTrialPopupKey.currentState?.openPopup();
            });
          },
          icon: const Icon(Icons.help_outline)),
    );
  }

  Widget _buildSettingsButtons() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(45, 10, 45, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (ref.watch(simpleGameStateProvider).isTimeTrialMode) ...[
                _buildHighScoreText(),
                const SizedBox(
                  height: 5,
                ),
                _buildHighScoreResetButton(),
                const SizedBox(
                  height: 5,
                ),
              ],
              _buildBigJumpSwitch(),
              const SizedBox(
                height: 5,
              ),
              _buildGhostNoteButton(),
              const SizedBox(
                height: 5,
              ),
              if (!ref.watch(simpleGameStateProvider).isTimeTrialMode) ...[
                _buildTempoOnButton(),
                const SizedBox(
                  height: 5,
                ),
                _buildTempoSelectorButton(),
              ]
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(45, 10, 45, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildLoadSaveButton(),
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
    //gameController.setRef(ref);
    final gameMode = ref.watch(simpleGameStateProvider).gameMode;

    if (gameMode == GameMode.finished && !_hasGameOverBeenShown) {
      _hasGameOverBeenShown = true;
      Future.delayed(Duration.zero, () {
        showGameOverDialog();
      });
    }

    width = MediaQuery.sizeOf(context).width;
    rangeSelectionScene.setWidth(width * screenWidthRatio);
    scene.width = width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildGameScene(),
          SimpleGameTimingText(),
          SimpleGameScoreText(
            difficultyMultiplier: difficultyMultiplier,
          ),
          SimpleGameMainText(),
          SimpleGameTranspositionDropdown(player: gameController.player),
          if (gameMode == GameMode.waitingToStart)
            SimpleGameKeySignatureDropdown(
                player: gameController.player,
                onChanged: () {
                  setState(() {
                    rangeSelectionScene =
                        RangeSelectionScene(gameController.player);
                  });
                }),
          if (gameMode == GameMode.waitingToStart) _buildSettingsButtons(),
          _buildStartButton(),
          //_buildTickAndFeedbackText(),
          _buildBackButton(),
          if (ref.watch(simpleGameStateProvider).isTimeTrialMode)
            timeTrialIntroPopup,
          if (ref.watch(simpleGameStateProvider).isTimeTrialMode)
            _buildInfoButton(),
        ],
      ),
    );
  }
}
