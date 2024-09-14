import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

initPref() async {
  prefs = await SharedPreferences.getInstance();
}
