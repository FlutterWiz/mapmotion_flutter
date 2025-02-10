import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_state.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/latlng_tween.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/map_view_body.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/custom_marker.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  // Controllers
  late final AnimatedMapController _mapController;
  late final AnimationController _movementController;
  late final AnimationController _lottieController;

  // Tween and animated marker position.
  LatLngTween? _positionTween;
  LatLng? _animatedPosition;

  // Simulation state and button text.
  bool _isSimulating = false;
  String _buttonText = 'Start';

  // The initial (and reset) point.
  final LatLng _initialPoint = const LatLng(38.423734, 27.142826);

  // Target definitions for the square.
  // The square is defined as:
  //   Bottom-left: (38.503734, 27.222826)
  //   Top-left:    (38.543734, 27.222826)
  //   Top-right:   (38.543734, 27.262826)
  //   Bottom-right:(38.503734, 27.262826)
  // Its center is:
  //   (38.523734, 27.242826)
  final LatLng _targetBottomLeft = const LatLng(38.503734, 27.222826);
  final LatLng _targetCenter = const LatLng(38.523734, 27.242826);

  @override
  void initState() {
    super.initState();
    _initializeMapController();
    _initializeMovementController();
    _initializeLottieController();
  }

  void _initializeMapController() {
    _mapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );
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

  void _initializeLottieController() {
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _mapController.dispose();
    _movementController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  /// Updates the marker's animated position and animates the camera if simulating.
  void _updateMarkerPosition(LatLng newLocation) {
    if (_animatedPosition == null) {
      setState(() {
        _animatedPosition = newLocation;
      });
    } else if (_isSimulating && _animatedPosition != newLocation) {
      _positionTween = LatLngTween(begin: _animatedPosition!, end: newLocation);
      _movementController
        ..reset()
        ..forward();
    }
    if (_isSimulating) {
      _mapController.animateTo(dest: newLocation, zoom: 13);
    }
  }

  /// Checks if the marker touches the bottom-left corner of the target square.
  /// If within a threshold, prints the message, stops the Lottie animation,
  /// and animates the marker and camera to the target center.
  void _checkTargetTouch() {
    if (_animatedPosition != null) {
      final double distance = const Distance().as(LengthUnit.Meter, _animatedPosition!, _targetBottomLeft);
      if (distance < 1000) {
        print('YEEY YOU TOUCH');
        _lottieController.stop();
        _positionTween = LatLngTween(
          begin: _animatedPosition!,
          end: _targetCenter,
        );
        _movementController
          ..reset()
          ..forward();
        _mapController.animateTo(dest: _targetCenter, zoom: 13);
        setState(() {
          _isSimulating = false;
          _buttonText = 'Restart';
        });
      }
    }
  }

  /// Resets all UI state to initial conditions.
  void _resetEverything() {
    // Reset marker position to initial point.
    setState(() {
      _animatedPosition = _initialPoint;
      _isSimulating = false;
      _buttonText = 'Start';
    });
    _positionTween = LatLngTween(
      begin: _animatedPosition!,
      end: _initialPoint,
    );
    _movementController
      ..reset()
      ..forward();
    _mapController.animateTo(dest: _initialPoint, zoom: 13);
    context.read<LocationCubit>().stopSimulation();
    _lottieController.stop();
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
            if (_isSimulating) {
              _checkTargetTouch();
            }
          }
        },
        child: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state.userLocation == null) {
              return const Center(child: CircularProgressIndicator());
            }
            // Use the animated marker position if available; otherwise, fallback.
            final markerPosition = _animatedPosition ??
                LatLng(
                  state.userLocation!.latitude,
                  state.userLocation!.longitude,
                );
            return MapViewBody(
              mapController: _mapController.mapController,
              markerPosition: markerPosition,
              simulationActive: _isSimulating,
              initialPoint: _initialPoint,
              buttonText: _buttonText,
              onPressedCenterButton: () {
                if (_buttonText == 'Restart') {
                  _resetEverything();
                } else {
                  setState(() {
                    _isSimulating = true;
                    _buttonText = 'Restart'; // Button remains "Restart" during simulation.
                  });
                  context.read<LocationCubit>().startSimulation();
                  _lottieController.repeat();
                }
              },
              customMarker: CustomMarker(lottieController: _lottieController),
            );
          },
        ),
      ),
    );
  }
}
