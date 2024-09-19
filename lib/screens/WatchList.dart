// import 'package:flutter/material.dart';
// import 'package:theater/components/WatchList.dart';
// import 'package:theater/models/Movie.dart';

// class WatchList extends StatefulWidget {
//   final List<Movie> watchlist;

//   const WatchList({super.key, required this.watchlist});

//   @override
//   State<WatchList> createState() => _WatchListState();
// }

// class _WatchListState extends State<WatchList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromARGB(255, 23, 0, 28),
//               Colors.black,
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(30.0),
//           child: WatchListComponent(watchlist: widget.watchlist),
//         ),
//       ),
//     );
//   }
// }
