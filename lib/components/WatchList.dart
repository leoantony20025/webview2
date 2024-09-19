import 'package:flutter/material.dart';
import 'package:theater/models/Movie.dart';

class WatchListComponent extends StatefulWidget {
  final List<Movie> watchList;
  const WatchListComponent({super.key, required this.watchList});

  @override
  State<WatchListComponent> createState() => _WatchListComponentState();
}

class _WatchListComponentState extends State<WatchListComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Watch List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Wrap(
          runSpacing: 20,
          spacing: 20,
          children: widget.watchList.map((movie) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width / 2) - 40,
              height: 250,
              child: Stack(children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: (MediaQuery.of(context).size.width / 2) - 40,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                        image: NetworkImage(movie.photo),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(70, 66, 0, 97),
                                Color.fromARGB(255, 19, 0, 21)
                              ])),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    movie.name,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      movie.language,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(73, 255, 255, 255),
                                          fontSize: 10),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      movie.year,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(73, 255, 255, 255),
                                          fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: const Color.fromARGB(95, 29, 0, 33),
                          border: Border.all(
                              color: const Color.fromARGB(255, 48, 0, 62),
                              width: 1)),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color.fromARGB(87, 249, 131, 255),
                      ),
                    ),
                  ),
                )
              ]),
            );
          }).toList(),
        ),
      ],
    );
  }
}
