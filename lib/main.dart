import 'package:flutter/material.dart';
import 'screens/Main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      title: 'Movierulz',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 37, 60)),
          useMaterial3: true,
          highlightColor: const Color.fromARGB(255, 0, 31, 53),
          splashColor: const Color.fromARGB(255, 0, 17, 34),
          scaffoldBackgroundColor: const Color.fromARGB(255, 0, 31, 51)),
      debugShowCheckedModeBanner: false,
      home: const Main(),
    );
  }
}
