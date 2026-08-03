import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:konnectai/app/router/app_routes.dart';
import 'package:konnectai/core/theme/app_themes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'KonnectAI',
          style: TextStyle(
            color: colors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none_rounded, color: colors.textSecondary),
          ),
          IconButton(
            onPressed: () => context.goNamed(AppRouteNames.about),
            icon: Icon(Icons.info_outline_rounded, color: colors.textSecondary),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header / Greeting
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(color: colors.textMuted, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Who will you chat with today?',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: colors.field,
                  borderRadius: BorderRadius.circular(colors.radiusField),
                  border: Border.all(color: colors.outline),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search characters, creators, or tags...',
                    hintStyle: TextStyle(color: colors.textPlaceholder),
                    prefixIcon: Icon(Icons.search_rounded, color: colors.textMuted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final categories = ['For You', 'Assistants', 'Anime', 'Games', 'Humor', 'Debate'];
                    return _buildCategoryChip(context, categories[index], index == 0);
                  },
                ),
              ),
            ),
          ),

          // Recent Chats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Recent Chats',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _buildRecentChatCard(context, index),
              ),
            ),
          ),

          // Trending Characters Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trending Characters',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See all',
                      style: TextStyle(color: colors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCharacterCard(context, index),
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.primary,
        elevation: 4,
        onPressed: () {
          // Navigate to create character or new chat
        },
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool isSelected) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : colors.field,
        borderRadius: BorderRadius.circular(colors.radiusChip),
        border: Border.all(
          color: isSelected ? colors.primary : colors.outline,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : colors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildRecentChatCard(BuildContext context, int index) {
    final colors = context.colors;
    final names = ['Aria', 'Kaito', 'Nova', 'Zephyr', 'Lyra'];

    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withOpacity(0.1),
              border: Border.all(color: colors.outline, width: 1),
            ),
            child: Center(
              child: Icon(
                Icons.smart_toy_rounded,
                size: 32,
                color: colors.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            names[index],
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            '2h ago',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(BuildContext context, int index) {
    final colors = context.colors;
    final names = ['Aria', 'Kaito', 'Nova', 'Zephyr'];
    final descriptions = ['Helpful Assistant', 'Cyberpunk Hacker', 'Space Explorer', 'Witty Bard'];
    final chats = ['1.2M chats', '850K chats', '2.5M chats', '430K chats'];

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusCard),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(colors.radiusCard),
                  topRight: Radius.circular(colors.radiusCard),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.smart_toy_rounded,
                  size: 48,
                  color: colors.primary,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    names[index],
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    descriptions[index],
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.field,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 10, color: colors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          chats[index],
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}