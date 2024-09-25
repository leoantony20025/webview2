import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:theater/components/GradientText.dart';
import 'package:theater/components/HorizontalScrollList.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';
import 'package:theater/providers/AppProvider.dart';
import 'package:theater/screens/WatchList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: true);
    Map<String, List<Movie?>> currentContents = appProvider.currentContents;
    bool isLoading = false;
    int? lang = appProvider.lang;
    List languages = [
      {"name": "Tamil", "value": 1, "path": "/category/tamil-movies"},
      {"name": "English", "value": 2, "path": "/category/english-movies"},
      {"name": "Malayalam", "value": 3, "path": "/category/malayalam-movies"},
      {"name": "Telugu", "value": 4, "path": "/category/telugu-movies"},
      {"name": "Kannada", "value": 5, "path": "/category/kannada-movies"},
      {"name": "Hindi", "value": 6, "path": "/category/hindi-movies"}
    ];
    String language = languages[(lang ?? 1) - 1]['name'];
    Random random = Random();
    Movie? banner = currentContents['movies']
        ?[random.nextInt(currentContents['movies']?.length ?? 4)];
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    List<Movie> watchList = getWatchhList();
    bool isWatchList = checkMovieInWatchList(banner?.name ?? "");

    print(watchList.length);
    print(isWatchList);

    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 17, 0, 17),
            child: currentContents.isEmpty
                ? const CircularProgressIndicator(
                    color: Color.fromARGB(255, 123, 2, 154))
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: currentContents['movies']!.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: banner?.photo ?? "",
                                    width: isDesktop
                                        ? MediaQuery.of(context).size.width / 2
                                        : MediaQuery.of(context).size.width,
                                    height: isDesktop
                                        ? MediaQuery.of(context).size.height /
                                            1.3
                                        : MediaQuery.of(context).size.height /
                                            1.7,
                                    fit: BoxFit.fitWidth,
                                    // alignment: Alignment.topRight,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: const Color.fromARGB(
                                          71, 224, 224, 224),
                                      highlightColor: const Color.fromARGB(
                                          70, 245, 245, 245),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.7,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: isDesktop
                                        ? MediaQuery.of(context).size.height /
                                            1.3
                                        : MediaQuery.of(context).size.height /
                                            1.7,
                                    decoration: BoxDecoration(
                                        gradient: isDesktop
                                            ? const LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                    Color.fromARGB(
                                                        255, 17, 0, 17),
                                                    Color.fromARGB(
                                                        255, 17, 0, 17),
                                                    Color.fromARGB(
                                                        17, 30, 0, 31),
                                                  ])
                                            : const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                    Color.fromARGB(
                                                        162, 30, 0, 31),
                                                    Color.fromARGB(
                                                        140, 52, 0, 56),
                                                    Color.fromARGB(
                                                        188, 25, 0, 23),
                                                    Color.fromARGB(
                                                        255, 17, 0, 17)
                                                  ])),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: isDesktop
                                        ? MediaQuery.of(context).size.height /
                                                1.3 +
                                            5
                                        : MediaQuery.of(context).size.height /
                                            1.7,
                                    decoration: BoxDecoration(
                                        gradient: isDesktop
                                            ? const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                    Color.fromARGB(
                                                        150, 17, 0, 17),
                                                    Color.fromARGB(
                                                        255, 17, 0, 17),
                                                  ])
                                            : const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                    Color.fromARGB(
                                                        0, 17, 0, 17),
                                                    Color.fromARGB(
                                                        255, 17, 0, 17),
                                                  ])),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.7,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GradientText(banner?.name ?? "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isDesktop ? 40 : 26,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 116, 0, 205),
                                                  Color.fromARGB(
                                                      255, 165, 0, 174)
                                                ])),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(),
                                          transform: Matrix4.skewX(-0.1),
                                          child: GradientText(
                                            banner?.description ?? "",
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                            gradient:
                                                const LinearGradient(colors: [
                                              Color.fromARGB(
                                                  255, 254, 245, 255),
                                              Color.fromARGB(255, 120, 82, 125)
                                            ]),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              banner?.year ?? "",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 74, 74, 74),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            const Text(
                                              "•",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 74, 74, 74),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              banner?.duration ?? "",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 74, 74, 74),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            const Text(
                                              "•",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 74, 74, 74),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              banner?.language ?? "",
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 74, 74, 74),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 25),
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          Color.fromARGB(
                                                              255, 158, 0, 164),
                                                          Color.fromARGB(
                                                              255, 84, 0, 88)
                                                        ])),
                                                child: const GradientText(
                                                  "Watch Now",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 254, 245, 255),
                                                        Color.fromARGB(
                                                            255, 120, 82, 125)
                                                      ]),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            !isWatchList
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      await addToWatchhList(
                                                          banner!);
                                                      setState(() {
                                                        watchList =
                                                            getWatchhList();
                                                      });
                                                    },
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                                vertical: 13,
                                                                horizontal: 13),
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    const BorderRadius.all(
                                                                        Radius.circular(
                                                                            50)),
                                                                border:
                                                                    Border.all(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      118,
                                                                      137,
                                                                      0,
                                                                      158),
                                                                  width: 1,
                                                                ),
                                                                color: const Color
                                                                    .fromARGB(
                                                                    31,
                                                                    59,
                                                                    0,
                                                                    61)),
                                                        child: const HugeIcon(
                                                            icon: HugeIcons
                                                                .strokeRoundedAdd01,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    109,
                                                                    0,
                                                                    115))),
                                                  )
                                                : const SizedBox()
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Text(
                                  "Latest Movies",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                              HorizontalScrollList(
                                  currentContents: currentContents['movies']!),
                              const SizedBox(
                                height: 50,
                              ),
                              currentContents['series']!.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: Text(
                                            "Latest Series",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          ),
                                        ),
                                        HorizontalScrollList(
                                            currentContents:
                                                currentContents['series']!),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          )
                        : const SizedBox(),
                  )));
  }
}
