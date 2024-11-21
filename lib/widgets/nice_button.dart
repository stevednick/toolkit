import 'package:flutter/material.dart';

class NiceButton extends StatefulWidget {
  final Function() onPressed;
  final String text;

  const NiceButton({
    super.key,
    required this.onPressed, required this.text,
  });

  @override
  _NiceButtonState createState() => _NiceButtonState();
}

class _NiceButtonState extends State<NiceButton> {
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = true;
  }

  // void _handleToggle() {
  //   setState(() {
  //     _isEnabled = !_isEnabled;
  //   });
  //   widget.onToggle(_isEnabled);
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 120,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21),
          color: _isEnabled ? Colors.blue[300] : Colors.grey[200],
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