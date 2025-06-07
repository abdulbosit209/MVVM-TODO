import 'package:flutter/material.dart';
import 'package:todo_project/core/utils/navigation/url_strategy/url_strategy.dart';
import 'package:todo_project/startup/startup_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();
  runApp(const StartupView());
}
