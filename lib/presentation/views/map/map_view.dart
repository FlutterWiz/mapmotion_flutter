import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_state.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_state.dart';
import 'package:mapmotion_flutter/presentation/views/location_permission_denied/location_permission_denied_view.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/latlng_tween.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/map_view_body.dart';
import 'package:mapmotion_flutter/presentation/views/map/widgets/custom_marker.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  late final AnimatedMapController _mapController;
  late final AnimationController _movementController;
  late final AnimationController _lottieController;

  LatLngTween? _positionTween;
  late LatLng _animatedPosition;
  late LatLng _initialPoint;
  List<LatLng> _pathPoints = [];

  bool visible = false;
  bool _initialLocationSet = false;

  @override
  void initState() {
    super.initState();

    _mapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
    );

    _movementController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        if (_positionTween != null) {
          final newPos = _positionTween!.lerp(_movementController.value);
          setState(() {
            _animatedPosition = newPos;

            if (_pathPoints.isNotEmpty) {
              _pathPoints[_pathPoints.length - 1] = newPos;
            }
          });
        }
      });

    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _mapController.dispose();
    _movementController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  void _resetEverything() {
    _positionTween = LatLngTween(begin: _animatedPosition, end: _initialPoint);
    _movementController
      ..reset()
      ..forward();

    setState(() {
      _animatedPosition = _initialPoint;
      _pathPoints = [_initialPoint];
      visible = false;
    });

    _mapController.animateTo(dest: _initialPoint, zoom: 13);
  }

  void _handleMapTap(LatLng tappedPoint) {
    if (!_lottieController.isAnimating) {
      _lottieController.repeat();
    }

    setState(() {
      _pathPoints.add(_animatedPosition);
    });

    _positionTween = LatLngTween(begin: _animatedPosition, end: tappedPoint);
    _movementController
      ..reset()
      ..forward();

    _mapController.animateTo(dest: tappedPoint, zoom: 13);

    if (!visible) {
      setState(() {
        visible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, PermissionState>(
      builder: (context, permissionState) {
        // If location permission is not granted or location services are off,
        // immediately show the denied view.
        if (!permissionState.isLocationPermissionGranted || !permissionState.isLocationServiceEnabled) {
          return const LocationPermissionDeniedView();
        }
        // Otherwise, proceed with the map view.
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: BlocConsumer<LocationCubit, LocationState>(
            listener: (context, locationState) {
              if (locationState.userLocation != null && !_initialLocationSet) {
                final usersLocation = LatLng(
                  locationState.userLocation!.latitude,
                  locationState.userLocation!.longitude,
                );
                setState(() {
                  _initialPoint = usersLocation;
                  _animatedPosition = usersLocation;
                  _initialLocationSet = true;
                  _pathPoints = [usersLocation];
                });
              }
            },
            builder: (context, state) {
              if (state.userLocation == null || !_initialLocationSet) {
                return const Center(child: CircularProgressIndicator());
              }
              return MapViewBody(
                mapController: _mapController.mapController,
                markerPosition: _animatedPosition,
                initialPoint: _initialPoint,
                visible: visible,
                onPressedCenterButton: _resetEverything,
                onTapCallback: _handleMapTap,
                polylinePoints: _pathPoints,
                customMarker: CustomMarker(lottieController: _lottieController),
              );
            },
          ),
        );
      },
    );
  }
}
