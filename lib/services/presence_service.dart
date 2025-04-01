import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';

class PresenceService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final AuthService _authService = AuthService();

  // sign to check in
  Future<void> signIn() async {
    String dateNow = DateTime.now().toString().split(' ')[0];
    String userId = _authService.getCurrentUserId() ?? "";
    final response = await _supabase
        .from('presences')
        .select()
        .eq('date', dateNow)
        .eq('user_id', userId);
    int countDataToday = response.length;
    bool isDateNowAndUserReady = countDataToday == 0 || countDataToday == null;
    if (!isDateNowAndUserReady) {
      return await _supabase
          .from('presences')
          .update({
            'start': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('date', dateNow);
    } else {
      return await _supabase
          .from('presences')
          .insert({'start': DateTime.now().toIso8601String(), 'date': dateNow, 'user_id': _authService.getCurrentUserId()});
    }
  }

  // sign to check out
  Future<void> signOut() async {
    String dateNow = DateTime.now().toString().split(' ')[0];
    String userId = _authService.getCurrentUserId() ?? "";

    return await _supabase
        .from('presences')
        .update({
          'end': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('date', dateNow);
  }

  // get sign in history today
  Future<Map<String, dynamic>> getHistoryToday() async {
    try {
      String userId = _authService.getCurrentUserId() ?? "";
      final response = await _supabase
          .from('presences')
          .select('start, end')
          .eq('user_id', userId)
          .order('start', ascending: false)
          .limit(1)
          .single();

      return response;
    } catch (e) {
      // Handle cases where no record exists
      return {};
    }
  }

  // get list history presences user
  Future<List<Map<String, dynamic>>> getListHistoryUser() async {
    try {
      String userId = _authService.getCurrentUserId() ?? "";
      final response = await _supabase
          .from('presences')
          .select('start, end')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response;
    } catch (e) {
      // Handle cases where no record exists
      return [];
    }
  }

}
