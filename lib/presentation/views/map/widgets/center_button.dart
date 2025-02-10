import 'package:flutter/material.dart';
import 'package:mapmotion_flutter/core/constants/colors.dart';

class CenterButton extends StatelessWidget {
  const CenterButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: OutlinedButton(
        onPressed: onPressed,
        child: const Text('Center'),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(white),
        ),
      ),
    );
  }
}
