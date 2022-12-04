import 'package:flutter/material.dart';
import 'package:qr/screens/camera_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CameraScreen()),
        ),
        child: const Text('Open Camera'),
      ),
    );
  }
}
