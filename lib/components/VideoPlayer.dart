import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:theater/AppColors.dart';

class VideoPlayer extends StatefulWidget {
  String url;
  Player player;
  VideoController controller;
  VideoPlayer(
      {super.key,
      required this.url,
      required this.controller,
      required this.player});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  int currentServerIndex = 0;
  late FocusNode fnPlayer;
  late FocusNode fnPlayPauseButton;
  late FocusNode fnFullscreenButton;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    fnPlayer = FocusNode();
    widget.player.open(Media(widget.url));
    fnPlayPauseButton = FocusNode();
    fnFullscreenButton = FocusNode();
  }

  @override
  void dispose() {
    fnPlayer.dispose();
    fnPlayPauseButton.dispose();
    fnFullscreenButton.dispose();
    // widget.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void togglePlayPause() {
      if (widget.player.state.playing) {
        widget.player.pause();
      } else {
        widget.player.play();
      }
    }

    return Container(
        // width: MediaQuery.of(context).size.width,
        alignment: Alignment.topLeft,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 2 - 30,
          height: 350,
          child: Stack(
            children: [
              Focus(
                focusNode: fnPlayer,
                onFocusChange: (value) => setState(() {}),
                child: InkWell(
                  onTap: () {
                    togglePlayPause();
                  },
                  onDoubleTap: () {
                    // toggleFullscreen(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: fnPlayer.hasFocus
                          ? Border.all(width: 2, color: AppColors.borderTV)
                          : Border.all(width: 0, color: Colors.transparent),
                    ),
                    child: Video(
                      controller: widget.controller,
                      fit: BoxFit.cover,
                      fill: const Color.fromARGB(255, 20, 0, 22),
                      controls: MaterialVideoControls,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
