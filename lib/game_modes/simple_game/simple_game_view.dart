import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/home_screen/advanced_options_view.dart';
import 'package:toolkit/game_modes/home_screen/note_selector_view.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/game_modes/simple_game/load_and_save_view.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_controller.dart';
import 'package:toolkit/game_modes/simple_game/simple_game_scene.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/scenes/range_selection_scene.dart';
import 'package:toolkit/tools/scaled_positioned.dart';
import 'package:toolkit/tools/utils.dart';
import 'package:toolkit/widgets/key_signature_dropdown.dart';
import 'package:toolkit/widgets/widgets.dart';

class SimpleGameView extends StatefulWidget {
  const SimpleGameView({super.key});

  @override
  _SimpleGameViewState createState() => _SimpleGameViewState();
}

class _SimpleGameViewState extends State<SimpleGameView> {
  late final SimpleGameController gameController;
  late SimpleGameScene scene;
  late RangeSelectionScene rangeSelectionScene;
  late final EnhancedClefSelectionButton clefSelectionButton;

  ScaleManager scaleManager = ScaleManager();

  late double width;

  late GlobalKey<TranspositionDropDownState> _dropdownKey;
  late GlobalKey<KeySignatureDropdownState> _keyDropDownKey;
  final GlobalKey<EnhancedClefSelectionButtonState> _clefButtonKey =
      GlobalKey();
  late TempoSelector tempoSelector = TempoSelector(
    onTempoChanged: (int newTempo) {},
    keyString: 'simple_game_tempo',
  );
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

  GameOptions? gameOptions;

  bool showTick = false;

  //late double width;

  @override
  void initState() {
    super.initState();

    gameController = SimpleGameController(triggerTick);
    scene = SimpleGameScene(gameController);
    rangeSelectionScene = RangeSelectionScene(gameController.player);
    _dropdownKey = GlobalKey<TranspositionDropDownState>();
    _keyDropDownKey = GlobalKey<KeySignatureDropdownState>();
    clefSelectionButton =
        EnhancedClefSelectionButton(gameController.player, refreshScene);
    setClefThresholdsButton();
  }

  Future<void> setTempoSelector() async {
    tempoSelector.isActive.value = await Settings.getSetting(Settings.tempoKey);
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
      rangeSelectionScene.changeNote(true);
    });
  }

  void clefSelectionButtonPressed() {
    //refreshScene();
    rangeSelectionScene.changeNote(true);
    setClefThresholdsButton();
  }

  @override
  void dispose() {
    gameController.dispose();
    scene.onDispose();
    super.dispose();
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
                  _dropdownKey.currentState?.refresh();
                  _keyDropDownKey.currentState?.refresh();
                  _clefButtonKey.currentState?.setMode();
                  rangeSelectionScene = RangeSelectionScene(gameController.player);
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
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.33,
        child: GameWidget(
          game: gameController.gameMode.value != GameMode.waitingToStart
              ? scene
              : rangeSelectionScene,
        ),
      ),
    );
  }

  Widget _buildScoreText() {
    return ScaledPositioned(
      top: 40,
      right: 40,
      scaleFactor: scaleManager.scaleFactor(),
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
          return Transform.scale(
            scale: scaleManager.scaleFactor(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                text,
                style: const TextStyle(fontSize: 30),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTranspositionDropDown() {
    return ScaledPositioned(
      top: 40,
      left: 40,
      scaleFactor: scaleManager.scaleFactor(),
      child: gameController.gameMode.value == GameMode.waitingToStart
          ? TranspositionDropDown(
              key: _dropdownKey,
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

  Widget _buildKeySignatureDropdown() {
    return ScaledPositioned(
      top: 40,
      right: 40,
      scaleFactor: scaleManager.scaleFactor(),
      child: KeySignatureDropdown(
          key: _keyDropDownKey,
          player: gameController.player, onChanged: () { 
              setState(() {
                rangeSelectionScene = RangeSelectionScene(gameController.player);
              });
           },),
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
    return ValueListenableBuilder(
      valueListenable: gameController.noteChecker.noteNotifier,
      builder: (context, note, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Transform.scale(
            scale: scaleManager.scaleFactor(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NiceButton(
                  text: gameController.gameMode.value == GameMode.waitingToStart
                      ? "Start"
                      : "End",
                  onPressed: () {
                    setState(() {
                      scene.onDispose();
                      scene = SimpleGameScene(gameController);
                      gameController.startButtonPressed();
                      //setClefThresholdsButton();
                    });
                  },
                ),
                SizedBox(
                  height: 20 * scaleManager.scaleFactor(),  
                ),
              ],
            ),
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
        setTempoSelector();
        setState(() {
          //
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
          gameController.dispose();
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildTempoSelectorButton() {
    return tempoSelector;
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
        Transform.scale(
          scale: scaleManager.scaleFactor(),
          child: Padding(
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
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Transform.scale(
            scale: scaleManager.scaleFactor(),
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.sizeOf(context).width;
    rangeSelectionScene.width = width;
    scene.width = width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildGameScene(),
          _buildScoreText(),
          _buildGameText(),
          _buildTranspositionDropDown(),
          if (gameController.gameMode.value == GameMode.waitingToStart)
          _buildKeySignatureDropdown(),
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
