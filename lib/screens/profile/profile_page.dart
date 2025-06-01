import 'package:flutter/material.dart';
import 'dart:convert'; // Tambahkan ini
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../utils/session_manager.dart';
import 'feedback_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userJson = await SessionManager.getUser();
    setState(() {
      _user = userJson != null ? User.fromJson(jsonDecode(userJson)) : null;
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _navigateToFeedback() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FeedbackPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profil')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                _user!.username.isNotEmpty ? _user!.username[0].toUpperCase() : '',
                style: TextStyle(fontSize: 40),
              ),
            ),
            SizedBox(height: 16),
            Text(
              _user!.username,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
                _user!.email ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navigateToFeedback,
              icon: Icon(Icons.feedback),
              label: Text('Kirim Feedback'),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}