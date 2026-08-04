import 'package:flutter/material.dart';
import 'package:konnectai/core/theme/app_themes.dart';

class ProfileMenuItem {
  const ProfileMenuItem({required this.id, required this.label, required this.icon});

  final String id;
  final String label;
  final IconData icon;
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    this.displayName,
    this.username,
    this.email,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.totalLikes,
    this.totalChats,
    this.totalCharacterCount,
    this.isVerified = false,
    this.onEditCover,
    this.onEditAvatar,
    this.onEditProfile,
    this.onMenuItemTap,
    this.onSignOut,
  });

  final String? displayName;
  final String? username;
  final String? email;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;

  final int? totalLikes;
  final int? totalChats;
  final int? totalCharacterCount;
  final bool isVerified;

  final VoidCallback? onEditCover;
  final VoidCallback? onEditAvatar;
  final VoidCallback? onEditProfile;
  final ValueChanged<ProfileMenuItem>? onMenuItemTap;
  final VoidCallback? onSignOut;

  static const _creatorItems = [
    ProfileMenuItem(id: 'create_character', label: 'Create Character', icon: Icons.face_retouching_natural_rounded),
  ];

  static const _accountItems = [
    ProfileMenuItem(id: 'notifications', label: 'Notifications', icon: Icons.notifications_none_rounded),
    ProfileMenuItem(id: 'privacy', label: 'Privacy', icon: Icons.lock_outline_rounded),
  ];

  static const _supportItems = [
    ProfileMenuItem(id: 'help', label: 'Help center', icon: Icons.help_outline_rounded),
    ProfileMenuItem(id: 'about', label: 'About', icon: Icons.info_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _ProfileHeader(
                displayName: displayName,
                username: username,
                bio: bio,
                avatarUrl: avatarUrl,
                coverUrl: coverUrl,
                totalLikes: totalLikes,
                totalChats: totalChats,
                totalCharacterCount: totalCharacterCount,
                isVerified: isVerified,
                onEditCover: onEditCover,
                onEditAvatar: onEditAvatar,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
                child: Column(
                  children: [
                    _MenuSection(
                      title: 'Creator',
                      items: ProfilePage._creatorItems,
                      onTap: onMenuItemTap,
                    ),
                    const SizedBox(height: 12),
                    _MenuSection(
                      title: 'Account',
                      items: ProfilePage._accountItems,
                      onTap: onMenuItemTap,
                    ),
                    const SizedBox(height: 12),
                    _MenuSection(
                      title: 'Support',
                      items: ProfilePage._supportItems,
                      onTap: onMenuItemTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    this.displayName,
    this.username,
    this.bio,
    this.avatarUrl,
    this.coverUrl,
    this.totalLikes,
    this.totalChats,
    this.totalCharacterCount,
    this.isVerified = false,
    this.onEditCover,
    this.onEditAvatar,
  });

  final String? displayName;
  final String? username;
  final String? bio;
  final String? avatarUrl;
  final String? coverUrl;
  final int? totalLikes;
  final int? totalChats;
  final int? totalCharacterCount;
  final bool isVerified;
  final VoidCallback? onEditCover;
  final VoidCallback? onEditAvatar;

  static const _coverHeight = 180.0;
  static const _avatarRadius = 48.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      color: colors.surface,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: _coverHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colors.primary, colors.primaryDark],
                  ),
                  image: coverUrl != null
                      ? DecorationImage(image: NetworkImage(coverUrl!), fit: BoxFit.cover)
                      : null,
                ),
              ),
              Positioned(
                bottom: -_avatarRadius,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: colors.surface),
                  child: CircleAvatar(
                    radius: _avatarRadius,
                    backgroundColor: colors.primary.withOpacity(0.12),
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null ? Icon(Icons.person_rounded, color: colors.primary, size: 44) : null,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, _avatarRadius + 12, 16, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        displayName ?? 'Your account',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.verified_rounded, color: colors.primary, size: 18),
                    ],
                  ],
                ),
                if (username != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '@$username',
                    style: TextStyle(color: colors.textSecondary, fontSize: 13.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (bio != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    bio!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.textSecondary, fontSize: 13.5, height: 1.35),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _StatItem(value: totalLikes, label: 'Likes')),
                    const SizedBox(width: 10),
                    Expanded(child: _StatItem(value: totalChats, label: 'Chats')),
                    const SizedBox(width: 10),
                    Expanded(child: _StatItem(value: totalCharacterCount, label: 'Characters')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final int? value;
  final String label;

  String _format(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(colors.radiusButton),
      ),
      child: Column(
        children: [
          Text(
            value != null ? _format(value!) : '—',
            style: TextStyle(color: colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: colors.textMuted, fontSize: 11.5, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.title,
    required this.items,
    this.onTap,
  });

  final String title;
  final List<ProfileMenuItem> items;
  final ValueChanged<ProfileMenuItem>? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(title, style: TextStyle(color: colors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surface, // Uses the exact same background color as the header
            borderRadius: BorderRadius.circular(colors.radiusCard),
            border: Border.all(color: colors.outline),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _MenuTile(item: items[i], onTap: () => onTap?.call(items[i])),
                if (i != items.length - 1) Divider(height: 1, color: colors.outline),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item, this.onTap});

  final ProfileMenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: colors.field, borderRadius: BorderRadius.circular(10)),
              child: Icon(item.icon, size: 18, color: colors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(item.label, style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}