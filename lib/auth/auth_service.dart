import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailAndPassword(String name, String email, String password) async {
    return await _supabase.auth.signUp(
      data: {'name': name},
      password: password,
      email: email,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  // get user name
  String? getCurrentUserName() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.userMetadata?['name'] as String?;
  }

  // get user id
  String? getCurrentUserId() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.id;
  }
}
