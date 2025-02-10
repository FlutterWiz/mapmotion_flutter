import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapmotion_flutter/core/di/dependency_injector.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_service.dart';
import 'package:mapmotion_flutter/domain/models/location.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_state.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationState.initial());

  final ILocationService _locationService = getIt<ILocationService>();
  final PermissionCubit _permissionCubit = getIt<PermissionCubit>();
  StreamSubscription<Location>? _locationSubscription;
  StreamSubscription<PermissionState>? _permissionSubscription;

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _permissionSubscription?.cancel();
    return super.close();
  }

  void initialize() {
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
      }
    });
  }

  void openLocationSubscription() {
    _locationSubscription?.cancel();
    _locationSubscription = _locationService.locationStream.listen((location) {
      emit(state.copyWith(userLocation: location));
    });
  }
}
