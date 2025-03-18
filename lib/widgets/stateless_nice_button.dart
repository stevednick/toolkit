import 'package:flutter/material.dart';

class StatelessNiceButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final ValueNotifier<bool> isActive = ValueNotifier(true);

  StatelessNiceButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isActive,
      builder: (context, isEnabled, child) {
        return GestureDetector(
          onTap: () {
            if (isEnabled) {
              onPressed();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 120,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isEnabled ? const Color.fromRGBO(0, 95, 255, 0.6) : Colors.grey[200],
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
                  text, // This will now update whenever the parent rebuilds!
                  style: TextStyle(
                    color: isEnabled ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
