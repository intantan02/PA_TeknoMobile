import 'package:flutter/material.dart';
import 'favorite_page.dart';
import 'rekomendasi_page.dart';
import 'konversi_waktu_page.dart';
import 'profile_page.dart';
import 'konversi_mata_uang_page.dart';
import 'feedback_page.dart';
import 'location_page.dart';
import '../../../services/auth_service.dart';
import '../../../models/user.dart';

class _MenuItem {
  final String title;
  final IconData icon;
  final Widget page;

  _MenuItem(this.title, this.icon, this.page);
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  User? _currentUser;

  final List<_MenuItem> menuItems = [
    _MenuItem('Rekomendasi Buku', Icons.book, RekomendasiPage()),
    _MenuItem('Konversi Waktu', Icons.access_time, KonversiWaktuPage()),
    _MenuItem('Favorit', Icons.favorite, FavoritePage()),
    _MenuItem('Konversi Mata Uang', Icons.attach_money, KonversiMataUangPage()),
    _MenuItem('Saran & Kesan', Icons.feedback, FeedbackPage()),
    _MenuItem('Lokasi Saya', Icons.location_on, LocationPage()),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUser = user as User?;
    });
  }

  void _logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _currentUser != null
        ? 'Selamat datang, ${_currentUser!.username}'
        : 'Selamat Datang di Aplikasi BIRU';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(
          greeting,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            tooltip: 'Lihat Profil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: menuItems.map((item) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => item.page),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item.icon, size: 50, color: Colors.blue[800]),
                          SizedBox(height: 10),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
