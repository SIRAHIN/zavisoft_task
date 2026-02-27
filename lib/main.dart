import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zavisoft_task/injection.dart';
import 'package:zavisoft_task/views/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app orientation to portrait mode \\
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  configureDependencies();

  runApp(const App());
}