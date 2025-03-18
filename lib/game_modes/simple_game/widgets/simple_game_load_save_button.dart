import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/game_modes/simple_game/load_and_save_view.dart';
import 'package:toolkit/game_modes/simple_game/state_management/simple_game_state_manager.dart';
import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/widgets/nice_button.dart';

class SimpleGameLoadSaveButton  extends ConsumerWidget{

  dynamic Function() onPressed;
  
  SimpleGameLoadSaveButton({super.key,required this.onPressed});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NiceButton(
      onPressed: onPressed,
      text: "Load or Share",
    );
  }
}