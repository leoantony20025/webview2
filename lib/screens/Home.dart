import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/providers/AppProvider.dart';

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
    Movie? banner = currentContents['movies']?[0];

    print(currentContents['movies']?[0]?.name ?? "hi");

    return Scaffold(
        body: currentContents.isEmpty
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color.fromARGB(255, 23, 0, 28),
                      Colors.black
                    ])),
                child: const CircularProgressIndicator(
                    color: Color.fromARGB(255, 123, 2, 154)),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.topLeft,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color.fromARGB(255, 23, 0, 28),
                      Colors.black
                    ])),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: banner?.photo ?? "",
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.7,
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(71, 224, 224, 224),
                              highlightColor:
                                  const Color.fromARGB(70, 245, 245, 245),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 1.7,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height:
                                MediaQuery.of(context).size.height / 1.7 + 5,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Color.fromARGB(219, 30, 0, 31),
                                  Color.fromARGB(75, 52, 0, 56),
                                  Color.fromARGB(188, 25, 0, 23),
                                  Color.fromARGB(229, 25, 0, 23),
                                  Colors.black
                                ])),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 1.7,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner?.name ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  child: Text(
                                    banner?.description ?? "",
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      banner?.year ?? "",
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 74, 74, 74),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      banner?.language ?? "",
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 74, 74, 74),
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
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 25),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color.fromARGB(255, 44, 0, 70),
                                              Color.fromARGB(255, 39, 0, 41)
                                            ])),
                                    child: const Text(
                                      "Watch Now",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              221, 246, 229, 255)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ));
  }
}
