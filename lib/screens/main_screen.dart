import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:lasheen_qr/screens/generator_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screenshotx/screenshotx.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'package:zxing2/qrcode.dart';
import 'package:image/image.dart' as img;

import 'scanner_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: YaruWindowTitleBar(
          leading: YaruIconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              Future(() {
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    'assets/icon.png',
                    width: 50,
                    height: 50,
                  ),
                  applicationName: 'QR Scanner',
                  applicationVersion:
                      '${packageInfo.version}+${packageInfo.buildNumber}',
                  children: [
                    const Text(
                      'A QR Code Scanner and Generator app built with Flutter.',
                    ),
                    const SizedBox(height: 35),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => launchUrlString('https://lasheen.dev'),
                          child: Image.asset(
                            'assets/madebylasheen.png',
                            width: 250,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
            },
          ),
          title: const Text('QR Scanner'),
        ),
        body: Center(
          child: Table(
            defaultColumnWidth: const FixedColumnWidth(225),
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(225),
              1: FixedColumnWidth(35),
              2: FixedColumnWidth(225),
            },
            children: [
              TableRow(children: [
                Text(
                  'SCAN',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox.shrink(),
                Text(
                  'CREATE',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ]),
              const TableRow(
                children: [
                  ScanSection(),
                  SizedBox.shrink(),
                  GeneratorSection(),
                ],
              ),
            ],
          ),
        ));
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
        const SizedBox(
          height: 16,
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(225, 48),
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () async {
            const XTypeGroup typeGroup = XTypeGroup(
              label: 'images',
              extensions: <String>['jpg', 'jpeg', 'png'],
            );
            XFile? file =
                await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

            if (file == null) {
              // Operation was canceled by the user.
              return;
            }
            final imageBytes = await file.readAsBytes();

            Result? result = scan(imageBytes);
            if (result == null) {
              Future(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No QR Code found in the image.'),
                  ),
                );
              });
            } else {
              Future(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScannerScreen(
                        result: result,
                      ),
                    ),
                  );
                },
              );
            }
          },
          label: Text(
            'Pick from files',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          icon: const Icon(Icons.file_copy_rounded),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(225, 48),
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () async {
            final screenshotX = ScreenshotX();
            var image = await screenshotX.captureFullScreen();
            if (image != null) {
              final bytes = await image.toByteData(format: ImageByteFormat.png);
              final imageBytes = Uint8List.view(bytes!.buffer);

              Result? result = scan(imageBytes);
              if (result == null) {
                Future(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No QR Code found in the screenshot.'),
                    ),
                  );
                });
              } else {
                Future(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScannerScreen(
                          result: result,
                        ),
                      ),
                    );
                  },
                );
              }
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
        const SizedBox(
          height: 16,
        ),
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

Result? scan(Uint8List bytes) {
  img.Image image = img.decodeImage(bytes)!;
  LuminanceSource source = RGBLuminanceSource(
      image.width,
      image.height,
      image
          .convert(numChannels: 4)
          .getBytes(order: img.ChannelOrder.abgr)
          .buffer
          .asInt32List());
  var bitmap = BinaryBitmap(GlobalHistogramBinarizer(source));

  var reader = QRCodeReader();
  try {
    return reader.decode(bitmap);
  } catch (e) {
    return null;
  }
}
