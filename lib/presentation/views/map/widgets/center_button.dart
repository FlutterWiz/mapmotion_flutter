import 'package:flutter/material.dart';
import 'package:mapmotion_flutter/core/constants/colors.dart';

class CenterButton extends StatelessWidget {
  const CenterButton({Key? key, required this.onPressed, required this.text}) : super(key: key);

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(white),
        ),
      ),
    );
  }
}
