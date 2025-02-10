import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapmotion_flutter/core/interfaces/i_app_life_cycle_service.dart';

class AppLifeCycleService with WidgetsBindingObserver implements IAppLifeCycleService {
  final StreamController<bool> _isResumedController = StreamController<bool>();

  AppLifeCycleService() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isResumedController.add(state == AppLifecycleState.resumed);
    super.didChangeAppLifecycleState(state);
  }

  @override
  Stream<bool> get isResumedStream => _isResumedController.stream;

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    await _isResumedController.close();
  }
}
