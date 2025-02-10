import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmotion_flutter/core/config/app_config.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/custom_marker.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/center_button.dart';

class MapViewBody extends StatelessWidget {
  final MapController mapController;
  final LatLng markerPosition;
  final bool simulationActive;
  final LatLng initialPoint;
  final String buttonText;
  final VoidCallback onPressedCenterButton;
  final CustomMarker customMarker;

  const MapViewBody({
    Key? key,
    required this.mapController,
    required this.markerPosition,
    required this.simulationActive,
    required this.initialPoint,
    required this.buttonText,
    required this.onPressedCenterButton,
    required this.customMarker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stadiaApiKey = AppConfig.apiKey;
    final urlTemplate = 'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}@2x.png?api_key=$stadiaApiKey';

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: markerPosition,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(
                const LatLng(-90, -180),
                const LatLng(90, 180),
              ),
            ),
          ),
          children: [
            TileLayer(urlTemplate: urlTemplate),
            // Draw target polygon (square) with transparent fill and blue border.
            PolygonLayer(
              polygons: [
                Polygon(
                  points: const [
                    LatLng(38.543734, 27.222826),
                    LatLng(38.543734, 27.262826),
                    LatLng(38.503734, 27.262826),
                    LatLng(38.503734, 27.222826),
                  ],
                  color: Colors.transparent,
                  borderColor: Colors.blue,
                  borderStrokeWidth: 2.0,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: markerPosition,
                  width: 60,
                  height: 60,
                  child: customMarker,
                ),
              ],
            ),
          ],
        ),
        CenterButton(
          text: buttonText,
          onPressed: onPressedCenterButton,
        ),
      ],
    );
  }
}
