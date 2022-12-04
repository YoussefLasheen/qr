import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show Platform;
import 'package:file_selector/file_selector.dart';

import 'camera_screen.dart';
import 'scanner_screen.dart';
import 'components/gtk_appbar.dart';



class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GTKAppBar(title: Text('QR Scanner'),),
      body: Center(
        child: Row(
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

                await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      ScannerScreen(imagePath: filePath),
                );
              },
              child: const Text('Pick from gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
