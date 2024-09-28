import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:theater/components/GradientText.dart';
import 'package:theater/models/Movie.dart';
import 'package:theater/prefs.dart';

class Play extends StatefulWidget {
  Map<String, dynamic> content;
  Play({super.key, required this.content});

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  late final player = Player();
  late final controller = VideoController(player);
  int currentServerIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    player.open(Media(widget.content['servers'][currentServerIndex]));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;
    bool isWatchList = checkMovieInWatchList(widget.content['name'] ?? "");
    Iterable<Map<String, String?>> cast = widget.content['cast'];
    List<dynamic> videos = widget.content['servers'];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 0, 17),
      body: SingleChildScrollView(
        child: Stack(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: CachedNetworkImage(
              imageUrl: widget.content['poster'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromARGB(162, 30, 0, 31),
                  Color.fromARGB(140, 52, 0, 56),
                  Color.fromARGB(188, 25, 0, 23),
                  Color.fromARGB(255, 17, 0, 17)
                ])),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color.fromARGB(0, 17, 0, 17),
                  Color.fromARGB(255, 17, 0, 17),
                ])),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(23, 200, 0, 210),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            )),
                        const HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowLeft01,
                            color: Color.fromARGB(255, 240, 108, 255)),
                      ]),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        // width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topLeft,
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: 400,
                          child: Stack(
                            children: [
                              MaterialVideoControlsTheme(
                                normal: const MaterialVideoControlsThemeData(
                                  seekBarThumbColor:
                                      Color.fromARGB(255, 124, 0, 130),
                                  seekBarPositionColor:
                                      Color.fromARGB(255, 151, 0, 168),
                                  seekOnDoubleTap: true,
                                  backdropColor: Color.fromARGB(214, 22, 0, 23),
                                  brightnessGesture: true,
                                  displaySeekBar: true,
                                  gesturesEnabledWhileControlsVisible: true,
                                  horizontalGestureSensitivity: 3,
                                  seekBarColor: Color.fromARGB(141, 43, 0, 35),
                                  seekBarBufferColor:
                                      Color.fromARGB(63, 240, 124, 255),
                                  seekBarThumbSize: 7,
                                  seekGesture: true,
                                  seekBarMargin: EdgeInsets.all(8),
                                  seekOnDoubleTapEnabledWhileControlsVisible:
                                      true,
                                  speedUpOnLongPress: true,
                                  volumeGesture: true,
                                  visibleOnMount: true,
                                  // bottomButtonBar: [
                                  //   Spacer(),
                                  //   MaterialDesktopPlayOrPauseButton(),
                                  //   Spacer(),
                                  // ],
                                ),
                                fullscreen:
                                    const MaterialVideoControlsThemeData(),
                                child: Video(
                                  controller: controller,
                                  fit: BoxFit.cover,
                                  fill: const Color.fromARGB(255, 20, 0, 22),
                                  filterQuality: FilterQuality.high,
                                  controls: MaterialVideoControls,
                                ),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(
                      width: 50,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GradientText(widget.content['name'] ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isDesktop ? 40 : 26,
                                fontWeight: FontWeight.bold,
                              ),
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromARGB(255, 116, 0, 205),
                                    Color.fromARGB(255, 165, 0, 174)
                                  ])),
                          const SizedBox(
                            height: 10,
                          ),
                          GradientText(
                            widget.content['description'].toString().trim(),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(255, 254, 245, 255),
                              Color.fromARGB(255, 120, 82, 125)
                            ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                widget.content['year'] ?? "",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 74, 74, 74),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                "•",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 74, 74, 74),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                widget.content['duration'] ?? "",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 74, 74, 74),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              const Text(
                                "•",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 74, 74, 74),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                widget.content['language'] ?? "",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 74, 74, 74),
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
                              children: videos.asMap().entries.map((e) {
                            String index = (e.key + 1).toString();
                            bool isCurrent = e.key == currentServerIndex;

                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                  color: isCurrent
                                      ? Color.fromARGB(108, 248, 248, 248)
                                      : Color.fromARGB(66, 166, 166, 166),
                                  borderRadius: BorderRadius.circular(8)),
                              child: TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      currentServerIndex = e.key;
                                    });
                                    print("serverrrr key" + e.key.toString());
                                    print("serverrrr media " +
                                        widget.content['servers'][e.key]);
                                    await player.stop();
                                    await player.open(Media(
                                        widget.content['servers'][e.key]));
                                    print("serverrrr current " +
                                        controller.player.state.playlist.medias
                                            .toString());
                                  },
                                  child: Text(
                                    "Server $index",
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(210, 208, 208, 208)),
                                  )),
                            );
                          }).toList()),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              !isWatchList
                                  ? GestureDetector(
                                      onTap: () async {
                                        await addToWatchhList(Movie(
                                            name: widget.content['name'],
                                            description: widget.content['desc'],
                                            photo: widget.content['photo'],
                                            language:
                                                widget.content['language'],
                                            url: widget.content['url'],
                                            duration:
                                                widget.content['duration'],
                                            year: widget.content['year']));
                                        setState(() {
                                          isWatchList = true;
                                        });
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    52, 137, 0, 158),
                                                width: 1,
                                              ),
                                              color: const Color.fromARGB(
                                                  70, 83, 2, 117)),
                                          child: const Row(
                                            children: [
                                              HugeIcon(
                                                  icon: HugeIcons
                                                      .strokeRoundedPlusSign,
                                                  color: Color.fromARGB(
                                                      255, 140, 0, 175)),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Text(
                                                "Add to Watchlist",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 157, 0, 196)),
                                              ),
                                            ],
                                          )),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Cast",
                            style: TextStyle(
                                color: Color.fromARGB(117, 192, 192, 192),
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: cast.map(
                                (e) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https:${e['photo']!}"),
                                            fit: BoxFit.cover)),
                                  );
                                },
                              ).toList(),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
