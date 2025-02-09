import 'package:get_it/get_it.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_permission_service.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_service.dart';
import 'package:mapmotion_flutter/data/services/location_permission_service.dart';
import 'package:mapmotion_flutter/data/services/location_service.dart';

final getIt = GetIt.instance;

void injectionSetup() {
  // Location Permission Service
  getIt.registerLazySingleton<ILocationPermissionService>(() => LocationPermissionService());

  // Location Service
  getIt.registerLazySingleton<ILocationService>(() => LocationService());
}
