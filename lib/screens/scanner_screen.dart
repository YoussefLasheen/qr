import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:qr/screens/components/gtk_appbar.dart';

import 'package:zxing2/qrcode.dart';

class ScannerScreen extends StatelessWidget {
  final String imagePath;

  const ScannerScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    Result? result = scan(imagePath);
    return Scaffold(
      appBar: const GTKAppBar(title: Text('Scaning result'),),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          result == null ? const Text('No QR code found') : Text(result.text)
        ],
      ),
    );
  }
}

Result? scan(String filepath) {
  File file = File(filepath);
  Uint8List bytes = file.readAsBytesSync();
  img.Image? image;
  String extension = p.extension(filepath);
  if (extension == '.jpg' || extension == '.jpeg') {
    image = img.decodeJpg(bytes);
  } else if (extension == '.png') {
    image = img.decodePng(bytes);
  } else {
    throw Exception('Unsupported image format');
  }

  LuminanceSource source = RGBLuminanceSource(image!.width, image.height,
      image.getBytes(format: img.Format.abgr).buffer.asInt32List());
  var bitmap = BinaryBitmap(HybridBinarizer(source));

  var reader = QRCodeReader();
  try {
    var result = reader.decode(bitmap);
    return result;
  } on ReaderException {
    return null;
  }
}
