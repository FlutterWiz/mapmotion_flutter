import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomMarker extends StatelessWidget {
  final AnimationController lottieController;
  const CustomMarker({Key? key, required this.lottieController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: Lottie.asset(
        'assets/location.json',
        controller: lottieController,
        onLoaded: (composition) {
          // Set the duration for the Lottie controller from the composition.
          lottieController.duration = composition.duration;
        },
      ),
    );
  }
}
