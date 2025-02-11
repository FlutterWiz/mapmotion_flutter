import 'package:flutter/material.dart';

class LocationPermissionDeniedView extends StatelessWidget {
  const LocationPermissionDeniedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Location not available.\nPlease check your permissions or try again later.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
