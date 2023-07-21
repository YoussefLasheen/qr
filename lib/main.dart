import 'package:adwaita/adwaita.dart';
import 'package:flutter/material.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'screens/main_screen.dart';

import 'dart:io' show Platform;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await YaruWindowTitleBar.ensureInitialized();

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
      theme: Platform.isLinux?AdwaitaThemeData.light(): ThemeData.light(useMaterial3: true),
      darkTheme: Platform.isLinux?AdwaitaThemeData.dark(): ThemeData.dark(useMaterial3: true),
      //themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}
