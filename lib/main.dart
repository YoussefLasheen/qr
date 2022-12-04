import 'package:adwaita/adwaita.dart';
import 'package:flutter/material.dart';

import 'screens/main_screen.dart';

import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Platform.isLinux?AdwaitaThemeData.dark(): ThemeData(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}
