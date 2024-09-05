import 'package:dns_client/dns_client.dart';
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
      title: 'Movierulz',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 44, 44)),
        useMaterial3: true,
        highlightColor: const Color.fromARGB(255, 1, 46, 45),
        splashColor: const Color.fromARGB(255, 0, 24, 23),
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 23, 22),
      ),
      debugShowCheckedModeBanner: false,
      home: const Main(),
    );
  }
}
