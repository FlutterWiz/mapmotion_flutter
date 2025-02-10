import 'package:flutter/material.dart';
import 'package:mapmotion_flutter/core/di/dependency_injector.dart';
import 'package:mapmotion_flutter/core/init/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  injectionSetup();

  runApp(const AppWidget());
}
