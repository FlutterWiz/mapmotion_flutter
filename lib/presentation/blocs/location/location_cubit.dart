import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapmotion_flutter/core/di/dependency_injector.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_service.dart';
import 'package:mapmotion_flutter/domain/models/location.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_state.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationState.initial()) {
    initialize();
  }

  final ILocationService _locationService = getIt<ILocationService>();
  final PermissionCubit _permissionCubit = getIt<PermissionCubit>();

  StreamSubscription<Location>? _locationSubscription;
  StreamSubscription<PermissionState>? _permissionSubscription;

  // Timer for simulating location changes.
  Timer? _simulationTimer;

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _permissionSubscription?.cancel();
    _simulationTimer?.cancel();
    return super.close();
  }

  void initialize() {
    // Check if location access is available.
    final isLocationAccessible =
        _permissionCubit.state.isLocationPermissionGranted && _permissionCubit.state.isLocationServiceEnabled;

    if (isLocationAccessible) {
      openLocationSubscription();
    }

    _permissionSubscription?.cancel();
    _permissionSubscription = _permissionCubit.stream.listen((permissionState) {
      if (permissionState.isLocationPermissionGranted && permissionState.isLocationServiceEnabled) {
        openLocationSubscription();
      } else {
        _locationSubscription?.cancel();
        stopSimulation();
      }
    });
  }

  void openLocationSubscription() {
    _locationSubscription?.cancel();
    _locationSubscription = _locationService.locationStream.listen((location) {
      // Only update from the real location stream if simulation is not active.
      if (_simulationTimer == null) {
        emit(state.copyWith(userLocation: location));
      }
    });
  }

  /// Starts simulating location changes.
  void startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 1850), (timer) {
      if (state.userLocation != null) {
        final newLoc = Location(
          latitude: state.userLocation!.latitude + 0.015,
          longitude: state.userLocation!.longitude + 0.015,
        );
        emit(state.copyWith(userLocation: newLoc));
      }
    });
  }

  /// Stops the simulation of location changes.
  void stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }
}
