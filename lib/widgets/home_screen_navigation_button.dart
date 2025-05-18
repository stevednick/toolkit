import 'package:flutter/material.dart';
import 'package:toolkit/widgets/nice_button.dart';

class HomeScreenNavigationButton extends StatelessWidget {
  final Widget route;
  final String text;
  const HomeScreenNavigationButton(
      {super.key, required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return NiceButton(
      text: text,
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => route,
          ),
        );
      },
    );
  }
}
