class Movie {
  String name;
  String photo;
  String language;
  String url;
  String duration;
  String year;

  Movie({
    required this.name,
    required this.photo,
    required this.language,
    required this.url,
    required this.duration,
    required this.year,
  });

  // Convert a Movie into a Map. The keys must correspond to the names of the
  // fields in your JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photo': photo,
      'language': language,
      'url': url,
      'duration': duration,
      'year': year,
    };
  }

  // Convert a Map into a Movie. The keys must correspond to the names of the
  // fields in your JSON.
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'],
      photo: json['photo'],
      language: json['language'],
      url: json['url'],
      duration: json['duration'],
      year: json['year'],
    );
  }
}
