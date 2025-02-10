import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmotion_flutter/core/config/app_config.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/center_button.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/custom_marker.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  late final AnimatedMapController _animatedMapController;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void dispose() {
    _animatedMapController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animatedMapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      cancelPreviousAnimations: true,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 30, end: 45).animate(_animationController);

    _animationController.repeat(reverse: true); // animate in loop

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stadiaApiKey = AppConfig.apiKey;

    return Scaffold(
      appBar: AppBar(title: const Text('MapMotion Flutter')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FlutterMap(
            mapController: _animatedMapController.mapController,
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
                urlTemplate: 'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}@2x.png?api_key=$stadiaApiKey',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(51.509364, -0.128928),
                    width: 60,
                    height: 60,
                    child: CustomMarker(animation: _animation),
                  ),
                ],
              ),
            ],
          ),
          CenterButton(
            onPressed: () {
              _animatedMapController.animateTo(
                dest: const LatLng(51.509364, -0.128928),
                zoom: 9.2,
              );
            },
          ),
        ],
      ),
    );
  }
}
