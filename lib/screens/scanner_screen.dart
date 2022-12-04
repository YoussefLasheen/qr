import 'dart:io';

import 'package:flutter/material.dart';
import 'package:r_scan/r_scan.dart';

class ScannerScreen extends StatelessWidget {
  final String imagePath;

  const ScannerScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Image.file(File(imagePath)),
          FutureBuilder<RScanResult>(
              future: RScan.scanImagePath(imagePath),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.done) {
                  if (snap.data!.message == null) {
                    return Text('No QR code found');
                  } else {
                    return Text(snap.data!.message!);
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}
