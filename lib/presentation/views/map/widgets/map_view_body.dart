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

  const MapViewBody({
    Key? key,
    required this.mapController,
    required this.markerPosition,
    required this.initialPoint,
    required this.visible,
    required this.onPressedCenterButton,
    required this.onTapCallback,
    required this.customMarker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stadiaApiKey = AppConfig.apiKey;
    final urlTemplate = 'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}@2x.png?api_key=$stadiaApiKey';

    return SoftEdgeBlur(
      edges: [
        EdgeBlur(
          type: EdgeType.topEdge,
          size: 200,
          sigma: 5,
          controlPoints: [
            ControlPoint(
              position: 0.5,
              type: ControlPointType.visible,
            ),
            ControlPoint(
              position: 1,
              type: ControlPointType.transparent,
            ),
          ],
        ),
      ],
      child: Stack(
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
              onTap: (tapPosition, point) => onTapCallback(point),
            ),
            children: [
              TileLayer(urlTemplate: urlTemplate),
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: const [
                      LatLng(38.543734, 27.222826),
                      LatLng(38.543734, 27.262826),
                      LatLng(38.503734, 27.262826),
                      LatLng(38.503734, 27.222826),
                    ],
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
          ResetButton(
            visible: visible,
            onPressed: onPressedCenterButton,
          ),
        ],
      ),
    );
  }
}
