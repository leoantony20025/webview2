import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:theater/models/Movie.dart';

class HorizontalScrollList extends StatelessWidget {
  final List<Movie?> currentContents;
  const HorizontalScrollList({super.key, required this.currentContents});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: currentContents.map<Widget>((movie) {
          return movie?.photo != ""
              ? Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: CachedNetworkImage(
                    imageUrl: movie?.photo ?? "",
                    imageBuilder: (context, imageProvider) => Container(
                      width: 150,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Shimmer.fromColors(
                      direction: ShimmerDirection.ltr,
                      enabled: true,
                      loop: 5,
                      baseColor: const Color.fromARGB(71, 224, 224, 224),
                      highlightColor: const Color.fromARGB(70, 245, 245, 245),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.7,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                )
              : SizedBox();
        }).toList(),
      ),
    );
  }
}
