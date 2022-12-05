import 'package:android_path_provider/android_path_provider.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import 'dart:io';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key, this.initialContent = 'lasheen'});
  final String initialContent;

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  //GlobalKey globalKey = GlobalKey();

  String? content;
  int? version = 1;
  //bool calculateVersionAutomatically = true;
  bool roundEdges = true;
  int errorCorrectLevel = QrErrorCorrectLevel.M;

  ScreenshotController screenshotController = ScreenshotController(); 
  @override
  Widget build(BuildContext context) {
    content ??= widget.initialContent;
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: PrettyQr(
                      data: content!,
                      elementColor: Theme.of(context).colorScheme.onSurface,
                      size: 300,
                      roundEdges: roundEdges,
                      typeNumber: version,
                      errorCorrectLevel: errorCorrectLevel,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: TextFormField(
                      initialValue: widget.initialContent,
                      maxLength: calculateMaxInput(
                          version: version,
                          errorCorrectLevel: errorCorrectLevel,),
                      onChanged: (value) {
                        setState(() {
                          content = value;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Content',
                        hintText: 'Enter a link to generate a QR code',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'QR code settings',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        YaruSwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                          title: const Text('Rounded corners'),
                          value: roundEdges,
                          onChanged: (value) {
                            setState(() {
                              roundEdges = value;
                            });
                          },
                        ),
                        YaruSwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                          title: const Text('Calculate version automatically'),
                          value: version == null,
                          onChanged: (value) {
                            if (!value) {
                              for (var i = 1; i < 40; i++) {
                                if (calculateMaxInput(
                                        version: i,
                                        errorCorrectLevel: errorCorrectLevel,) >
                                    content!.length) {
                                  setState(() {
                                    version = i;
                                    //calculateVersionAutomatically = false;
                                  });
                                  break;
                                }
                              }
                            } else {
                              setState(() {
                                version = null;
                              });
                            }
                          },
                        ),
                        YaruTile(
                          enabled: version != null,
                          title: const Text('Version'),
                          subtitle: const Text('The higher the number the denser the QR code'),
                          trailing: SizedBox(
                            width: 100,
                            height: 50,
                            child: SpinBox(
                              enabled:  version != null,
                              spacing: 0,
                              enableInteractiveSelection: false,
                              showCursor: false,
                              min: 1,
                              max: 40,
                              value: (version??0).toDouble(),
                              direction: Axis.horizontal,
                              canChange: (value) {
                                if (value < 1) return false;
                                int maxInputLength = calculateMaxInput(
                                    version: value.toInt(),
                                    errorCorrectLevel: errorCorrectLevel,);
                                if (maxInputLength >= content!.length) {
                                  setState(() {
                                    version = value.toInt();
                                  });
                                  return true;
                                }
                                return false;
                              },
                            ),
                          ),
                        ),
                        YaruTile(
                          title: const Text('Error correction level'),
                          subtitle: const Text('L is the '
                              'lowest and H is the highest.'),
                          trailing: YaruPopupMenuButton<int>(
                            itemBuilder: (c) => [
                              PopupMenuItem(
                                child: const Text('L'),
                                onTap: () {
                                  setState(() {
                                    errorCorrectLevel = QrErrorCorrectLevel.L;
                                  });
                                },
                              ),
                              PopupMenuItem(
                                enabled: calculateMaxInput(
                                        version: version,
                                        errorCorrectLevel:
                                            QrErrorCorrectLevel.M,) >
                                    content!.length,
                                child: const Text('M'),
                                onTap: () {
                                  setState(() {
                                    errorCorrectLevel = QrErrorCorrectLevel.M;
                                  });
                                },
                              ),
                              PopupMenuItem(
                                enabled: calculateMaxInput(
                                        version: version,
                                        errorCorrectLevel:
                                            QrErrorCorrectLevel.Q) >
                                    content!.length,
                                child: const Text('Q'),
                                onTap: () {
                                  setState(() {
                                    errorCorrectLevel = QrErrorCorrectLevel.Q;
                                  });
                                },
                              ),
                              PopupMenuItem(
                                enabled: calculateMaxInput(
                                        version: version,
                                        errorCorrectLevel:
                                            QrErrorCorrectLevel.H) >
                                    content!.length,
                                child: const Text('H'),
                                onTap: () {
                                  setState(() {
                                    errorCorrectLevel = QrErrorCorrectLevel.H;
                                  });
                                },
                              ),
                            ],
                            child: Text(levelsNames[errorCorrectLevel]),
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
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                     minimumSize: const Size.fromHeight(65),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0),
                     ),
                  ),
                  onPressed: () async {
                    screenshotController
                        .captureFromWidget(
                      ColoredBox(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PrettyQr(
                            data: content!,
                            elementColor: Colors.black,
                            size: 300,
                            roundEdges: roundEdges,
                            typeNumber: version,
                            errorCorrectLevel: errorCorrectLevel,
                          ),
                        ),
                      ),
                    )
                        .then((imageBytes) async {
                      String? outputFile;
                      if (Platform.isAndroid) {
                        outputFile = '${await AndroidPathProvider.downloadsPath}/qrcode.png';
                      } else {
                        outputFile = await getSavePath(
                            suggestedName: 'qrcode.png',
                            acceptedTypeGroups: [
                              const XTypeGroup(
                                label: 'PNGs',
                                extensions: <String>['png'],
                              )
                            ]);
                      }
                      if (outputFile != null) {
                        File image = File(outputFile);
                        image.writeAsBytesSync(imageBytes);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Saved to $outputFile'),
                          ),
                        );
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Qr code not saved'),
                          ),
                        );
                      }
                    }).catchError((onError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Error: $onError'),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save QR code'),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int calculateMaxInput(
    {required int errorCorrectLevel,
    required int? version,}) {
  version ??= 40;
  return capacities[(version * 4) + levels[errorCorrectLevel]];
}

const List<int> levels = [1, 0, 3, 2];
List<String> levelsNames = ['M', 'L', 'H', 'Q'];
const List<int> capacities = [
  0,
  0,
  0,
  0,
  17,
  14,
  11,
  7,
  32,
  26,
  20,
  14,
  53,
  42,
  32,
  24,
  78,
  62,
  46,
  34,
  106,
  84,
  60,
  44,
  134,
  106,
  74,
  58,
  154,
  122,
  86,
  64,
  192,
  152,
  108,
  84,
  230,
  180,
  130,
  98,
  271,
  213,
  151,
  119,
  321,
  251,
  177,
  137,
  367,
  287,
  203,
  155,
  425,
  331,
  241,
  177,
  458,
  362,
  258,
  194,
  520,
  412,
  292,
  220,
  586,
  450,
  322,
  250,
  644,
  504,
  364,
  280,
  718,
  560,
  394,
  310,
  792,
  624,
  442,
  338,
  858,
  666,
  482,
  382,
  929,
  711,
  509,
  403,
  1003,
  779,
  565,
  439,
  1091,
  857,
  611,
  461,
  1171,
  911,
  661,
  511,
  1273,
  997,
  715,
  535,
  1367,
  1059,
  751,
  593,
  1465,
  1125,
  805,
  625,
  1528,
  1190,
  868,
  658,
  1628,
  1264,
  908,
  698,
  1732,
  1370,
  982,
  742,
  1840,
  1452,
  1030,
  790,
  1952,
  1538,
  1112,
  842,
  2068,
  1628,
  1168,
  898,
  2188,
  1722,
  1228,
  958,
  2303,
  1809,
  1283,
  983,
  2431,
  1911,
  1351,
  1051,
  2563,
  1989,
  1423,
  1093,
  2699,
  2099,
  1499,
  1139,
  2809,
  2213,
  1579,
  1219,
  2953,
  2331,
  1663,
  1273
];
