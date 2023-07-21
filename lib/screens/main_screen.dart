import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show Directory, Platform;
import 'package:file_selector/file_selector.dart';
import 'package:lasheen_qr/screens/generator_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'camera_screen.dart';
import 'scanner_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: YaruWindowTitleBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ScanSection(),
          SizedBox(
            height: 100,
            child: VerticalDivider(
              thickness: 1,
            ),
          ),
          GeneratorSection(),
        ],
      ),
    );
  }
}

class ScanSection extends StatelessWidget {
  const ScanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (!Platform.isLinux)
        //   ElevatedButton.icon(
        //     style: ElevatedButton.styleFrom(
        //       minimumSize: const Size.fromHeight(48),
        //       foregroundColor: Theme.of(context).colorScheme.onSurface,
        //     ),
        //     onPressed: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const CameraScreen()),
        //     ),
        //     label: const Text('Open Camera'),
        //     icon: const Icon(Icons.camera_alt_rounded),
        //   ),
        // const SizedBox(height: 10),
        Text(
          'SCAN',
          style: Theme.of(context).textTheme.displayLarge,
        ),

        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(225, 48),
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
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
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(225, 48),
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () async {
            Directory directory = await getTemporaryDirectory();
            String imageName =
                'Screenshot-${DateTime.now().millisecondsSinceEpoch}.png';
            String imagePath =
                '${directory.path}/qr_scanner/screenshots/$imageName';
            CapturedData? capturedData = await screenCapturer.capture(
              mode: CaptureMode.region,
              imagePath: imagePath,
            );
            if (capturedData != null) {
              Future(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScannerScreen(
                      imagePath: capturedData.imagePath!,
                    ),
                  ),
                ),
              );
            }
          },
          label: const Text('Take a screenshot'),
          icon: const Icon(Icons.screenshot_monitor_rounded),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class GeneratorSection extends StatelessWidget {
  const GeneratorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CREATE',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(225, 48),
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GeneratorScreen()),
          ),
          label: const Text('Generate QR Code'),
          icon: const Icon(Icons.qr_code_rounded),
        ),
      ],
    );
  }
}
