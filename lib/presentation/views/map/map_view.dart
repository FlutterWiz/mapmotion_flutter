import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmotion_flutter/core/config/app_config.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/center_button.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/custom_marker.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final stadiaApiKey = AppConfig.apiKey;

    return Scaffold(
      appBar: AppBar(title: const Text('MapMotion Flutter')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(51.509364, -0.128928),
              initialZoom: 9.2,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(const LatLng(-90, -180), const LatLng(90, 180)),
              ),
            ),
            children: [
              TileLayer(
                // Bring your own tiles
                urlTemplate: 'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}@2x.png?api_key=$stadiaApiKey',
                userAgentPackageName: 'com.example.app', // Add your app identifier
                // And many more recommended properties!
              ),
              const MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(51.509364, -0.128928),
                    width: 50,
                    height: 50,
                    child: CustomMarker(),
                  ),
                ],
              ),
            ],
          ),
          CenterButton(
            onPressed: () {
              _mapController.move(const LatLng(51.509364, -0.128928), 9.2);
            },
          ),
        ],
      ),
    );
  }
}
