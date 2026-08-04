// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:konnectai/core/theme/app_themes.dart';

/// Minimal data needed to render a trending character card.
/// Feed this from your character/feed repository — no fake data here.
class CharacterSummary {
  const CharacterSummary({
    required this.id,
    required this.name,
    required this.description,
    required this.chatCountLabel,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String description;
  final String chatCountLabel;
  final String? avatarUrl;
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.trendingCharacters = const [],
    this.onRefresh,
    this.onCharacterTap,
    this.onCreateTap,
    this.onSeeAllTrending,
    this.onSearchChanged,
  });

  final List<CharacterSummary> trendingCharacters;
  final Future<void> Function()? onRefresh;
  final ValueChanged<CharacterSummary>? onCharacterTap;
  final VoidCallback? onCreateTap;
  final VoidCallback? onSeeAllTrending;
  final ValueChanged<String>? onSearchChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _categories = ['For You', 'Assistants', 'Anime', 'Games', 'Humor', 'Debate'];
  int _selectedCategory = 0;

  Future<void> _handleRefresh() async {
    await widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = width >= 900 ? 4 : (width >= 600 ? 3 : 2);
    final characters = widget.trendingCharacters;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: colors.primary,
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SearchField(colors: colors, onChanged: widget.onSearchChanged),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return _CategoryChip(
                          label: _categories[index],
                          isSelected: index == _selectedCategory,
                          onTap: () => setState(() => _selectedCategory = index),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Trending Characters',
                  actionLabel: characters.isEmpty ? null : 'See all',
                  onAction: widget.onSeeAllTrending,
                ),
              ),
              if (characters.isEmpty)
                SliverToBoxAdapter(
                  child: _EmptyState(
                    icon: Icons.auto_awesome_outlined,
                    title: 'No trending characters yet',
                    message: 'Check back soon, or create your own character to get started.',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final character = characters[index];
                        return _CharacterCard(
                          character: character,
                          onTap: () => widget.onCharacterTap?.call(character),
                        );
                      },
                      childCount: characters.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.colors, this.onChanged});

  final AppColorScheme colors;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: colors.field,
        borderRadius: BorderRadius.circular(colors.radiusField),
        border: Border.all(color: colors.outline),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search characters, creators, or tags...',
          hintStyle: TextStyle(color: colors.textPlaceholder),
          prefixIcon: Icon(Icons.search_rounded, color: colors.textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.field,
          borderRadius: BorderRadius.circular(colors.radiusChip),
          border: Border.all(color: isSelected ? colors.primary : colors.outline),
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
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!, style: TextStyle(color: colors.primary)),
            ),
        ],
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  const _CharacterCard({required this.character, this.onTap});

  final CharacterSummary character;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(colors.radiusCard),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(colors.radiusCard),
            border: Border.all(color: colors.outline),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: colors.primary.withOpacity(0.08),
                  child: character.avatarUrl != null
                      ? Image.network(character.avatarUrl!, fit: BoxFit.cover)
                      : Center(child: Icon(Icons.smart_toy_rounded, size: 48, color: colors.primary)),
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
                        character.name,
                        style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        character.description,
                        style: TextStyle(color: colors.textMuted, fontSize: 12),
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
                              character.chatCountLabel,
                              style: TextStyle(color: colors.textMuted, fontSize: 10, fontWeight: FontWeight.w500),
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
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 64),
      child: Column(
        children: [
          Icon(icon, size: 40, color: colors.textMuted),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textSecondary, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}