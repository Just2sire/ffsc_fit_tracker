import "package:flutter/material.dart" show TextTheme, FontWeight, TextStyle;

import "app_colors.dart";

/// Typographie FFSC Fit Tracker — deux familles.
///
/// `SpaceGrotesk` (500/600/700) porte les titres (display/headline/title) —
/// géométrique, anguleuse, cohérente avec l'accent lime. `Manrope`
/// (400/500/600/700) porte le corps de texte et l'UI (body/label/boutons/
/// champs) — meilleure lisibilité en petite taille. Les deux familles et
/// graisses bundlées sont déclarées dans `pubspec.yaml`.
class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamilyDisplay = "SpaceGrotesk";
  static const String fontFamily = "Manrope";

  // ─────────────────────────────────────────────
  // LIGHT MODE — Text theme
  // ─────────────────────────────────────────────

  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 45,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 19,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.ink87,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.ink87,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.ink54,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.ink87,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.ink87,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.ink87,
    ),
  );

  // ─────────────────────────────────────────────
  // DARK MODE — Text theme
  // ─────────────────────────────────────────────

  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 57,
      fontWeight: FontWeight.w700,
      color: AppColors.paleMint,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 45,
      fontWeight: FontWeight.w700,
      color: AppColors.paleMint,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.paleMint,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.paleMint,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: AppColors.paleMint,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.paleMint,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.paleMint,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.paleMint,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 19,
      fontWeight: FontWeight.w600,
      color: AppColors.paleMint,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint87,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint87,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.paleMint54,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.paleMint87,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.paleMint87,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.paleMint70,
    ),
  );

  // ─────────────────────────────────────────────
  // STYLES STANDALONE
  // ─────────────────────────────────────────────

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.43,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle inputText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.33,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
  );
}
