import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/login_page.dart';
import '../pages/profile_page.dart';

/**
 * AUTH GATE - This will continuously listen for auth state changes
 *
 * -----
 *
 * unauthenticated -> login page
 * authenticated -> profile page
 */

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // Build appropriate widget page
      builder: (context, snapshot) {
        // loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),),
          );
        }
        // check if there is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if ( session != null ) {
          return const ProfilePage();
        } else {
          return const LoginPage();
        }

      },
    );
  }
}
