import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmotion_flutter/core/config/app_config.dart';
import 'package:mapmotion_flutter/core/constants/colors.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/center_button.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/custom_marker.dart';

class MapViewBody extends StatelessWidget {
  const MapViewBody({
    Key? key,
    required this.markerPosition,
    required this.simulationActive,
    required this.onPressedCenterButton,
    required this.initialPoint,
    required this.markerAnimation,
    required this.mapController,
  }) : super(key: key);

  final LatLng markerPosition;
  final LatLng initialPoint;

  final Animation<double> markerAnimation;
  final bool simulationActive;
  final VoidCallback onPressedCenterButton;
  final MapController mapController;

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
            interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
            cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(const LatLng(-90, -180), const LatLng(90, 180)),
            ),
          ),
          children: [
            TileLayer(urlTemplate: urlTemplate),
            MarkerLayer(
              markers: [
                Marker(
                  point: simulationActive ? markerPosition : initialPoint,
                  width: 60,
                  height: 60,
                  child: CustomMarker(animation: markerAnimation),
                ),
              ],
            ),
            PolygonLayer(
              polygons: [
                Polygon(
                  points: [
                    const LatLng(38.543734, 27.222826), // Top-left
                    const LatLng(38.543734, 27.262826), // Top-right
                    const LatLng(38.503734, 27.262826), // Bottom-right
                    const LatLng(38.503734, 27.222826), // Bottom-left
                  ],
                  color: transparent,
                  borderColor: red,
                  borderStrokeWidth: 10,
                ),
              ],
            ),
          ],
        ),
        CenterButton(
          text: simulationActive ? 'Stop' : 'Start',
          onPressed: onPressedCenterButton,
        ),
      ],
    );
  }
}
