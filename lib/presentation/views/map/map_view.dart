import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_state.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/latlng_tween.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/map_view_body.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  // Controllers
  late final AnimatedMapController _mapController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _movementController;

  // Tween and animated marker position.
  LatLngTween? _positionTween;
  LatLng? _animatedPosition;

  // Simulation flag and initial point.
  bool _simulationActive = false;
  final LatLng _initialPoint = const LatLng(38.423734, 27.142826);

  @override
  void initState() {
    super.initState();
    _initializeMapController();
    _initializePulseController();
    _initializeMovementController();
  }

  void _initializeMapController() {
    _mapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
  }

  void _initializePulseController() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseAnimation = Tween<double>(begin: 30, end: 45).animate(_pulseController);
    _pulseController.repeat(reverse: true);
  }

  void _initializeMovementController() {
    _movementController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _movementController.addListener(() {
      if (_positionTween != null) {
        setState(() {
          _animatedPosition = _positionTween!.lerp(_movementController.value);
        });
      }
    });
    _movementController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _positionTween != null) {
        setState(() {
          _animatedPosition = _positionTween!.end;
        });
      }
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pulseController.dispose();
    _movementController.dispose();
    super.dispose();
  }

  /// Updates the marker's animated position and, if simulation is active, animates the camera.
  void _updateMarkerPosition(LatLng newLocation) {
    if (_animatedPosition == null) {
      setState(() => _animatedPosition = newLocation);
    } else if (_simulationActive && _animatedPosition != newLocation) {
      _positionTween = LatLngTween(begin: _animatedPosition!, end: newLocation);
      _movementController
        ..reset()
        ..forward();
    }
    if (_simulationActive) {
      _mapController.animateTo(dest: newLocation, zoom: 13);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MapMotion Flutter')),
      body: BlocListener<LocationCubit, LocationState>(
        listener: (context, state) {
          if (state.userLocation != null) {
            final newLocation = LatLng(
              state.userLocation!.latitude,
              state.userLocation!.longitude,
            );
            _updateMarkerPosition(newLocation);
          }
        },
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state.userLocation == null) {
              return const Center(child: CircularProgressIndicator());
            }
            // Use the animated marker position if available; otherwise, fallback to state's location.
            final markerPosition =
                _animatedPosition ?? LatLng(state.userLocation!.latitude, state.userLocation!.longitude);

            return MapViewBody(
              mapController: _mapController.mapController,
              markerAnimation: _pulseAnimation,
              markerPosition: markerPosition,
              simulationActive: _simulationActive,
              initialPoint: _initialPoint,
              onPressedCenterButton: () {
                setState(() {
                  _simulationActive = !_simulationActive;
                });

                if (_simulationActive) {
                  // Simulation flag is now enabled, so start the simulation.
                  context.read<LocationCubit>().startSimulation();
                } else {
                  // Simulation flag is now disabled, so stop the simulation.
                  context.read<LocationCubit>().stopSimulation();
                  _positionTween = LatLngTween(
                    begin: _animatedPosition ?? _initialPoint,
                    end: _initialPoint,
                  );
                  _movementController
                    ..reset()
                    ..forward();
                  _mapController.animateTo(dest: _initialPoint, zoom: 13);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
