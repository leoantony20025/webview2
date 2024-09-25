import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theater/providers/AppProvider.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    int? lang = appProvider.lang;
    List languages = [
      {
        "name": "Tamil",
        "isSelected": lang == 1,
        "value": 1,
        "path": "/category/tamil-movies"
      },
      {
        "name": "English",
        "isSelected": lang == 2,
        "value": 2,
        "path": "/category/english-movies"
      },
      {
        "name": "Malayalam",
        "isSelected": lang == 3,
        "value": 3,
        "path": "/category/malayalam-movies"
      },
      {
        "name": "Telugu",
        "isSelected": lang == 4,
        "value": 4,
        "path": "/category/telugu-movies"
      },
      {
        "name": "Kannada",
        "isSelected": lang == 5,
        "value": 5,
        "path": "/category/kannada-movies"
      },
      {
        "name": "Hindi",
        "isSelected": lang == 6,
        "value": 6,
        "path": "/category/hindi-movies"
      }
    ];
    String language = languages[(lang ?? 1) - 1]['name'];
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 50),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: isDesktop ? Alignment.centerLeft : Alignment.topCenter,
                  end: isDesktop
                      ? Alignment.centerRight
                      : Alignment.bottomCenter,
                  colors: const [
                Color.fromARGB(255, 17, 0, 17),
                Colors.black
              ])),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Language",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 20,
                  children: languages.map((e) {
                    return GestureDetector(
                      onTap: () {
                        if (!e['isSelected']) {
                          // prefs.setInt("lang", e['value']);
                          appProvider.updateLang(e['value']);
                          setState(() {
                            // lang = prefs.getInt("lang");
                          });
                        }
                      },
                      child: Container(
                        width: isDesktop
                            ? MediaQuery.of(context).size.width / 2 - 100
                            : MediaQuery.of(context).size.width - 40,
                        height: 120,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            gradient: e['isSelected']
                                ? const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        Color.fromARGB(70, 86, 0, 198),
                                        Color.fromARGB(217, 134, 0, 151)
                                      ])
                                : const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        Color.fromARGB(70, 42, 0, 97),
                                        Color.fromARGB(217, 31, 0, 35)
                                      ])),
                        child: Text(
                          e['name'],
                          style: TextStyle(
                            color: e['isSelected']
                                ? Colors.white
                                : const Color.fromARGB(140, 182, 144, 247),
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          )),
    );
  }
}
