import 'package:flutter/material.dart';
import 'package:mapmotion_flutter/core/constants/colors.dart';

class CenterButton extends StatelessWidget {
  const CenterButton({Key? key, required this.onPressed, required this.visible}) : super(key: key);

  final VoidCallback onPressed;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: OutlinedButton(
          onPressed: onPressed,
          child: const Text('Reset'),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(white),
          ),
        ),
      ),
    );
  }
}
