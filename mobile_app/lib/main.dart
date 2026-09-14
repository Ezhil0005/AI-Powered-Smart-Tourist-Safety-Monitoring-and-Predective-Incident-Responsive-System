import 'package:flutter/material.dart';

import 'core/services/trip_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restore the saved trip before the app starts.
  await TripService.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tourist Safety',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}