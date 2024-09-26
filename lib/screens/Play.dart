import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class Play extends StatefulWidget {
  Map<String, dynamic> content;
  Play({super.key, required this.content});

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.topLeft,
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
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: const HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowLeft02,
                        color: Colors.white),
                  ),
                ),
                Text(
                  widget.content?['description'] ?? "Desc",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          )),
    );
  }
}
