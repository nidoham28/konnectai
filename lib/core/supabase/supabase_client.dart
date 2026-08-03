import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const supabaseUrl = 'https://mfjrgxxksywxwnjynmaz.supabase.co';
  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1manJneHhrc3l3eHduanlubWF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU3NDg1MDUsImV4cCI6MjEwMTMyNDUwNX0.l3NXoNIGsUURyoGFfnrYtqlIq1NPiu9VR0PKSF37N0E';
}

class AppSupabase {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
