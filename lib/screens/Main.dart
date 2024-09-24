import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:theater/providers/AppProvider.dart';
import 'package:theater/screens/Home.dart';
import 'package:theater/screens/Search.dart';
import 'package:theater/screens/WatchList.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  bool isLoading = true;
  int currentIndex = 0;
  List<Movie> wishList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!prefs.containsKey("lang")) {
        Navigator.pushNamed(context, '/language');
      }
      wishList = getWishList();
    });
  }

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

    void nav(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    print(language);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(41, 25, 1, 31),
          Color.fromARGB(163, 47, 1, 58)
        ])),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedLabelStyle: const TextStyle(fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          currentIndex: currentIndex,
          onTap: (value) => nav(value),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color.fromARGB(90, 219, 186, 232),
          selectedItemColor: Colors.white,
          elevation: 20,
          // iconSize: 30,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              activeIcon: Icon(
                Icons.home_filled,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_outlined,
              ),
              activeIcon: Icon(
                Icons.search_rounded,
              ),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.playlist_play_rounded,
              ),
              activeIcon: Icon(
                Icons.playlist_play_rounded,
              ),
              label: "Watchlist",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.translate_outlined,
              ),
              activeIcon: Icon(
                Icons.translate_rounded,
              ),
              label: "Language",
            ),
          ],
        ),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Stack(
            children: [
              currentIndex == 0 ? const HomeScreen() : const SizedBox(),
              currentIndex == 1 ? const SearchScreen() : const SizedBox(),
              currentIndex == 2 ? const WatchList() : const SizedBox(),
              currentIndex == 3
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.only(top: 50),
                      alignment: Alignment.topCenter,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Color.fromARGB(255, 23, 0, 28),
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
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height: 120,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        gradient: e['isSelected']
                                            ? const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                    Color.fromARGB(
                                                        70, 86, 0, 198),
                                                    Color.fromARGB(
                                                        217, 134, 0, 151)
                                                  ])
                                            : const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                    Color.fromARGB(
                                                        70, 42, 0, 97),
                                                    Color.fromARGB(
                                                        217, 31, 0, 35)
                                                  ])),
                                    child: Text(
                                      e['name'],
                                      style: TextStyle(
                                        color: e['isSelected']
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                140, 182, 144, 247),
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
                      ))
                  : const SizedBox(),
              // progress < 100
              //     ? Container(
              //         width: MediaQuery.of(context).size.width,
              //         height: MediaQuery.of(context).size.height,
              //         alignment: Alignment.center,
              //         decoration: const BoxDecoration(
              //             gradient: LinearGradient(
              //                 begin: Alignment.topCenter,
              //                 end: Alignment.bottomCenter,
              //                 colors: [
              //               Color.fromARGB(255, 23, 0, 28),
              //               Colors.black
              //             ])),
              //         child: const CircularProgressIndicator(
              //             color: Color.fromARGB(255, 123, 2, 154)),
              //       )
              //     : const SizedBox()
            ],
          ),
        ),
      ]),
    );
  }
}
