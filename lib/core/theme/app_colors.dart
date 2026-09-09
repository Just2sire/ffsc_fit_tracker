import "package:flutter/painting.dart";

/// Palette "Lime & Ink" — identité FFSC Fit Tracker.
///
/// Accent lime électrique (Volt) posé sur un fond encre violette profonde,
/// avec un pendant "soft" clair pour chaque teinte forte.
///
/// Convention : les constantes sans suffixe correspondent au **mode clair**.
/// Les variantes de mode sombre portent le suffixe `Dark`.
class AppColors {
  const AppColors._();

  // ───────────────────────────────────────────────
  // BRAND — lime primary
  // ───────────────────────────────────────────────

  /// Brand — CTA principal, focus, tab actif (`#D7FC00`, "Volt").
  static const Color primary = Color(0xFFD7FC00);

  /// État hover / glow — lime plus intense (`#E1FF12`, "Néon").
  static const Color primaryHover = Color(0xFFE1FF12);

  /// État pressé — lime assombri, olive (`#A6BE00`).
  static const Color primaryPressed = Color(0xFFA6BE00);

  /// Fond de chip actif, halo de focus — primary @ 12% (`0x1FD7FC00`).
  static const Color primarySubtle = Color(0x1FD7FC00);

  /// Texte/icônes sur surface primary — encre foncée, pas de blanc (lime = très clair).
  static const Color onPrimary = Color(0xFF191D00);

  // Variantes dark
  static const Color primaryDark = primaryHover;
  static const Color primaryHoverDark = Color(0xFFEEFF7A);
  static const Color primaryPressedDark = primary;
  static const Color primarySubtleDark = Color(0x1FE1FF12);


  // ───────────────────────────────────────────────
  // ENCRE & PAPIER — couleurs de texte de marque
  // ───────────────────────────────────────────────

  /// Encre violette — remplace le noir pur pour les textes en light mode.
  static const Color ink = Color(0xFF15112B);
  static const Color ink87 = Color(0xDE15112B);
  static const Color ink54 = Color(0x8A15112B);
  static const Color ink38 = Color(0x6115112B);

  /// Papier froid cassé — remplace le blanc pur pour les textes en dark mode.
  static const Color paleMint = Color(0xFFE7E7F5);
  static const Color paleMint87 = Color(0xDEE7E7F5);
  static const Color paleMint70 = Color(0xB3E7E7F5);
  static const Color paleMint54 = Color(0x8AE7E7F5);
  static const Color paleMint38 = Color(0x61E7E7F5);
  // ───────────────────────────────────────────────
  // SURFACES — Mode clair
  // ───────────────────────────────────────────────

  /// Fond scaffold (`#FFFFFF`).
  static const Color surfacePage = Color(0xFFFFFFFF);

  /// Cards, panneaux, champs (`#F3F2FA`).
  static const Color surfaceCard = Color(0xFFF3F2FA);

  /// Card hover/pressée, en-tête sticky (`#E7E7F5`).
  static const Color surfaceRaised = Color(0xFFE7E7F5);

  /// Zones creuses, preview image, quotations (`#DBDBF0`).
  static const Color surfaceSunken = Color(0xFFDBDBF0);

  /// Cards feature, snackbars — surface sombre (`#090515`).
  static const Color surfaceInverse = Color(0xFF090515);

  /// Bottom navigation bar, app bar (`#FFFFFF`).
  static const Color surfaceNav = Color(0xFFFFFFFF);

  // ───────────────────────────────────────────────
  // SURFACES — Mode sombre
  // ───────────────────────────────────────────────

  /// Fond scaffold dark — encre violette (`#090515`).
  static const Color surfacePageDark = Color(0xFF090515);
  static const Color surfaceCardDark = Color(0xFF120C24);
  static const Color surfaceRaisedDark = Color(0xFF1C1440);
  static const Color surfaceSunkenDark = Color(0xFF050310);
  static const Color surfaceInverseDark = Color(0xFFE7E7F5);
  static const Color surfaceNavDark = Color(0xFF120C24);

  // ───────────────────────────────────────────────
  // TEXTE — Mode clair
  // ───────────────────────────────────────────────

  static const Color textPrimary = Color(0xFF15112B);
  static const Color textSecondary = Color(0xFF4A4666);
  static const Color textTertiary = Color(0xFF8B87A3);
  static const Color textDisabled = Color(0xFFC3C1D6);
  static const Color textInverse = Color(0xFFF3F2FA);

  /// Liens — lime foncé pour rester lisible sur fond clair (le lime pur
  /// manque de contraste sur blanc).
  static const Color textAccent = Color(0xFF7C8A00);

  // ───────────────────────────────────────────────
  // TEXTE — Mode sombre
  // ───────────────────────────────────────────────

  static const Color textPrimaryDark = Color(0xFFF3F2FA);
  static const Color textSecondaryDark = Color(0xFFB3AEC8);
  static const Color textTertiaryDark = Color(0xFF7A7593);
  static const Color textDisabledDark = Color(0xFF443C68);
  static const Color textInverseDark = Color(0xFF15112B);

  /// Liens en dark mode — le lime pur pop sur le fond encre.
  static const Color textAccentDark = primary;

  // ───────────────────────────────────────────────
  // BORDURES — Mode clair
  // ───────────────────────────────────────────────

  static const Color borderHairline = Color(0xFFE3E2F0);
  static const Color borderDefault = Color(0xFFCFCCE3);
  static const Color borderStrong = Color(0xFF15112B);
  static const Color borderFocus = primary;

  // ───────────────────────────────────────────────
  // BORDURES — Mode sombre
  // ───────────────────────────────────────────────

  static const Color borderHairlineDark = Color(0xFF241C42);
  static const Color borderDefaultDark = Color(0xFF362A5E);
  static const Color borderStrongDark = Color(0xFFF3F2FA);
  static const Color borderFocusDark = primary;

  // ───────────────────────────────────────────────
  // SÉMANTIQUE
  // ───────────────────────────────────────────────

  /// Succès, sync réussie — émeraude, distinct du lime primary (`#00E0A4`).
  static const Color semanticSuccess = Color(0xFF00E0A4);
  static const Color semanticSuccessBg = Color(0x1F00E0A4);

  /// Attention, warning (`#F5A300`).
  static const Color semanticWarning = Color(0xFFF5A300);
  static const Color semanticWarningBg = Color(0x1FF5A300);

  /// Erreurs, suppression (`#FF5D5D`).
  static const Color semanticError = Color(0xFFFF5D5D);
  static const Color semanticErrorBg = Color(0x1FFF5D5D);

  /// Info, sync en cours — périwinkle, distinct du lime (réservé au brand).
  static const Color semanticInfo = Color(0xFF7C8CFF);
  static const Color semanticInfoBg = Color(0x1F7C8CFF);

  /// Badge hors-ligne.
  static const Color semanticOffline = Color(0xFF7A7593);

  // ───────────────────────────────────────────────
  // PALETTE CATÉGORIELLE — tags
  //
  // Utilisée pour distinguer visuellement des catégories (types d'exercice,
  // groupes musculaires, etc.) dans les Chips. Chaque teinte a sa variante
  // `Bg` à 12% d'opacité pour les fonds.
  // ───────────────────────────────────────────────

  static const Color tagBlue = Color(0xFF5B7CFA);
  static const Color tagBlueBg = Color(0x1F5B7CFA);

  static const Color tagPurple = Color(0xFFA78BFA);
  static const Color tagPurpleBg = Color(0x1FA78BFA);

  static const Color tagPink = Color(0xFFFF6FA8);
  static const Color tagPinkBg = Color(0x1FFF6FA8);

  static const Color tagAmber = Color(0xFFF5A300);
  static const Color tagAmberBg = Color(0x1FF5A300);

  static const Color tagGreen = Color(0xFF00E0A4);
  static const Color tagGreenBg = Color(0x1F00E0A4);

  static const Color tagCyan = Color(0xFF22D3EE);
  static const Color tagCyanBg = Color(0x1F22D3EE);

  // ───────────────────────────────────────────────
  // OMBRE FLOTTANTE
  // ───────────────────────────────────────────────

  /// La seule ombre autorisée — FAB, bottom sheet, snackbar.
  /// `0 4px 16px rgba(9, 5, 21, 0.12)`.
  static const Color shadowFloating = Color(0x1F090515);

  // ───────────────────────────────────────────────
  // GRADIENTS
  // ───────────────────────────────────────────────

  /// Dégradé Brand principal — splash, bannières, hero cards.
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryHover],
  );

  /// Dégradé sombre — overlays sur image, bottom sheets sur photo.
  static const heroOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x00000000), Color(0x80090515), Color(0xFF090515)],
  );

  /// Dégradé succès — badges de sync réussie.
  static const successGradient = LinearGradient(
    colors: [semanticSuccess, Color(0xFF00A87D)],
  );

  /// Dégradé erreur — banners d'erreur, badge OCR échoué.
  static const errorGradient = LinearGradient(
    colors: [semanticError, Color(0xFFE23B3B)],
  );

  // ───────────────────────────────────────────────
  // NEUTRES — échelle violette froide, cohérente avec l'encre
  // ───────────────────────────────────────────────

  static const Color neutral50 = Color(0xFFF8F7FC);
  static const Color neutral100 = Color(0xFFEEEDF7);
  static const Color neutral200 = Color(0xFFDDDBEF);
  static const Color neutral300 = Color(0xFFC3C0E0);
  static const Color neutral400 = Color(0xFF9C97C0);
  static const Color neutral500 = Color(0xFF766FA0);
  static const Color neutral600 = Color(0xFF564F7D);
  static const Color neutral700 = Color(0xFF3C365C);
  static const Color neutral800 = Color(0xFF241F3F);
  static const Color neutral900 = Color(0xFF120C24);
}
