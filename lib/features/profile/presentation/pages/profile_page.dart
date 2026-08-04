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
    this.email,
    this.avatarUrl,
    this.onEditProfile,
    this.onMenuItemTap,
    this.onSignOut,
  });

  /// Pass real user data in. Left null until auth/profile data is wired up
  /// so nothing fake is ever shown.
  final String? displayName;
  final String? email;
  final String? avatarUrl;
  final VoidCallback? onEditProfile;
  final ValueChanged<ProfileMenuItem>? onMenuItemTap;
  final VoidCallback? onSignOut;

  static const _accountItems = [
    ProfileMenuItem(id: 'edit_profile', label: 'Edit profile', icon: Icons.person_outline_rounded),
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            Text('Profile', style: TextStyle(color: colors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            _ProfileHeader(
              displayName: displayName,
              email: email,
              avatarUrl: avatarUrl,
              onEditProfile: onEditProfile,
            ),
            const SizedBox(height: 24),
            _MenuSection(title: 'Account', items: _accountItems, onTap: onMenuItemTap),
            const SizedBox(height: 16),
            _MenuSection(title: 'Support', items: _supportItems, onTap: onMenuItemTap),
            const SizedBox(height: 24),
            _SignOutButton(onTap: onSignOut),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({this.displayName, this.email, this.avatarUrl, this.onEditProfile});

  final String? displayName;
  final String? email;
  final String? avatarUrl;
  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusCard),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: colors.primary.withOpacity(0.12),
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null ? Icon(Icons.person_rounded, color: colors.primary, size: 28) : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName ?? 'Your account',
                  style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (email != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    email!,
                    style: TextStyle(color: colors.textSecondary, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onEditProfile,
            icon: Icon(Icons.edit_outlined, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.items, this.onTap});

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
            color: colors.card,
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
            Icon(item.icon, size: 20, color: colors.textSecondary),
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

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final errorColor = Theme.of(context).colorScheme.error;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: errorColor,
          side: BorderSide(color: colors.outline),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(colors.radiusButton)),
        ),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text('Sign out', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}