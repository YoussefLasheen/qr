import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show Platform;
import 'package:file_selector/file_selector.dart';
import 'package:lasheen_qr/screens/generator_screen.dart';

import 'camera_screen.dart';
import 'scanner_screen.dart';
import 'components/gtk_appbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isLinux
          ? const GTKAppBar(
              title: Text('QR Scanner'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner_rounded),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.plus_one_rounded),
            label: 'Generate',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
      body: Center(
        child: const[
          ScanSection(),
          GeneratorScreen(),
        ][_selectedIndex],
      ),
    );
  }
}

class ScanSection extends StatelessWidget {
  const ScanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!Platform.isLinux)
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraScreen()),
            ),
            child: const Text('Open Camera'),
          ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            const XTypeGroup typeGroup = XTypeGroup(
              label: 'images',
              extensions: <String>['jpg', 'png'],
            );
            XFile? file;

            if (Platform.isAndroid || Platform.isIOS) {
              file = await ImagePicker().pickImage(source: ImageSource.gallery);
            } else {
              file =
                  await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
            }
            if (file == null) {
              // Operation was canceled by the user.
              return;
            }
            final String filePath = file.path;

            await showDialog<void>(
              context: context,
              builder: (BuildContext context) =>
                  ScannerScreen(imagePath: filePath),
            );
          },
          child: Text('Pick from gallery', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
        ),
      ],
    );
  }
}
