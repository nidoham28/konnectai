import 'package:flutter/material.dart';
import 'package:konnectai/core/theme/app_themes.dart';

/// A single chat thread row. Feed this from your chats repository.
class ChatThreadSummary {
  const ChatThreadSummary({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

class ChatsPage extends StatelessWidget {
  const ChatsPage({
    super.key,
    this.threads = const [],
    this.onThreadTap,
  });

  final List<ChatThreadSummary> threads;
  final ValueChanged<ChatThreadSummary>? onThreadTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chats',
                style: TextStyle(color: colors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Continue conversations, manage recent threads, and jump back into your favorites.',
                style: TextStyle(color: colors.textSecondary, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: threads.isEmpty
                    ? const _EmptyChatsState()
                    : ListView.separated(
                        itemCount: threads.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final thread = threads[index];
                          return _ChatTile(
                            thread: thread,
                            onTap: () => onThreadTap?.call(thread),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.thread, this.onTap});

  final ChatThreadSummary thread;
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(colors.radiusCard),
            border: Border.all(color: colors.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(thread.icon, color: colors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.title,
                      style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      thread.subtitle,
                      style: TextStyle(color: colors.textSecondary, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyChatsState extends StatelessWidget {
  const _EmptyChatsState();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 48, color: colors.textMuted),
            const SizedBox(height: 12),
            Text(
              'No conversations yet',
              style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Start a chat with a character and it will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textSecondary, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}