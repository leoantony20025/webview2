import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  late int lang;

  AppProvider({required this.lang});

  void updateLang(int language) {
    lang = language;
    notifyListeners();
  }
}
