import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:theater/models/Movie.dart';

late SharedPreferences prefs;

initPref() async {
  prefs = await SharedPreferences.getInstance();
}

Future<List<Movie>> getWishList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? jsonString = prefs.getString('wishList');

  if (jsonString != null) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => Movie.fromJson(json as Map<String, dynamic>))
        .toList();
  } else {
    return [];
  }
}

Future<void> saveWishList(List<Movie> wishList) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<Map<String, dynamic>> jsonList =
      wishList.map((movie) => movie.toJson()).toList();
  final String jsonString = jsonEncode(jsonList);
  await prefs.setString('wishList', jsonString);
}

Future<void> addToWishList(Movie movie) async {
  final List<Movie> wishList = await getWishList();
  if (!wishList.any((m) => m.name == movie.name)) {
    wishList.add(movie);
    await saveWishList(wishList);
  }
}

Future<void> removeFromWishList(Movie movie) async {
  final List<Movie> wishList = await getWishList();
  wishList.removeWhere((e) => e.url == movie.url);
  await saveWishList(wishList);
}
