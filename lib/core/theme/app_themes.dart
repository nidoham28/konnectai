import 'package:flutter/material.dart';
import 'package:konnectai/core/theme/app_colors.dart';

/// Theme-aware colors + shared shape constants.
///
/// Screens should pull colors from `Theme.of(context).extension<AppColorScheme>()!`
/// instead of hardcoding a palette class. That's what caused the auth page
/// to stay light-mode-only even when the app switched to dark theme:
/// its `_AuthColors` class pointed at fixed light values with no dark
/// counterpart. Using a ThemeExtension means:
///   - every screen resolves the correct palette automatically
///   - Flutter cross-fades colors on theme change instead of snapping (lerp)
///   - shapes (radii) are defined once, so cards/fields/buttons stay visually
///     consistent between light and dark instead of drifting independently
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.primary,
    required this.primaryDark,
    required this.surface,
    required this.card,
    required this.field,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textPlaceholder,
    required this.error,
    required this.errorSurface,
    required this.success,
    // Shared shape language — one set of radii for the whole app so cards,
    // fields, and buttons read as the same "family" in both themes.
    this.radiusCard = 20,
    this.radiusField = 14,
    this.radiusButton = 14,
    this.radiusChip = 12,
  });

  final Color primary;
  final Color primaryDark;
  final Color surface;
  final Color card;
  final Color field;
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textPlaceholder;
  final Color error;
  final Color errorSurface;
  final Color success;

  final double radiusCard;
  final double radiusField;
  final double radiusButton;
  final double radiusChip;

  static const light = AppColorScheme(
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    surface: AppColors.surface,
    card: AppColors.card,
    field: AppColors.field,
    outline: AppColors.outline,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
    textPlaceholder: AppColors.textPlaceholder,
    error: AppColors.error,
    errorSurface: AppColors.error,
    success: AppColors.success,
  );

  static const dark = AppColorScheme(
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    surface: AppColors.darkSurface,
    card: AppColors.darkCard,
    field: AppColors.darkField,
    outline: AppColors.darkOutline,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textMuted: AppColors.darkTextMuted,
    textPlaceholder: AppColors.darkTextPlaceholder,
    error: AppColors.error,
    errorSurface: AppColors.darkErrorSurface,
    success: AppColors.success,
  );

  @override
  AppColorScheme copyWith({
    Color? primary,
    Color? primaryDark,
    Color? surface,
    Color? card,
    Color? field,
    Color? outline,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textPlaceholder,
    Color? error,
    Color? errorSurface,
    Color? success,
    double? radiusCard,
    double? radiusField,
    double? radiusButton,
    double? radiusChip,
  }) {
    return AppColorScheme(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      field: field ?? this.field,
      outline: outline ?? this.outline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textPlaceholder: textPlaceholder ?? this.textPlaceholder,
      error: error ?? this.error,
      errorSurface: errorSurface ?? this.errorSurface,
      success: success ?? this.success,
      radiusCard: radiusCard ?? this.radiusCard,
      radiusField: radiusField ?? this.radiusField,
      radiusButton: radiusButton ?? this.radiusButton,
      radiusChip: radiusChip ?? this.radiusChip,
    );
  }

  @override
  AppColorScheme lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      field: Color.lerp(field, other.field, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorSurface: Color.lerp(errorSurface, other.errorSurface, t)!,
      success: Color.lerp(success, other.success, t)!,
      // Shapes don't need lerping (there's nothing "between" two radii that
      // matters visually) — hold steady on the incoming theme's values.
      radiusCard: t < 0.5 ? radiusCard : other.radiusCard,
      radiusField: t < 0.5 ? radiusField : other.radiusField,
      radiusButton: t < 0.5 ? radiusButton : other.radiusButton,
      radiusChip: t < 0.5 ? radiusChip : other.radiusChip,
    );
  }
}

/// Convenience accessor: `context.colors.primary` instead of the longer
/// `Theme.of(context).extension<AppColorScheme>()!.primary`.
extension AppColorSchemeX on BuildContext {
  AppColorScheme get colors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.light;
}

/// App-wide theme definitions for light and dark mode.
class AppThemes {
  AppThemes._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.surface,
        extensions: <ThemeExtension<dynamic>>[AppColorScheme.light],
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.darkSurface,
        extensions: <ThemeExtension<dynamic>>[AppColorScheme.dark],
      );
}