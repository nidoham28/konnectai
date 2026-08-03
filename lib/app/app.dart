import 'package:flutter/material.dart';
import 'package:konnectai/app/router/app_router.dart';
import 'package:konnectai/core/theme/app_themes.dart';

class KonnectAIApp extends StatefulWidget {
  const KonnectAIApp({super.key});

  @override
  State<KonnectAIApp> createState() => _KonnectAIAppState();
}

class _KonnectAIAppState extends State<KonnectAIApp> {
  final ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KonnectAI',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
