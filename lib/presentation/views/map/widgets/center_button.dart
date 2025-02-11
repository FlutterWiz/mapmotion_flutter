import 'package:flutter/material.dart';
import 'package:mapmotion_flutter/core/constants/colors.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({Key? key, required this.onPressed, required this.visible}) : super(key: key);

  final VoidCallback onPressed;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Visibility(
      visible: visible,
      child: Container(
        padding: const EdgeInsets.all(36),
        width: size.width,
        child: OutlinedButton(
          onPressed: onPressed,
          child: const Text(
            'Reset',
            style: TextStyle(color: white, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(black),
            overlayColor: WidgetStateProperty.all(indigo),
          ),
        ),
      ),
    );
  }
}
