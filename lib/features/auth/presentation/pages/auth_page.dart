import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:konnectai/app/router/app_routes.dart';
import 'package:konnectai/core/supabase/supabase_client.dart';
import 'package:konnectai/core/theme/app_colors.dart';
import 'package:konnectai/core/theme/app_themes.dart';

// Colors now come from `context.colors` (AppColorScheme), which resolves to
// the light or dark palette automatically based on the active theme. The
// previous `_AuthColors` class pointed at fixed light-mode values, so this
// screen used to look identical in dark mode — white card, light fields —
// while every other themed screen went dark. That's fixed by reading colors
// from the theme instead of a hardcoded class. Shape radii are likewise
// pulled from the shared `AppColorScheme` (radiusCard/radiusField/etc.) so
// cards, fields, and buttons keep the same shape language everywhere.

/// Simple responsive scale so type, spacing and the card width adapt
/// smoothly instead of jumping at a single breakpoint.
class _Responsive {
  _Responsive(double width)
      : isCompact = width < 400,
        isWide = width >= 900,
        maxCardWidth = width >= 900
            ? 440.0
            : width >= 600
                ? 420.0
                : 400.0,
        horizontalPadding = width < 360 ? 16.0 : 24.0;

  final bool isCompact;
  final bool isWide;
  final double maxCardWidth;
  final double horizontalPadding;
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AnimationController _switchController;

  bool _isLoginMode = true;
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _switchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _switchController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isSubmitting = true);

    try {
      if (_isLoginMode) {
        await AppSupabase.client.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } else {
        await AppSupabase.client.auth.signUp(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;
      final scheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          // inverseSurface/onInverseSurface is Material's built-in pairing
          // for "always-dark pill on any theme" — it stays correctly
          // contrasted in both light and dark instead of us hand-picking a
          // color that only looks right in one of them.
          backgroundColor: scheme.inverseSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.colors.radiusChip),
          ),
          content: Text(
            _isLoginMode ? 'Welcome back, $email' : 'Account created for $email',
            style: TextStyle(color: scheme.onInverseSurface),
          ),
        ),
      );

      context.goNamed(AppRouteNames.home);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.colors.errorSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.colors.radiusChip),
          ),
          content: Text(
            error.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _toggleMode() {
    setState(() => _isLoginMode = !_isLoginMode);
  }

  @override
  Widget build(BuildContext context) {
    // No explicit backgroundColor here: Scaffold already inherits
    // scaffoldBackgroundColor from the active theme (AppThemes.light/dark),
    // so it switches automatically instead of being pinned to light mode.
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final r = _Responsive(constraints.maxWidth);
          return Stack(
            children: [
              // Soft ambient gradient blobs for depth without noise.
              Positioned(
                top: -120,
                right: -80,
                child: _GradientBlob(
                  size: 320,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.16),
                    Colors.transparent,
                  ],
                ),
              ),
              Positioned(
                bottom: -140,
                left: -100,
                child: _GradientBlob(
                  size: 360,
                  colors: [
                    AppColors.primaryDark.withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.horizontalPadding,
                      vertical: r.isCompact ? 24 : 32,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: r.maxCardWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Brandmark(compact: r.isCompact),
                          const SizedBox(height: 24),
                          _HeaderText(
                            isLoginMode: _isLoginMode,
                            compact: r.isCompact,
                          ),
                          const SizedBox(height: 28),
                          _AuthCard(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            isLoginMode: _isLoginMode,
                            isSubmitting: _isSubmitting,
                            obscurePassword: _obscurePassword,
                            onToggleObscure: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            onSubmit: _submit,
                            compact: r.isCompact,
                          ),
                          const SizedBox(height: 24),
                          _ModeSwitchFooter(
                            isLoginMode: _isLoginMode,
                            onTap: _toggleMode,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// App logo mark, sized down slightly on very narrow screens.
class _Brandmark extends StatelessWidget {
  const _Brandmark({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final dim = compact ? 104.0 : 120.0;
    return Center(
      child: Container(
        width: dim,
        height: dim,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SvgPicture.asset(
          'assets/icons/app_icon.svg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

/// Title + subtitle, animated between login/signup copy.
class _HeaderText extends StatelessWidget {
  const _HeaderText({required this.isLoginMode, required this.compact});

  final bool isLoginMode;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Column(
        key: ValueKey(isLoginMode),
        children: [
          Text(
            isLoginMode ? 'Welcome back' : 'Create account',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 22 : 24,
              fontWeight: FontWeight.w700,
              color: context.colors.textPrimary,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isLoginMode
                ? 'Sign in to continue to your workspace'
                : 'Start your journey with just a few details',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: context.colors.textMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// The white card holding the form and social sign-in options.
class _AuthCard extends StatelessWidget {
  const _AuthCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoginMode,
    required this.isSubmitting,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.compact,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoginMode;
  final bool isSubmitting;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // A 4%-alpha black shadow reads as a soft lift on a light card but
    // disappears entirely on a dark one — so the card looked "flat" in dark
    // mode. Scaling the alpha up when the theme is dark keeps the same lift
    // effect in both, instead of the shadow silently vanishing.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(compact ? 20 : 24),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(colors.radiusCard),
        border: Border.all(color: colors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.04),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AuthField(
              controller: emailController,
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _AuthField(
              controller: passwordController,
              label: 'Password',
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                splashRadius: 18,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: colors.textPlaceholder,
                  size: 20,
                ),
                onPressed: onToggleObscure,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Must be at least 6 characters';
                }
                return null;
              },
            ),
            if (isLoginMode) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: isSubmitting ? null : onSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.55),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(colors.radiusButton),
                  ),
                  elevation: 0,
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isLoginMode ? 'Login' : 'Sign up',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Divider(color: colors.outline)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or continue with',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textPlaceholder,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: colors.outline)),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    label: 'Google',
                    iconAsset: 'assets/icons/google_icon.svg',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SocialButton(
                    label: 'Apple',
                    icon: Icons.apple_rounded,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// "Don't have an account? Sign up" footer row.
class _ModeSwitchFooter extends StatelessWidget {
  const _ModeSwitchFooter({required this.isLoginMode, required this.onTap});

  final bool isLoginMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            isLoginMode ? "Don't have an account? " : 'Already have an account? ',
            style: TextStyle(fontSize: 14, color: context.colors.textMuted),
          ),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              isLoginMode ? 'Sign up' : 'Login',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded, softly-filled text field used throughout the auth flow.
class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(colors.radiusField);
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: AppColors.primary,
      style: TextStyle(fontSize: 15, color: colors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: colors.textPlaceholder,
          fontSize: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: colors.textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, size: 20, color: colors.textPlaceholder),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: colors.field,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.6),
        ),
        errorStyle: const TextStyle(fontSize: 12, color: AppColors.error),
      ),
      validator: validator,
    );
  }
}

/// Outlined secondary button for social sign-in options.
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    this.icon,
    this.iconAsset,
    required this.onPressed,
  });

  final String label;
  final IconData? icon;
  final String? iconAsset;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: iconAsset != null
          ? SvgPicture.asset(
              iconAsset!,
              width: 20,
              height: 20,
            )
          : Icon(icon, size: 20, color: colors.textSecondary),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.textSecondary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 13),
        side: BorderSide(color: colors.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(colors.radiusChip),
        ),
      ),
    );
  }
}

/// Soft, blurred gradient circle used for ambient background depth.
class _GradientBlob extends StatelessWidget {
  const _GradientBlob({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: colors),
        ),
      ),
    );
  }
}