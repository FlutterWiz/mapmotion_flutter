import 'package:flutter/material.dart';
import 'package:mapmotion_flutter/core/constants/colors.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({Key? key, required this.animation}) : super(key: key);

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: animation.value,
            height: animation.value,
            decoration: const BoxDecoration(color: red, shape: BoxShape.circle),
            child: Icon(Icons.person, size: animation.value * 0.7),
          ),
        );
      },
    );
  }
}
