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
            icon: Icon(Icons.add_box_outlined),
            label: 'Generate',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
      ),
      body: Center(
        child: const [
          ScanSection(),
          GeneratorSection(),
        ][_selectedIndex],
      ),
    );
  }
}

class ScanSection extends StatelessWidget {
  const ScanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!Platform.isLinux)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraScreen()),
              ),
              label: const Text('Open Camera'),
              icon: const Icon(Icons.camera_alt_rounded),
            ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () async {
              const XTypeGroup typeGroup = XTypeGroup(
                label: 'images',
                extensions: <String>['jpg', 'png'],
              );
              XFile? file;

              if (Platform.isAndroid || Platform.isIOS) {
                file =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
              } else {
                file =
                    await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
              }
              if (file == null) {
                // Operation was canceled by the user.
                return;
              }
              final String filePath = file.path;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScannerScreen(
                    imagePath: filePath,
                  ),
                ),
              );
            },
            label: Text(
              'Pick from gallery',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            icon: const Icon(Icons.photo_library_rounded),
          ),
        ],
      ),
    );
  }
}

class GeneratorSection extends StatelessWidget {
  const GeneratorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(75, 48),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GeneratorScreen()),
        ),
        label: const Text('Generate QR Code'),
        icon: const Icon(Icons.qr_code_rounded),
      ),
    );
  }
}
