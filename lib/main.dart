import 'package:flutter/material.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/home/home_page.dart';
import 'screens/profile/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rekomendasi Buku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}