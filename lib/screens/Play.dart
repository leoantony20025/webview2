import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class Play extends StatefulWidget {
  Map<String, dynamic> content;
  Play({super.key, required this.content});

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    player.open(Media(widget.content['servers'][0]));
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
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          width: 20,
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(77, 55, 0, 48),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 65, 0, 72))),
                        ),
                        const Positioned(
                          left: -15,
                          child: HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowLeft02,
                              color: Colors.white),
                        ),
                      ]),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 500,
                      child: Stack(
                        children: [Video(controller: controller)],
                      ),
                    )),
                Text(
                  widget.content['description'] ?? "Desc",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
