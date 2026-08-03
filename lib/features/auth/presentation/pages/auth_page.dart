import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:konnectai/app/router/app_routes.dart';
import 'package:konnectai/core/supabase/supabase_client.dart';
import 'package:konnectai/core/theme/app_colors.dart';

/// Centralized palette so every widget in this file pulls from one
/// source of truth instead of scattering hex literals everywhere.
class _AuthColors {
  static const primary = AppColors.primary;
  static const primaryDark = AppColors.primaryDark;
  static const surface = AppColors.surface;
  static const cardFill = AppColors.card;
  static const fieldFill = AppColors.field;
  static const outline = AppColors.outline;
  static const textPrimary = AppColors.textPrimary;
  static const textSecondary = AppColors.textSecondary;
  static const textMuted = AppColors.textMuted;
  static const textPlaceholder = AppColors.textPlaceholder;
  static const error = AppColors.error;
}

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _AuthColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            _isLoginMode ? 'Welcome back, $email' : 'Account created for $email',
          ),
        ),
      );

      context.goNamed(AppRouteNames.home);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _AuthColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(error.toString()),
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
    return Scaffold(
      backgroundColor: _AuthColors.surface,
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
                    _AuthColors.primary.withValues(alpha: 0.16),
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
                    _AuthColors.primaryDark.withValues(alpha: 0.10),
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
            colors: [_AuthColors.primary, _AuthColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _AuthColors.primary.withValues(alpha: 0.30),
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
              color: _AuthColors.textPrimary,
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
            style: const TextStyle(
              fontSize: 14,
              color: _AuthColors.textMuted,
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
    return Container(
      padding: EdgeInsets.all(compact ? 20 : 24),
      decoration: BoxDecoration(
        color: _AuthColors.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _AuthColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
                  color: _AuthColors.textPlaceholder,
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
                    foregroundColor: _AuthColors.primary,
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
                  backgroundColor: _AuthColors.primary,
                  disabledBackgroundColor:
                      _AuthColors.primary.withValues(alpha: 0.55),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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
                const Expanded(child: Divider(color: _AuthColors.outline)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or continue with',
                    style: TextStyle(
                      fontSize: 12,
                      color: _AuthColors.textPlaceholder,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: _AuthColors.outline)),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _SocialButton(
                    label: 'Google',
                    icon: Icons.g_mobiledata_rounded,
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
            style: const TextStyle(fontSize: 14, color: _AuthColors.textMuted),
          ),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              isLoginMode ? 'Sign up' : 'Login',
              style: const TextStyle(
                fontSize: 14,
                color: _AuthColors.primary,
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
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: _AuthColors.primary,
      style: const TextStyle(fontSize: 15, color: _AuthColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(
          color: _AuthColors.textPlaceholder,
          fontSize: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          color: _AuthColors.textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, size: 20, color: _AuthColors.textPlaceholder),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: _AuthColors.fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _AuthColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _AuthColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _AuthColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _AuthColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _AuthColors.error, width: 1.6),
        ),
        errorStyle: const TextStyle(fontSize: 12, color: _AuthColors.error),
      ),
      validator: validator,
    );
  }
}

/// Outlined secondary button for social sign-in options.
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: _AuthColors.textSecondary),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _AuthColors.textSecondary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 13),
        side: const BorderSide(color: _AuthColors.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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