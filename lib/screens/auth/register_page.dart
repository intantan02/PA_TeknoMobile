import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController(); // Tambahkan controller email
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim(); // Ambil email
    final password = _passwordController.text;
    final registered = await _authService.register(username, email, password); // Kirim email

    setState(() {
      _isLoading = false;
    });

    if (registered) {
      setState(() {
        _successMessage = 'Registrasi berhasil! Silakan login.';
      });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });
    } else {
      setState(() {
        _errorMessage = 'Username sudah terdaftar. Gunakan username lain.';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose(); // Dispose email controller
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
                    controller: _emailController, // Tambahkan field email
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Masukkan email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan password';
                      }
                      if (value.length < 6) {
                        return 'Password minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan konfirmasi password';
                      }
                      if (value != _passwordController.text) {
                        return 'Password tidak cocok';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (_successMessage != null)
                    Text(
                      _successMessage!,
                      style: const TextStyle(color: Colors.green),
                    ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _register,
                      child: const Text('Register'),
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text('Sudah punya akun? Login di sini'),
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