import 'package:flutter/material.dart';

class NiceButton extends StatefulWidget {
  final Function() onPressed;
  final String text;
  ValueNotifier<bool> isActive = ValueNotifier(true);

  NiceButton({
    super.key,
    required this.onPressed, required this.text,
  });

  @override
  _NiceButtonState createState() => _NiceButtonState();
}

class _NiceButtonState extends State<NiceButton> {
  late bool _isEnabled = true;

  @override
  void initState() {
    widget.isActive.addListener((){
      print(widget.isActive.value);
      _updateButtonState();
    });
  
    super.initState();
  }

  void _updateButtonState() {
    if (mounted) {
      setState(() {
        _isEnabled = widget.isActive.value;
      });
    }
  }

    @override
  void dispose() {
    widget.isActive.removeListener(_updateButtonState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){if (_isEnabled) widget.onPressed();},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 120,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: _isEnabled ? const Color.fromRGBO(0, 95, 255, 0.6): Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
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
      ),
    );
  }
}