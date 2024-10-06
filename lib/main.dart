import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:yaru/yaru.dart';

import 'screens/main_screen.dart';

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
    return ShadApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return YaruTitleBarTheme(
          data: YaruTitleBarThemeData(
            backgroundColor: WidgetStateColor.resolveWith(
              (states) {
                if (states.contains(WidgetState.focused)) {
                  return Theme.of(context).colorScheme.secondary;
                }
                return Colors.transparent;
              },
            ),
          ),
          child: child!,
        );
      },
      home: const MainScreen(),
    );
  }
}
