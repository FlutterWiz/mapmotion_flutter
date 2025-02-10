import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapmotion_flutter/core/constants/enums/location_permission_status_enum.dart';
import 'package:mapmotion_flutter/core/interfaces/i_app_life_cycle_service.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_permission_service.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit(this._permissionService, this._appLifeCycleService) : super(PermissionState.initial());

  final ILocationPermissionService _permissionService;
  final IAppLifeCycleService _appLifeCycleService;

  StreamSubscription<bool>? _locationPermissionStatusSubscription;
  StreamSubscription<bool>? _appLifeCycleSubscription;

  @override
  Future<void> close() {
    _appLifeCycleSubscription?.cancel();
    _locationPermissionStatusSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    final isLocationServiceEnabled = await _permissionService.isLocationServicesEnabled();
    final isLocationPermissionGranted = await _permissionService.isLocationPermissionGranted();

    _locationPermissionStatusSubscription?.cancel();
    _locationPermissionStatusSubscription = _permissionService.locationPermissionStatusStream.listen((isGranted) {
      emit(state.copyWith(isLocationPermissionGranted: isGranted));
    });

    _appLifeCycleSubscription?.cancel();
    _appLifeCycleSubscription = _appLifeCycleService.isResumedStream.listen((isResumed) async {
      if (isResumed) {
        final isGranted = await _permissionService.isLocationPermissionGranted();

        emit(state.copyWith(isLocationPermissionGranted: isGranted));
      }
    });

    emit(
      state.copyWith(
        isLocationServiceEnabled: isLocationServiceEnabled,
        isLocationPermissionGranted: isLocationPermissionGranted,
      ),
    );
  }

  Future<void> requestLocationPermission() async {
    final status = await _permissionService.requestLocationPermission();

    emit(state.copyWith(isLocationPermissionGranted: status == LocationPermissionStatusEnum.granted));
  }

  Future<void> openLocationSettings() async {
    await _permissionService.openLocationSettings();
  }

  Future<void> openApplicationSettings() async {
    await _permissionService.openApplicationSettings();
  }
}
