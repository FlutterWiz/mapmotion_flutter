import 'package:get_it/get_it.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_permission_service.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_service.dart';
import 'package:mapmotion_flutter/data/services/location_permission_service.dart';
import 'package:mapmotion_flutter/data/services/location_service.dart';
import 'package:mapmotion_flutter/presentation/blocs/application_life_cycle/application_life_cycle_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_cubit.dart';

final getIt = GetIt.instance;

void injectionSetup() {
  // Services
  getIt.registerLazySingleton<ILocationPermissionService>(() => LocationPermissionService());
  getIt.registerLazySingleton<ILocationService>(() => LocationService());

  // Cubits
  getIt.registerLazySingleton<PermissionCubit>(() => PermissionCubit(getIt<ILocationPermissionService>()));
  getIt.registerLazySingleton<ApplicationLifeCycleCubit>(() => ApplicationLifeCycleCubit());
  getIt.registerLazySingleton<LocationCubit>(() => LocationCubit());
}
