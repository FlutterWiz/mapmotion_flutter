import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapmotion_flutter/core/di/dependency_injector.dart';
import 'package:mapmotion_flutter/presentation/blocs/location/location_cubit.dart';
import 'package:mapmotion_flutter/presentation/blocs/permission/permission_cubit.dart';
import 'package:mapmotion_flutter/presentation/views/map/map_view.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<PermissionCubit>()..initialize(),
        ),
        BlocProvider(
          create: (context) => getIt<LocationCubit>()..initialize(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MapView(),
      ),
    );
  }
}
