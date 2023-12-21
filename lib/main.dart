import 'package:flutter/material.dart';
import 'package:cekprodukisrael_app/page/about_page.dart';
import 'package:cekprodukisrael_app/services/bdnaash/bdnaash_service.dart';

/// Flutter code sample for [SearchBar].

void main() => runApp(const SearchBarApp());

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  // bool isDark = false;
  bool isLoading = true;
  bool isProIsrael = false;
  String targetBrand = "";

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
    );
        // brightness: isDark ? Brightness.dark : Brightness.light);

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.

    // const searchAncorWidget = SearchAnchor(builder:
    //                     (BuildContext context, SearchController controller) {
    //                   return SearchBar(
    //                     controller: controller,
    //                     padding: const MaterialStatePropertyAll<EdgeInsets>(
    //                         EdgeInsets.symmetric(horizontal: 16.0)),
    //                     onTap: () {
    //                       controller.openView();
    //                     },
    //                     onChanged: (value) {
    //                       controller.openView();
    //                       setState(() {
    //                         targetBrand = value;
    //                       });
    //                     },
    //                     onSubmitted: (value) {
    //                       setState(() {
    //                         targetBrand = value;
    //                       });
                          
    //                     },
    //                     leading: const Icon(Icons.search),
    //                     trailing: <Widget>[
    //                       Tooltip(
    //                         message: 'Change brightness mode',
    //                         child: IconButton(
    //                           isSelected: isDark,
    //                           onPressed: () {
    //                             setState(() {
    //                               ScaffoldMessenger.of(context)
    //                                   .showSnackBar(snackBar);
    //                               // isDark = !isDark;
    //                             });
    //                           },
    //                           icon: const Icon(Icons.camera_alt),
    //                           selectedIcon: const Icon(Icons.camera_alt),
    //                         ),
    //                       )
    //                     ],
    //                   );
    //                 }, suggestionsBuilder:
    //                     (BuildContext context, SearchController controller) {
    //                   return List<ListTile>.generate(5, (int index) {
    //                     final String item = 'item $index';
    //                     return ListTile(
    //                       title: Text(item),
    //                       onTap: () {
    //                         setState(() {
    //                           controller.closeView(item);
    //                           targetBrand = item;
    //                           // print(item);
    //                         });
    //                       },
    //                     );
    //                   });
    //                 });

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
                        SearchBar(
                            // controller: controller,
                            padding: const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16.0)),
                            onTap: () {
                              // controller.openView();
                              setState(() {
                                targetBrand = "";
                              });
                            },
                            onChanged: (value) {
                              // controller.openView();
                              if(value == "") {
                                setState(() {
                                  targetBrand = value;
                                });
                              }
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
                            leading: const Icon(Icons.search),
                            trailing: <Widget>[
                              Tooltip(
                                message: 'Scan Barcode',
                                child: IconButton(
                                  // isSelected: isDark,
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                          content: Text('Fitur scan barcode belum tersedia'),
                                        ));
                                      // isDark = !isDark;
                                    });
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
