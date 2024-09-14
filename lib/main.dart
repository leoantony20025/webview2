import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:theater/prefs.dart';
import 'screens/Main.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initPref();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theater',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 44, 0, 44)),
        useMaterial3: true,
        highlightColor: const Color.fromARGB(255, 31, 1, 46),
        splashColor: const Color.fromARGB(255, 22, 0, 24),
        scaffoldBackgroundColor: const Color.fromARGB(255, 21, 0, 23),
      ),
      debugShowCheckedModeBanner: false,
      home: const Main(),
    );
  }
}
