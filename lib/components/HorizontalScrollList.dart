import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:theater/components/GradientText.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';

class HorizontalScrollList extends StatefulWidget {
  final List<Movie?> currentContents;
  const HorizontalScrollList({super.key, required this.currentContents});

  @override
  _HorizontalScrollListState createState() => _HorizontalScrollListState();
}

class _HorizontalScrollListState extends State<HorizontalScrollList> {
  int? activeIndex;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.currentContents.asMap().entries.map<Widget>((entry) {
          int index = entry.key;
          Movie? movie = entry.value;
          movie?.description = movie!.description.trimLeft();
          bool isWatchList = checkMovieInWatchList(movie?.name ?? "");

          return movie?.photo != ""
              ? GestureDetector(
                  onTap: () {
                    if (activeIndex == index) {
                      print("Tap");
                    } else {
                      setState(() {
                        activeIndex = index;
                      });
                    }
                  },
                  child: MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        activeIndex = null;
                      });
                    },
                    onHover: (event) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.only(left: 20),
                      width: activeIndex == index ? 500 : 150,
                      height: 250,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: movie?.photo ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              direction: ShimmerDirection.ltr,
                              enabled: true,
                              loop: 5,
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
                          if (activeIndex == index)
                            Positioned(
                              bottom: 0,
                              width: activeIndex == index ? 480 : 150,
                              height: 250,
                              child: Container(
                                alignment: Alignment.bottomLeft,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            162, 129, 1, 143),
                                        width: 3),
                                    gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(194, 30, 0, 40),
                                          Color.fromARGB(206, 44, 0, 44)
                                        ])),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 350,
                                      child: Text(
                                        movie?.name ?? "",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 300,
                                      padding: const EdgeInsets.only(),
                                      transform: Matrix4.skewX(-0.1),
                                      child: Text(
                                        movie?.description ?? "",
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                181, 255, 255, 255),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13,
                                                      horizontal: 13),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(50)),
                                                  border: Border.all(
                                                    color: const Color.fromARGB(
                                                        52, 137, 0, 158),
                                                    width: 1,
                                                  ),
                                                  color: const Color.fromARGB(
                                                      70, 83, 2, 117)),
                                              child: const HugeIcon(
                                                  icon: HugeIcons
                                                      .strokeRoundedPlay,
                                                  color: Color.fromARGB(
                                                      255, 140, 0, 175))),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        !isWatchList
                                            ? GestureDetector(
                                                onTap: () async {
                                                  await addToWatchhList(movie!);
                                                  setState(() {
                                                    isWatchList = true;
                                                  });
                                                },
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 13,
                                                        horizontal: 13),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    50)),
                                                        border: Border.all(
                                                          color: const Color
                                                              .fromARGB(
                                                              52, 137, 0, 158),
                                                          width: 1,
                                                        ),
                                                        color: const Color
                                                            .fromARGB(
                                                            70, 83, 2, 117)),
                                                    child: const HugeIcon(
                                                        icon: HugeIcons
                                                            .strokeRoundedPlayListAdd,
                                                        color: Color.fromARGB(
                                                            255, 140, 0, 175))),
                                              )
                                            : const SizedBox()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        }).toList(),
      ),
    );
  }
}
