import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final bool initialState;
  final Function(bool) onToggle;
  final String text;

  const ToggleButton({
    super.key,
    this.initialState = false,
    required this.onToggle, 
    required this.text,
  });

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialState;
  }

  void _handleToggle() {
    setState(() {
      _isEnabled = !_isEnabled;
    });
    widget.onToggle(_isEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 120,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: _isEnabled ? Colors.green : Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: _isEnabled ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}