import 'package:flutter/material.dart';

class TextPassword extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordHidden;
  final VoidCallback onPasswordTapped;
  final String label;

  const TextPassword({
    super.key,
    required this.controller,
    required this.isPasswordHidden,
    required this.onPasswordTapped,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPasswordHidden,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordHidden ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onPasswordTapped,
        ),
      ),
    );
  }
}

class CustomDateTimeNow extends StatelessWidget {
  const CustomDateTimeNow({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = '${now.day} ${_getMonthName(now.month)} ${now.year}';
    return Text(formattedDate);
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}