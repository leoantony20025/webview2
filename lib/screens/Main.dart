import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:theater/screens/Home.dart';
import 'package:theater/screens/Options.dart';
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
      wishList = getWatchhList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Expanded(
      child: Stack(
        children: [
          currentIndex == 0 ? const HomeScreen() : const SizedBox(),
          currentIndex == 1 ? const SearchScreen() : const SizedBox(),
          currentIndex == 2 ? const WatchList() : const SizedBox(),
          currentIndex == 3 ? const Options() : const SizedBox(),
        ],
      ),
    );
    void nav(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 0, 17),
      bottomNavigationBar: MediaQuery.of(context).size.width < 800
          ? Container(
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
                      HugeIcons.strokeRoundedHome01,
                    ),
                    activeIcon: Icon(
                      HugeIcons.strokeRoundedHome01,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      HugeIcons.strokeRoundedSearch01,
                    ),
                    activeIcon: Icon(
                      HugeIcons.strokeRoundedSearch01,
                    ),
                    label: "Explore",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      HugeIcons.strokeRoundedPlayList,
                    ),
                    activeIcon: Icon(
                      HugeIcons.strokeRoundedPlayList,
                    ),
                    label: "Watchlist",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      HugeIcons.strokeRoundedLanguageSkill,
                    ),
                    activeIcon: Icon(
                      HugeIcons.strokeRoundedLanguageSkill,
                    ),
                    label: "Language",
                  ),
                ],
              ),
            )
          : const SizedBox(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                Container(
                  width: 100,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                        Color.fromARGB(255, 23, 0, 24),
                        Color.fromARGB(0, 17, 0, 17),
                      ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 0;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: currentIndex == 0
                              ? const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(60, 81, 0, 118),
                                        Color.fromARGB(59, 115, 0, 113)
                                      ]))
                              : null,
                          child: HugeIcon(
                              icon: HugeIcons.strokeRoundedHome01,
                              color: currentIndex == 0
                                  ? Colors.white
                                  : const Color.fromARGB(93, 217, 4, 228)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 1;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: currentIndex == 1
                              ? const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(60, 81, 0, 118),
                                        Color.fromARGB(59, 115, 0, 113)
                                      ]))
                              : null,
                          child: HugeIcon(
                              icon: HugeIcons.strokeRoundedSearch01,
                              color: currentIndex == 1
                                  ? Colors.white
                                  : const Color.fromARGB(93, 217, 4, 228)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 2;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: currentIndex == 2
                              ? const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(60, 81, 0, 118),
                                        Color.fromARGB(59, 115, 0, 113)
                                      ]))
                              : null,
                          child: HugeIcon(
                              icon: HugeIcons.strokeRoundedPlayList,
                              color: currentIndex == 2
                                  ? Colors.white
                                  : const Color.fromARGB(93, 217, 4, 228)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = 3;
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: currentIndex == 3
                              ? const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromARGB(60, 81, 0, 118),
                                        Color.fromARGB(59, 115, 0, 113)
                                      ]))
                              : null,
                          child: HugeIcon(
                              icon: HugeIcons.strokeRoundedLanguageSkill,
                              color: currentIndex == 3
                                  ? Colors.white
                                  : const Color.fromARGB(93, 217, 4, 228)),
                        ),
                      )
                    ],
                  ),
                ),
                content
              ],
            );
          } else {
            return Column(
              children: [content],
            );
          }
        },
      ),
    );
  }
}


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