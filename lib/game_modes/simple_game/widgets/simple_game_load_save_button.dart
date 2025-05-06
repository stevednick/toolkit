import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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