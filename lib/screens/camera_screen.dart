// import 'package:flutter/material.dart';

// import 'package:camera/camera.dart';

// import 'scanner_screen.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({
//     super.key,
//   });

//   @override
//   CameraScreenState createState() => CameraScreenState();
// }

// class CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.black,
//       child: FutureBuilder<Object>(
//           future: availableCameras(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const CircularProgressIndicator();
//             }
//             var cameras = snapshot.data as List<CameraDescription>;
//             _controller = CameraController(
//               cameras.first,
//               ResolutionPreset.medium,
//             );
//             return FutureBuilder<void>(
//               future: _controller.initialize(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return Stack(
//                     //fit: StackFit.expand,
//                     alignment: Alignment.center,
//                     children: [
//                       CameraPreview(_controller),
//                       //Container(color: Colors.white, height: 500, width :500,),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.crop_free_rounded,
//                               size: 300, color: Colors.white),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               IconButton(
//                                 color: Colors.white,
//                                 icon: Icon(
//                                   _controller.value.flashMode == FlashMode.torch
//                                       ? Icons.flash_on
//                                       : Icons.flash_off,
//                                 ),
//                                 onPressed: () {
//                                   _controller.value.flashMode == FlashMode.torch
//                                       ? _controller.setFlashMode(FlashMode.off)
//                                       : _controller
//                                           .setFlashMode(FlashMode.torch);
//                                 },
//                               ),
//                               ElevatedButton(
//                                 onPressed: () async => await takeImage(),
//                                 child: Row(children: const [
//                                   Icon(Icons.camera_alt),
//                                   SizedBox(width: 10),
//                                   Text('Scan'),
//                                 ]),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 } else {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//               },
//             );
//           }),
//     );
//   }

//   takeImage() async {
//     try {
//       _controller.setFlashMode(FlashMode.off);

//       final image = await _controller.takePicture();

//       if (!mounted) return;

//       await Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => ScannerScreen(
//             imagePath: image.path,
//           ),
//         ),
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
