import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final success = await _authService.login(username, password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Login gagal: username atau password salah.';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Masukkan username' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Masukkan password' : null,
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text('Belum punya akun? Daftar di sini'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
