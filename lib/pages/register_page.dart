import 'package:capcynfoods/components.dart';
import 'package:capcynfoods/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // get from authService
  final authService = AuthService();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // login button pressed function
  void signUp() async {
    // prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // check match of passwords
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    // attemps to register
    try {
      await authService.signUpWithEmailAndPassword(email, password);
      Navigator.pop(context);
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
        title: Text('Sign Up'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              label: const Text('Email'),
            ),
          ),
          TextPassword(
            controller : _passwordController,
            isPasswordHidden: _isPasswordHidden,
            onPasswordTapped: () {
              setState(() {
                _isPasswordHidden = !_isPasswordHidden;
              });
            },
            label: 'Password',
          ),
          TextPassword(
            controller : _confirmPasswordController,
            isPasswordHidden: _isConfirmPasswordHidden,
            onPasswordTapped: () {
              setState(() {
                _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
              });
            },
            label: 'Confirm Password',
          ),
          SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: signUp,
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
