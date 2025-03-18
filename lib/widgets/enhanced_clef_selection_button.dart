import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toolkit/models/clef_selection.dart';
import 'package:toolkit/models/player/player.dart';

class EnhancedClefSelectionButton extends StatefulWidget {
  final Player player;
  final void Function() refreshScene;

  const EnhancedClefSelectionButton(this.player, this.refreshScene, {super.key});

  @override
  State<EnhancedClefSelectionButton> createState() => EnhancedClefSelectionButtonState();
}

class EnhancedClefSelectionButtonState extends State<EnhancedClefSelectionButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int mode = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _initializeMode();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeMode() async {
    ClefSelection selection = await widget.player.getClefSelection();
    setState(() {
      mode = (ClefSelection.values.indexOf(selection) + 2) % 3;
    });
    _animationController.value = mode / 2;
  }

  Future<void> setMode() async {
    print("Set Mode Called");
    await _initializeMode();
    _animationController.animateTo(mode / 2);
  }

  void _toggleSelection() {
    setState(() {
      mode = (mode + 1) % 3;
      widget.player.clefSelection = ClefSelection.values[(mode + 1) % 3];
      widget.player.saveInstrumentAndTransposition(
        widget.player.selectedInstrument.currentTransposition,
      );
      widget.refreshScene();
    });
    _animationController.animateTo(mode / 2);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSelection,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  left: _animation.value * 75 + 3,
                  top: 7,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/images/treble.png',
                    width: 22,
                    height: 30,
                    color: mode == 0 ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(width:2,),
                  Image.asset(
                    'assets/images/bass.png',
                    width: 13,
                    height: 21,
                    color: mode == 1 ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(width: 0,),
                  Text(
                    'Both',
                    style: TextStyle(
                      color: mode == 2 ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}