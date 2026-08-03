import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primary = Color(0xFF4F46E5);
  static const primaryDark = Color(0xFF3730A3);
  static const accent = Color(0xFF6366F1);
  static const surface = Color(0xFFFAFAFB);
  static const card = Colors.white;
  static const field = Color(0xFFF7F7F8);
  static const outline = Color(0xFFE4E4E7);
  static const textPrimary = Color(0xFF18181B);
  static const textSecondary = Color(0xFF52525B);
  static const textMuted = Color(0xFF71717A);
  static const textPlaceholder = Color(0xFFA1A1AA);
  static const error = Color(0xFFDC2626);
  static const success = Color(0xFF16A34A);

  // Dark-mode counterparts. Kept alongside the light palette (rather than
  // scattered as inline hex literals) so every screen resolves colors the
  // same way and light/dark stay in sync as the palette evolves.
  static const darkSurface = Color(0xFF0F172A);
  static const darkCard = Color(0xFF111827);
  static const darkField = Color(0xFF1E293B);
  static const darkOutline = Color(0xFF334155);
  static const darkTextPrimary = Colors.white;
  static const darkTextSecondary = Color(0xFFE2E8F0);
  static const darkTextMuted = Color(0xFFCBD5E1);
  static const darkTextPlaceholder = Color(0xFF94A3B8);
  static const darkErrorSurface = Color(0xFF7F1D1D);
}