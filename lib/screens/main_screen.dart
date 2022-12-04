import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr/screens/camera_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({required this.camera,});
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  CameraScreen(camera: camera,)),
        ),
        child: const Text('Open Camera'),
      ),
    );
  }
}
