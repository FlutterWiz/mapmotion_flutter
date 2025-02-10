import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapmotion_flutter/presentation/blocs/application_life_cycle/application_life_cycle_state.dart';

class ApplicationLifeCycleCubit extends Cubit<ApplicationLifeCycleState> with WidgetsBindingObserver {
  ApplicationLifeCycleCubit() : super(ApplicationLifeCycleState.resumed()) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        emit(ApplicationLifeCycleState.resumed());
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        emit(ApplicationLifeCycleState.background());
        break;
    }
  }
}
