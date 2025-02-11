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
  late final AnimatedMapController _mapController;
  late final AnimationController _movementController;
  late final AnimationController _lottieController;

  LatLngTween? _positionTween;
  late LatLng _animatedPosition;
  late LatLng _initialPoint;

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
          setState(() {
            _animatedPosition = _positionTween!.lerp(_movementController.value);
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
      visible = false;
    });

    _mapController.animateTo(dest: _initialPoint, zoom: 13);
  }

  void _handleMapTap(LatLng tappedPoint) {
    if (!_lottieController.isAnimating) {
      _lottieController.repeat();
    }

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
    return Scaffold(
      appBar: AppBar(title: const Text('MapMotion Flutter')),
      body: BlocListener<LocationCubit, LocationState>(
        listenWhen: (p, c) => p.userLocation != c.userLocation,
        listener: (context, state) {
          if (state.userLocation != null && !_initialLocationSet) {
            final usersLocation = LatLng(state.userLocation!.latitude, state.userLocation!.longitude);

            setState(() {
              _initialPoint = usersLocation;
              _animatedPosition = usersLocation;
              _initialLocationSet = true;
            });
          }
        },
        child: BlocBuilder<LocationCubit, LocationState>(
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
              customMarker: CustomMarker(lottieController: _lottieController),
            );
          },
        ),
      ),
    );
  }
}
