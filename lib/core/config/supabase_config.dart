import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  /// Supabase Project URL
  /// Replace with your actual project URL from Supabase Dashboard > Project Settings > API
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wbxqkojyvdhfffwloqmm.supabase.co',
  );

  /// Supabase Anon / Public Key
  /// Replace with your actual anon public key from Supabase Dashboard > Project Settings > API
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndieHFrb2p5dmRoZmZmd2xvcW1tIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTExOTIwODQsImV4cCI6MjEwNjc2ODA4NH0.lYfHCBGp4POFsIMGOF6t_2WAYHmB1wBnXGLfcfW40qM',
  );

  /// Shorthand to access the Supabase client
  static SupabaseClient get client => Supabase.instance.client;
}
