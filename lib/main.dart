import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cekprodukisrael_app/page/about_page.dart';
import 'package:cekprodukisrael_app/services/bdnaash/bdnaash_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:cekprodukisrael_app/components/image_widget.dart';
import 'package:cekprodukisrael_app/models/local/recognition_response.dart';
import 'package:cekprodukisrael_app/recognizer/interface/text_recognizer.dart';
import 'package:cekprodukisrael_app/recognizer/mlkit_text_recognizer.dart';

/// Flutter code sample for [SearchBar].

void main() => runApp(const SearchBarApp());

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {

  late ImagePicker _picker;
  late ITextRecognizer _recognizer;

  RecognitionResponse? _response;

  // bool isDark = false;
  bool isLoading = true;
  bool isProIsrael = false;
  String targetBrand = "";
  String responseImageText = "";

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();

    /// Can be [MLKitTextRecognizer] or [TesseractTextRecognizer]
    _recognizer = MLKitTextRecognizer();
    // _recognizer = TesseractTextRecognizer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_recognizer is MLKitTextRecognizer) {
      (_recognizer as MLKitTextRecognizer).dispose();
    }
  }

  Future<String?> obtainImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    return file?.path;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: Builder(
        builder: (context) => Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: const Text('Cek Produk Israel'),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        _response = null;
                        targetBrand = "";
                        isProIsrael = false;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: 'About',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutPage()),
                      );
                    },
                  ),
                ],
              ),
              body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _buildImage(),
                        SearchBar(
                            // controller: controller,
                            padding: const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16.0)),
                            onTap: () {
                              // controller.openView();
                              // setState(() {
                              //   targetBrand = "";
                              // });
                            },
                            onChanged: (value) {
                              // controller.openView();
                              // if(value == "") {
                              //   setState(() {
                              //     targetBrand = value;
                              //   });
                              // }
                            },
                            onSubmitted: (value) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              if(value != "") {
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                    content: Text('Proses pencarian sedang berjalan...'),
                                    duration: Duration(seconds: 30),
                                  ));
                                var bdnaash = BdnaashService();
                                final response = bdnaash.search(value);
                                response.then((responseValue) => 
                                  setState(() {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    // targetBrand = responseValue.data.title ?? "";
                                    // isProIsrael = responseValue.data.isProIsrael == "1";
                                    targetBrand = value;
                                    isProIsrael = responseValue.statusClass == "b-red";
                                  })
                                );
                              } else {
                                setState(() {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  targetBrand = "";
                                  isProIsrael = false;
                                });
                              }
                            },
                            hintText: "Ketik nama produk, merk, brand yang ingin dicari",
                            shape: MaterialStateProperty.all(const ContinuousRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            )),
                            leading: const Icon(Icons.search),
                            trailing: <Widget>[
                              Tooltip(
                                message: 'Pilih Gambar',
                                child: IconButton(
                                  // isSelected: isDark,
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    showDialog(
                                      context: context,
                                      builder: (context) => imagePickAlert(
                                        onCameraPressed: () async {
                                          _response = null;
                                          final imgPath = await obtainImage(ImageSource.camera);
                                          if (imgPath == null) return;

                                          final recognizedText = await _recognizer.processImage(imgPath);
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          _response = RecognitionResponse(
                                            imgPath: imgPath,
                                            recognizedText: recognizedText,
                                            // recognizedText: "NIVEA",
                                          );
                                          responseImageText = recognizedText;
                                          // responseImageText = "NIVEA";

                                          if (!context.mounted) return;
                                          // Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          if(responseImageText != "") {
                                            ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                content: Text('Proses pencarian sedang berjalan...'),
                                                duration: Duration(seconds: 30),
                                              ));
                                            var bdnaash = BdnaashService();
                                            final response = bdnaash.search(responseImageText);
                                            response.then((responseValue) => 
                                              setState(() {
                                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                Navigator.of(context).pop();
                                                // targetBrand = responseValue.data.title ?? "";
                                                // isProIsrael = responseValue.data.isProIsrael == "1";
                                                targetBrand = responseImageText;
                                                isProIsrael = responseValue.statusClass == "b-red";
                                              })
                                            );
                                          } else {
                                            setState(() {
                                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                              Navigator.of(context).pop();
                                              targetBrand = "";
                                              isProIsrael = false;
                                            });
                                          }
                                        },
                                        onGalleryPressed: () async {
                                          final imgPath = await obtainImage(ImageSource.gallery);
                                          if (imgPath == null) return;
                                          
                                          final recognizedText = await _recognizer.processImage(imgPath);
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          _response = RecognitionResponse(
                                            imgPath: imgPath,
                                            recognizedText: recognizedText,
                                            // recognizedText: "NIVEA",
                                          );
                                          responseImageText = recognizedText;
                                          // responseImageText = "NIVEA";

                                          if (!context.mounted) return;
                                          // Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          if(responseImageText != "") {
                                            ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                content: Text('Proses pencarian sedang berjalan...'),
                                                duration: Duration(seconds: 30),
                                              ));
                                            var bdnaash = BdnaashService();
                                            final response = bdnaash.search(responseImageText);
                                            response.then((responseValue) => 
                                              setState(() {
                                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                Navigator.of(context).pop();
                                                // targetBrand = responseValue.data.title ?? "";
                                                // isProIsrael = responseValue.data.isProIsrael == "1";
                                                targetBrand = responseImageText;
                                                isProIsrael = responseValue.statusClass == "b-red";
                                              })
                                            );
                                          } else {
                                            setState(() {
                                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                              Navigator.of(context).pop();
                                              targetBrand = "";
                                              isProIsrael = false;
                                            });
                                          }
                                        },
                                      ),
                                    );
                                    // setState(() {
                                    //   ScaffoldMessenger.of(context)
                                    //     .showSnackBar(const SnackBar(
                                    //       content: Text('Fitur scan barcode belum tersedia'),
                                    //     ));
                                    //   // isDark = !isDark;
                                    // });
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                  selectedIcon: const Icon(Icons.camera_alt),
                                ),
                              )
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: _buildResult(),
                        )
                      ])),
            ),
      ),
    );
  }

  Widget _buildImage() {
    if(_response == null) {
      return const Text("");
    } else {
      return Column(
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _response = null;
                      targetBrand = "";
                      isProIsrael = false;
                    });
                  },
                  icon: const Icon( // <-- Icon
                    Icons.close,
                    size: 24.0,
                  ),
                  label: const Text('Tutup Gambar'), // <-- Text
                ),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  // padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent)
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(File(_response!.imgPath)),
                  ),
                )
                // Padding(
                //     padding: const EdgeInsets.all(16),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           children: [
                //             Expanded(
                //               child: Text(
                //                 "Recognized Text",
                //                 style: Theme.of(context).textTheme.titleLarge,
                //               ),
                //             ),
                //           ],
                //         ),
                //         const SizedBox(height: 10),
                //         Text(_response!.recognizedText),
                //       ],
                //     )),
              ],
            );
    }
  }

  Widget _buildResult() {
    if(targetBrand != "" && isProIsrael) {
      return Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.warning_rounded, 
                  size: 50,
                  color: Colors.red,
                ),
                title: Text(
                  targetBrand,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                ),
                subtitle: const Text(
                  'Merk ini mendukung okupansi Israel.',
                  style: TextStyle(color: Colors.black54)
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return const Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.check_circle, 
                  size: 50,
                  color: Colors.green,
                ),
                // leading: Icon(
                //   Icons.question_mark_rounded, 
                //   size: 40,
                //   color: Colors.orange,
                // ),
                title: Text(
                  "Data tidak ditemukan",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                ),
                subtitle: Text(
                  'Silahkan ketik kata kunci lainnya.',
                  style: TextStyle(color: Colors.black54)
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
