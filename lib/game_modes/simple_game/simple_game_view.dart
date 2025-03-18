import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/game_modes/home_screen/advanced_options_view.dart';
import 'package:toolkit/game_modes/home_screen/note_selector_view.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/game_modes/simple_game/load_and_save_view.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_scene.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state_manager.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_key_signature_dropdown.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_main_text.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_score_text.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_timing_text.dart';
import 'package:toolkit/game_modes/simple_game/widgets/simple_game_transposition_dropdown.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/scenes/range_selection/range_selection.dart';
import 'package:toolkit/widgets/key_signature_dropdown.dart';
import 'package:toolkit/widgets/widgets.dart';

class SimpleGameView extends ConsumerStatefulWidget {
  late bool isTimeTrialMode;
  SimpleGameView({super.key, required this.isTimeTrialMode});
  @override
  _SimpleGameViewState createState() => _SimpleGameViewState();
}

class _SimpleGameViewState extends ConsumerState<SimpleGameView> {
  final ProviderContainer container = ProviderContainer();
  late final SimpleGameController gameController;
  late SimpleGameScene scene;
  late RangeSelectionScene rangeSelectionScene;
  late final EnhancedClefSelectionButton clefSelectionButton;

  late final TempoSelector tempoSelector;

  late double width;

  final double screenWidthRatio = 0.33;

  // late GlobalKey<TranspositionDropDownState> _dropdownKey;
  // late GlobalKey<KeySignatureDropdownState> _keyDropDownKey;
  final GlobalKey<EnhancedClefSelectionButtonState> _clefButtonKey =
      GlobalKey();
  late final NiceButton clefThresholdsButton = NiceButton(
    text: "Clef Thresholds",
    onPressed: () {
      final provider = ref.watch(simpleGameStateProvider);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvancedOptionsView(gameController.player),
        ),
      );
    },
  );

  GameOptions? gameOptions;

  bool showTick = false;

  @override
  void initState() {
    super.initState();
    tempoSelector = TempoSelector(
      onTempoChanged: (int newTempo) {},
      keyString: 'simple_game_tempo',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 10)); // Short delay
      ref
          .read(simpleGameStateProvider.notifier)
          .setIsTimeTrialMode(widget.isTimeTrialMode);
    });
    gameController = SimpleGameController(triggerTick, ref);
    scene = SimpleGameScene(gameController, ref);
    rangeSelectionScene = RangeSelectionScene(gameController.player);
    // _dropdownKey = GlobalKey<TranspositionDropDownState>();
    // _keyDropDownKey = GlobalKey<KeySignatureDropdownState>();
    clefSelectionButton =
        EnhancedClefSelectionButton(gameController.player, refreshScene);
    setTempoSelector();
    setClefThresholdsButton();
  }

  Future<void> setTempoSelector() async {
    tempoSelector.isActive.value = true; // Temp fix to just leave it on..
    // tempoSelector.isActive.value = await Settings.getSetting(Settings.tempoKey);
    // print("Tempo Selector is active: ${tempoSelector.isActive.value}");
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
    final provider = ref.watch(simpleGameStateProvider);
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
    //refreshScene();
    rangeSelectionScene.noteManager.changeNote(true);
    setClefThresholdsButton();
  }

  @override
  void dispose() {
    gameController.dispose();
    scene.onDispose();
    super.dispose();
  }

  Widget _buildLoadSaveButton() {
    final provider = ref.watch(simpleGameStateProvider);
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
                  // _dropdownKey.currentState?.refresh();
                  // _keyDropDownKey.currentState?.refresh();
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
    final provider = ref.watch(simpleGameStateProvider);
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
                onPressed: () {
                  setState(() {
                    scene.onDispose();
                    scene = SimpleGameScene(gameController, ref);
                    gameController.startButtonPressed();
                    //setClefThresholdsButton();
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
        // If you need to persist this change, you might want to call a method here
        // await scene.saveGhostNotesState(newValue);
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
          Navigator.pop(context);
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
    // Todo, add rebuild code when ready...
    return FutureBuilderToggle(
      getInitialState: () {
        return Settings.getSetting(Settings.ghostNoteString);
      },
      onToggle: (newValue) async {
        await Settings.saveSetting(Settings.ghostNoteString, newValue);
        // scene.onDispose();
        // scene = SimpleGameScene(gameController);
        //scene.showGhostNotes = newValue;
        //await scene.setSettings();
        //scene.rebuildQueued = true;
      },
      text: 'Ghost Notes',
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
              _buildBigJumpSwitch(),
              const SizedBox(
                height: 5,
              ),
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
    final gameMode = ref.watch(simpleGameStateProvider).gameMode;
    width = MediaQuery.sizeOf(context).width; // todo add width back...
    rangeSelectionScene.setWidth(width * screenWidthRatio);
    scene.width = width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildGameScene(),
          SimpleGameTimingText(),
          SimpleGameScoreText(),
          SimpleGameMainText(),
          SimpleGameTranspositionDropdown(player: gameController.player),
          if (gameMode == GameMode.waitingToStart) SimpleGameKeySignatureDropdown(player: gameController.player, onChanged: (){
            setState(() {
               rangeSelectionScene = RangeSelectionScene(gameController.player);
            });
          }),
          if (gameMode == GameMode.waitingToStart) _buildSettingsButtons(),
          _buildStartButton(),
          //_buildTickAndFeedbackText(),
          _buildBackButton(),
        ],
      ),
    );
  }
}
