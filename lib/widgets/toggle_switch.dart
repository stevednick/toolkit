import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onToggle;
  final String label;

  const ToggleSwitch({
    super.key,
    required this.initialValue,
    required this.onToggle,
    required this.label,
  });

  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> with SingleTickerProviderStateMixin {
  late bool _isOn;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  late Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _isOn = widget.initialValue;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _colorAnimation = ColorTween(
      begin: Colors.grey[300],
      end: Colors.green,
    ).animate(_animationController);
    _alignmentAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    if (_isOn) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSwitch() {
    setState(() {
      _isOn = !_isOn;
      if (_isOn) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      widget.onToggle(_isOn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleSwitch,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 20),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                width: 50.0,
                height: 30.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: _colorAnimation.value,
                ),
                child: Align(
                  alignment: _alignmentAnimation.value,
                  child: Container(
                    width: 26.0,
                    height: 26.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}