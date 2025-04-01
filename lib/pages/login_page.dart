import 'package:capcynfoods/auth/auth_service.dart';
import 'package:capcynfoods/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // get from authService
  final authService = AuthService();
  bool _isPasswordHidden = true;

  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // login button pressed function
  void login() async {
    // prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    // attemps
    try {
      await authService.signInWithEmailAndPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error : $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Login')),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3-.0),
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              label: const Text('Email'),
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: _isPasswordHidden,
            decoration: InputDecoration(
              label: const Text('Password'),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          ElevatedButton(
            onPressed: login,
            child: const Text('Login'),
          ),
          SizedBox(height: 12.0),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            ),
            child: Center(child: Text("dont have an account? sign up")),
          ),
        ],
      ),
    );
  }
}
