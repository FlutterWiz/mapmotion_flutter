import 'package:flutter/material.dart';
import 'package:mapmotion_flutter/core/constants/colors.dart';

class CustomMarker extends StatelessWidget {
  const CustomMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(color: red, shape: BoxShape.circle),
      child: const Icon(Icons.person),
    );
  }
}
