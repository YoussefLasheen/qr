import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as img;
import 'package:lasheen_qr/screens/generator_screen.dart';
import 'package:path/path.dart' as p;
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/gtk_appbar.dart';
import 'package:zxing2/qrcode.dart';

class ScannerScreen extends StatelessWidget {
  final String imagePath;

  const ScannerScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    Result? result = scan(imagePath);
    return Scaffold(
      appBar: Platform.isLinux
          ? const GTKAppBar(
              title: Text('Scaning result'),
            )
          : null,
      body: result != null
          ? Center(
              child: SizedBox(
                width: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: PrettyQr(
                          data: result.text,
                          elementColor: Theme.of(context).colorScheme.onSurface,
                          size: 300,
                          roundEdges: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, top: 25, bottom: 25),
                                child: SelectableText(result.text,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    minLines: 1,
                                    maxLines: 3, onTap: () async {
                                  if (await canLaunchUrl(
                                      Uri.parse(result.text))) {
                                    launchUrl(Uri.parse(result.text));
                                  }
                                }),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: result.text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to clipboard'),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(20),
                                child: Icon(
                                  Icons.copy,
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        minimumSize: const Size.fromHeight(65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GeneratorScreen(
                              initialContent: result.text,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit in generator'),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No QR code found',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go back'))
                ],
              ),
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
