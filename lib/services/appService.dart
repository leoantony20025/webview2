import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:theater/models/Movie.dart';

final dio = Dio();
String baseUrl = "https://bolly2tolly.land";
List languages = [
  {"name": "Tamil", "value": 1, "path": "/category/tamil-movies"},
  {"name": "English", "value": 2, "path": "/category/english-movies"},
  {"name": "Malayalam", "value": 3, "path": "/category/malayalam-movies"},
  {"name": "Telugu", "value": 4, "path": "/category/telugu-movies"},
  {"name": "Kannada", "value": 5, "path": "/category/kannada-movies"},
  {"name": "Hindi", "value": 6, "path": "/category/hindi-movies"}
];

Future<Map<String, List<Movie?>>> fetchContents(int lang) async {
  String url = lang == 0
      ? baseUrl
      : '${baseUrl + languages[lang - 1]['path']}?tr_post_type=1';
  final res = await dio.get(url);

  var document = HtmlParser(res.data).parse();
  var ul = document.querySelector('.MovieList');
  var lis = ul?.querySelectorAll('li');
  List<Movie> movies = [];

  for (var li in lis!) {
    var desc = li.querySelector('.Description p')?.text.split(',') ?? [""];
    desc.removeAt(0);
    var movie = Movie(
      name: li.querySelector('.Title')?.text.split('(')[0] ?? "",
      description: desc.join(),
      photo: li
              .querySelector('.attachment-thumbnail')
              ?.attributes['src']
              .toString() ??
          "", // No Image Found -------------------------------------------
      language: "Tamil",
      url: li.querySelector('a')?.attributes['href'].toString() ?? "",
      duration: li.querySelector('.Time')?.text ?? "",
      year: li.querySelector('.Title')?.text.split('(')[1].split(')')[0] ?? "",
    );
    movies.add(movie);
  }

  String urlSeries = lang == 0
      ? baseUrl
      : '${baseUrl + languages[lang - 1]['path']}?tr_post_type=2';
  final res2 = await dio.get(urlSeries);

  var documentSeries = HtmlParser(res2.data).parse();
  var ulSeries = documentSeries.querySelector('.MovieList');
  var liseries = ulSeries?.querySelectorAll('li');
  List<Movie> series = [];

  if (liseries != null) {
    for (var li in liseries) {
      var serie = Movie(
        name: li.querySelector('.Title')?.text ?? "",
        description: li.querySelector('.Description p')!.text,
        photo: li
                .querySelector('.attachment-thumbnail')
                ?.attributes['src']
                .toString() ??
            "", // No Image Found -------------------------------------------
        language: "Tamil",
        url: li.querySelector('a')?.attributes['href'].toString() ?? "",
        duration: li.querySelector('.Time')?.text ?? "",
        year: li.querySelector('.Title')?.text ?? "",
      );
      series.add(serie);
    }
  }

  print(series.isNotEmpty ? series[0].name : "No");

  return {"movies": movies, "series": series};
}

Future<Map<String, List<Movie?>>> fetchLatestContents() async {
  final res = await dio.get(baseUrl);

  var document = HtmlParser(res.data).parse();
  var ul = document.querySelectorAll('.MovieList li');
  List<Movie> movies = [];

  for (var li in ul) {
    var movie = Movie(
      name: li.querySelector('.Title')?.text.split('(')[0] ?? "",
      description: li
              .querySelector('.Description > p')
              ?.text
              .split(' ')
              .removeAt(0)
              .splitMapJoin(' ') ??
          "d",
      photo: li
              .querySelector('.attachment-thumbnail')
              ?.attributes['src']
              .toString() ??
          "",
      language: "Tamil",
      url: li.querySelector('a')?.attributes['href'].toString() ?? "",
      duration: li.querySelector('.Time')?.text ?? "",
      year: li.querySelector('.Title')?.text.split('(')[1].split(')')[0] ?? "",
    );
    movies.add(movie);
  }

  print(movies[0].description);

  return {"movies": movies, "series": movies};
}

Future fetchMovieContent(String url) async {
  var res = await dio.get(url);
  if (res.statusCode == 200) {
    var data = HtmlParser(res.data).parse();
    var desc = data.querySelector('.Description p')?.text.split(',') ?? [""];
    Iterable<Map<String, String?>> cast =
        data.querySelectorAll(".ListCast li").asMap().entries.map(
      (e) {
        return {
          "name": e.value.querySelector("figcaption")?.text ?? "No",
          "photo": e.value.querySelector("img")?.attributes['src'],
          "url": e.value.querySelector("a")?.attributes['href']
        };
      },
    );
    Iterable<String> servers =
        data.querySelectorAll(".TPlayerTb").asMap().entries.map(
      (e) {
        return e.value.innerHtml.toString().split("src=\"")[1].split("\"")[0] ??
            "No Server";
      },
    );

    Map<String, dynamic> content = {
      "poster": data.querySelector(".TPostBg")?.attributes['src'],
      "description": desc.join(),
      "cast": cast,
      "servers": servers
    };

    print("serverrrrrrrrr " + content!['servers'].toString());

    return content;
  }
}

// Future<dynamic> fetchLatestMovies() async {
//   return await fetchMovies("https://bolly2tolly.land");
// }

// Future<dynamic> fetchTamilMovies() async {
//   return await fetchMovies("https://bolly2tolly.land/category/tamil-movies");
// }

// Future<dynamic> fetchEnglishMovies() async {
//   return await fetchMovies("https://bolly2tolly.land/category/english-movies");
// }

// Future<dynamic> fetchMalayalamMovies() async {
//   return await fetchMovies(
//       "https://bolly2tolly.land/category/malayalam-movies");
// }

// Future<dynamic> fetchTeluguMovies() async {
//   return await fetchMovies("https://bolly2tolly.land/category/telugu-movies");
// }

// Future<dynamic> fetchKannadaMovies() async {
//   return await fetchMovies("https://bolly2tolly.land/category/kannada-movies");
// }

// Future<dynamic> fetchHindiMovies() async {
//   return await fetchMovies("https://bolly2tolly.land/category/hindi-movies");
// }
