import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konnectai/app/router/app_routes.dart';
import 'package:konnectai/core/theme/app_themes.dart';
import 'package:konnectai/features/chats/presentation/pages/chats_page.dart';
import 'package:konnectai/features/home/presentation/pages/home_page.dart';
import 'package:konnectai/features/profile/presentation/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  // NOTE: requires an AppPaths.profile entry in app_routes.dart (replacing
  // AppPaths.library) for context.go(...) below to resolve.
  static final _paths = [AppPaths.home, AppPaths.chats, AppPaths.profile];

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant MainNavigationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() => _selectedIndex = widget.initialIndex);
    }
  }

  void _onDestinationSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    context.go(_paths[index]);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomePage(),
          ChatsPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: colors.card,
        indicatorColor: colors.primary.withOpacity(0.14),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}