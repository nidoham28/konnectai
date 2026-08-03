import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:konnectai/app/router/app_routes.dart';
import 'package:konnectai/core/supabase/supabase_client.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _resolveNextRoute();
  }

  Future<void> _resolveNextRoute() async {
    if (_hasNavigated) return;

    try {
      await Future.wait([
        Future.delayed(const Duration(milliseconds: 2500)),
        Future.value(null),
      ]);

      if (!mounted) return;

      final hasActiveSession =
          AppSupabase.client.auth.currentSession != null &&
          AppSupabase.client.auth.currentUser != null;

      _hasNavigated = true;
      if (hasActiveSession) {
        context.goNamed(AppRouteNames.home);
      } else {
        context.goNamed(AppRouteNames.auth);
      }
    } catch (_) {
      if (!mounted) return;
      _hasNavigated = true;
      context.goNamed(AppRouteNames.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/app_icon.svg',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            const Text(
              'KonnectAI',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Preparing your experience...'),
          ],
        ),
      ),
    );
  }
}
