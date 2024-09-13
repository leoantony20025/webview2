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
    // final dns = DnsOverHttps.google();
    // final response = dns.lookup('tamilian.io');
    return MaterialApp(
      title: 'Theatre',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 44, 0, 44)),
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
