import 'package:get_it/get_it.dart';
import 'package:mapmotion_flutter/core/interfaces/i_app_life_cycle_service.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_permission_service.dart';
import 'package:mapmotion_flutter/core/interfaces/i_location_service.dart';
import 'package:mapmotion_flutter/data/services/app_life_cycle_service.dart';
import 'package:mapmotion_flutter/data/services/location_permission_service.dart';
import 'package:mapmotion_flutter/data/services/location_service.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_cubit.dart';

final getIt = GetIt.instance;

void injectionSetup() {
  // Services
  getIt.registerLazySingleton<ILocationPermissionService>(() => LocationPermissionService());
  getIt.registerLazySingleton<ILocationService>(() => LocationService());
  getIt.registerLazySingleton<IAppLifeCycleService>(() => AppLifeCycleService());

  // Cubits
  getIt.registerLazySingleton<PermissionCubit>(
    () => PermissionCubit(getIt<ILocationPermissionService>(), getIt<IAppLifeCycleService>()),
  );
  getIt.registerLazySingleton<LocationCubit>(() => LocationCubit());
}
