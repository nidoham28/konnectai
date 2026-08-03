import 'package:flutter/material.dart';
import 'package:konnectai/core/theme/app_themes.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Library',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Save favorite characters, chats, and collections in one place.',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(colors.radiusCard),
                      border: Border.all(color: colors.outline),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bookmark_border_rounded, color: colors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            index == 0
                                ? 'Saved characters'
                                : index == 1
                                    ? 'Recent conversations'
                                    : 'Custom playlists',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
