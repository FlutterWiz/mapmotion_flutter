import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmotion_flutter/core/config/app_config.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_state.dart';
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

  /// Controls whether the simulation is active (i.e. auto-follow is enabled).
  bool _simulationActive = false;

  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      cancelPreviousAnimations: true,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 30, end: 45).animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stadiaApiKey = AppConfig.apiKey;
    return Scaffold(
      appBar: AppBar(title: const Text('MapMotion Flutter')),
      body: BlocListener<LocationCubit, LocationState>(
        listener: (context, state) {
          // When simulation is active and we have a new location, animate the camera.
          if (_simulationActive && state.userLocation != null) {
            final newLatLng = LatLng(
              state.userLocation!.latitude,
              state.userLocation!.longitude,
            );
            _animatedMapController.animateTo(dest: newLatLng, zoom: 3);
          }
        },
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state.userLocation == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final userLocation = LatLng(state.userLocation!.latitude, state.userLocation!.longitude);

              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  FlutterMap(
                    mapController: _animatedMapController.mapController,
                    options: MapOptions(
                      initialCenter: userLocation,
                      initialZoom: 3,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                      ),
                      cameraConstraint: CameraConstraint.contain(
                        bounds: LatLngBounds(const LatLng(-90, -180), const LatLng(90, 180)),
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}@2x.png?api_key=$stadiaApiKey',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: userLocation,
                            width: 60,
                            height: 60,
                            child: CustomMarker(animation: _animation),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CenterButton(
                    text: _simulationActive ? 'Stop' : 'Start',
                    onPressed: () {
                      setState(() {
                        _simulationActive = !_simulationActive;
                      });

                      if (_simulationActive) {
                        context.read<LocationCubit>().startSimulation();
                      } else {
                        context.read<LocationCubit>().stopSimulation();
                        _animatedMapController.animateTo(dest: const LatLng(38.423734, 27.142826), zoom: 3);
                      }
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
