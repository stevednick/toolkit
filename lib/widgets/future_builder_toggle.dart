import 'package:flutter/material.dart';
import 'package:toolkit/widgets/toggle_button.dart';

class FutureBuilderToggle extends StatefulWidget {
  final Future<bool> Function() getInitialState;
  final Function(bool) onToggle;
  final String text;

  const FutureBuilderToggle({
    super.key,
    required this.getInitialState,
    required this.onToggle,
    required this.text,
  });

  @override
  _FutureBuilderToggleState createState() => _FutureBuilderToggleState();
}

class _FutureBuilderToggleState extends State<FutureBuilderToggle> {
  bool? _currentState;

  @override
  void initState() {
    super.initState();
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final initialState = await widget.getInitialState();
    setState(() {
      _currentState = initialState;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentState == null) {
      return const CircularProgressIndicator();
    }
    return ToggleButton(
      onToggle: widget.onToggle,
      initialState: _currentState!,
      text: widget.text,
    );
  }
}
