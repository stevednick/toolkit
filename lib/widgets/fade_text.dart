import 'package:flutter/material.dart';

class FadeText extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle? style;

  const FadeText({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 500),
    this.style,
  });

  @override
  _FadeTextState createState() => _FadeTextState();
}

class _FadeTextState extends State<FadeText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  String _currentText = '';
  String _nextText = '';

  @override
  void initState() {
    super.initState();
    _currentText = widget.text;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _controller.addStatusListener(_updateText);
  }

  @override
  void didUpdateWidget(FadeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != _currentText && !_controller.isAnimating) {
      _nextText = widget.text;
      _controller.forward(from: 0.0);
    }
  }

  void _updateText(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _currentText = _nextText;
      });
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Text(
            _currentText,
            style: widget.style,
          ),
        );
      },
    );
  }
}

