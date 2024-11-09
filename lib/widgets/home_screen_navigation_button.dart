import 'package:flutter/material.dart';

class HomeScreenNavigationButton extends StatelessWidget {
  final Widget route;
  final String text;
  const HomeScreenNavigationButton(
      {super.key, required this.route, required this.text});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => route,
          ),
        );
      },
      child: Text(text),
    );
  }
}
