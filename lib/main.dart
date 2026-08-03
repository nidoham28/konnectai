import 'package:flutter/material.dart';
import 'package:konnectai/app/app.dart';
import 'package:konnectai/core/supabase/supabase_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSupabase.initialize();
  runApp(const KonnectAIApp());
}
