import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theater/components/BannerHome.dart';
import 'package:theater/components/HorizontalScrollList.dart';
import 'package:theater/models/Movie.dart';
// import 'package:theater/prefs.dart';
import 'package:theater/providers/AppProvider.dart';
import 'package:theater/screens/PlayAndroid.dart';
import 'package:theater/services/appService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  late FocusNode fnTop;
  Random random = Random();
  late int randomIndex = 4;

  @override
  void initState() {
    super.initState();

    fnTop = FocusNode();
    randomIndex = random.nextInt(4);
  }

  @override
  void dispose() {
    super.dispose();
    fnTop.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: true);
    Map<String, List<Movie?>> currentContents = appProvider.currentContents;
    // Movie? banner = currentContents['movies']?[randomIndex];
    // double screenWidth = MediaQuery.of(context).size.width;
    // bool isDesktop = screenWidth > 800;
    // bool isWatchList = checkMovieInWatchList(banner?.name ?? "");

    void setIsLoading(bool load) {
      setState(() {
        isLoading = load;
      });
    }

    fetchContent(Movie movie) async {
      setIsLoading(true);
      Map<String, dynamic> content = await fetchMovieContent(movie.url);
      setIsLoading(false);
      // Navigator.of(context).push(MaterialPageRoute(
      //   builder: (context) => defaultTargetPlatform == TargetPlatform.android
      //       ? PlayAndroid(
      //           content: {
      //             'name': movie.name,
      //             'desc': movie.description,
      //             'photo': movie.photo,
      //             'url': movie.url,
      //             'year': movie.year,
      //             'duration': movie.duration,
      //             'language': movie.language,
      //             ...content
      //           },
      //         )
      //       : PlayAndroid(
      //           content: {
      //             'name': movie.name,
      //             'desc': movie.description,
      //             'photo': movie.photo,
      //             'url': movie.url,
      //             'year': movie.year,
      //             'duration': movie.duration,
      //             'language': movie.language,
      //             ...content
      //           },
      //         ),
      // ));
    }

    return Scaffold(
        body: Stack(children: [
      Container(
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
                      ? FocusTraversalGroup(
                          policy: OrderedTraversalPolicy(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Focus(focusNode: fnTop, child: const SizedBox()),
                              BannerHome(fetchContent: fetchContent),
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
                                currentContents: currentContents['movies']!,
                                isLoading: isLoading,
                                setIsLoading: setIsLoading,
                              ),
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
                                              currentContents['series']!,
                                          isLoading: isLoading,
                                          setIsLoading: setIsLoading,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        )
                      : const SizedBox(),
                )),
      isLoading
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                child: const CircularProgressIndicator(
                  color: Color.fromARGB(255, 146, 0, 159),
                ),
              ),
            )
          : const SizedBox()
    ]));
  }
}
