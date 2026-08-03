import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konnectai/app/router/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => context.goNamed(AppRouteNames.about),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to KonnectAI'),
            const SizedBox(height: 16),
            const Text('You are signed in and ready to go.'),
          ],
        ),
      ),
    );
  }
}
