import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomMarker extends StatelessWidget {
  final AnimationController lottieController;
  const CustomMarker({Key? key, required this.lottieController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/car.json',
      width: 250,
      height: 250,
      controller: lottieController,
      onLoaded: (composition) {
        // Set the duration for the Lottie controller from the composition.
        lottieController.duration = composition.duration;
      },
    );
  }
}
