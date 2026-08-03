import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konnectai/app/router/app_routes.dart';
import 'package:konnectai/core/theme/app_themes.dart';
import 'package:konnectai/features/chats/presentation/pages/chats_page.dart';
import 'package:konnectai/features/home/presentation/pages/home_page.dart';
import 'package:konnectai/features/library/presentation/pages/library_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
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
      _selectedIndex = widget.initialIndex;
    }
  }

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        context.go(AppPaths.home);
        break;
      case 1:
        context.go(AppPaths.chats);
        break;
      case 2:
        context.go(AppPaths.library);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pages = <Widget>[
      const HomePage(),
      const ChatsPage(),
      const LibraryPage(),
    ];

    return Scaffold(
      backgroundColor: colors.surface,
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: colors.card,
        indicatorColor: colors.primary.withOpacity(0.14),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_rounded),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
