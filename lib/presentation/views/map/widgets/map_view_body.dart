import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmotion_flutter/core/config/app_config.dart';
import 'package:mapmotion_flutter/core/constants/colors.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/custom_marker.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/center_button.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

class MapViewBody extends StatelessWidget {
  final MapController mapController;
  final LatLng markerPosition;
  final LatLng initialPoint;
  final bool visible;
  final VoidCallback onPressedCenterButton;
  final Function(LatLng tappedPoint) onTapCallback;
  final CustomMarker customMarker;
  final List<LatLng> polylinePoints;

  const MapViewBody({
    Key? key,
    required this.mapController,
    required this.markerPosition,
    required this.initialPoint,
    required this.visible,
    required this.onPressedCenterButton,
    required this.onTapCallback,
    required this.customMarker,
    required this.polylinePoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stadiaApiKey = AppConfig.apiKey;
    final urlTemplate = 'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}@2x.png?api_key=$stadiaApiKey';

    final points = const [
      LatLng(38.543734, 27.222826),
      LatLng(38.543734, 27.262826),
      LatLng(38.503734, 27.262826),
      LatLng(38.503734, 27.222826),
    ];
    final bounds = LatLngBounds(
      const LatLng(-90, -180),
      const LatLng(90, 180),
    );
    final controlPoints = [
      ControlPoint(position: 0.5, type: ControlPointType.visible),
      ControlPoint(position: 1, type: ControlPointType.transparent),
    ];

    return SoftEdgeBlur(
      edges: [
        EdgeBlur(type: EdgeType.topEdge, size: 200, sigma: 5, controlPoints: controlPoints),
      ],
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: markerPosition,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
              cameraConstraint: CameraConstraint.contain(bounds: bounds),
              onTap: (tapPosition, point) => onTapCallback(point),
            ),
            children: [
              TileLayer(urlTemplate: urlTemplate),
              // Draw the polyline behind the marker:
              PolylineLayer(
                polylines: [
                  Polyline(points: polylinePoints, strokeWidth: 4, color: indigo),
                ],
              ),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: points,
                    color: transparent,
                    borderColor: red,
                    borderStrokeWidth: 4,
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
          ResetButton(visible: visible, onPressed: onPressedCenterButton),
        ],
      ),
    );
  }
}
