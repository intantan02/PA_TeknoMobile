import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';
import 'models/book.dart';
import 'models/usersession.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/home/home_page.dart';
import 'screens/home/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters (pastikan file book.g.dart, user.g.dart, usersession.g.dart sudah di-generate)
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(UserSessionAdapter());

  // Buka box utama agar tidak error saat akses box di awal aplikasi
  await Hive.openBox<User>('users');
  await Hive.openBox<Book>('favorite_books');
  await Hive.openBox<UserSession>('user_session');

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
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}