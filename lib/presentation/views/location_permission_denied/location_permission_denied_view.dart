import 'package:flutter/material.dart';
import 'package:mapmotion_flutter/core/constants/colors.dart';

class LocationPermissionDeniedView extends StatelessWidget {
  const LocationPermissionDeniedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationDeniedText = 'Location not available.\nPlease check your permissions or try again later.';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 48, color: red),
            const SizedBox(height: 16),
            Text(
              locationDeniedText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
