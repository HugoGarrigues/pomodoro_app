import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://nwucynzahevwjnhpvrqs.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53dWN5bnphaGV2d2puaHB2cnFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIzOTUzOTcsImV4cCI6MjA2Nzk3MTM5N30.7PcVUV0V5_ILjeJ2k9bGb_RymW99wDT64i7kmFLLnH4',
    );
  }

  static Session? get currentSession => client.auth.currentSession;

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }
}
