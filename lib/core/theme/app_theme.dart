import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// APP COLORS — Toutes les couleurs du projet. Ne jamais utiliser Colors.*
// directement dans les widgets. Toujours passer par AppColors ou
// Theme.of(context).colorScheme.
// =============================================================================
class AppColors {
  // ── Palette de marque SRA V2 (alignée Next.js) ────────────────────────────

  /// Or cuivré principal — boutons, accents, icônes actives (#C5985B)
  static const Color gold      = Color(0xFFC5985B);

  /// Or clair — hover, variantes légères (#DDB87C)
  static const Color goldLight2 = Color(0xFFDDB87C);

  /// Or sombre — pressed, dégradé bas (#8F6B36)
  static const Color goldDark  = Color(0xFF8F6B36);

  /// Fond global pages — mode light (#F7F5F1)
  static const Color fog       = Color(0xFFF7F5F1);

  /// Surfaces secondaires, séparateurs — mode light (#EDE9E2)
  static const Color mist      = Color(0xFFEDE9E2);

  /// Blanc pur — cartes, inputs
  static const Color white     = Color(0xFFFFFFFF);

  /// Texte principal — mode light (#1A1B1B)
  static const Color ink       = Color(0xFF1A1B1B);

  /// Texte secondaire titres — mode light (#2C2D2E)
  static const Color inkSoft   = Color(0xFF2C2D2E);

  /// Texte désactivé, hints, labels gris à haut contraste (#4E4F52)
  static const Color inkMuted  = Color(0xFF4E4F52);

  /// Fond dark principal (scaffold) (#1A1A1A)
  static const Color darkSurface  = Color(0xFF1A1A1A);

  /// Fond dark secondaire (cartes, inputs) (#242322)
  static const Color darkCard     = Color(0xFF242322);

  /// Fond dark tertiaire (sections imbriquées) (#2E2C2A)
  static const Color darkElevated = Color(0xFF2E2C2A);

  /// Bordures dark (#3A3836)
  static const Color darkBorder   = Color(0xFF3A3836);

  // ── Dégradés ──────────────────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<Color> goldGradientColors = [gold, goldDark];

  // ── Statuts sémantiques ───────────────────────────────────────────────────
  static const Color statusSuccess = Color(0xFF22C55E);
  static const Color statusError   = Color(0xFFEF4444);
  static const Color statusWarning = Color(0xFFF97316);
  static const Color statusInfo    = Color(0xFF3B82F6);

  // ── Statuts chambre ───────────────────────────────────────────────────────
  static const Color statusToClean   = Color(0xFFE53E3E);
  static const Color statusCleaned   = Color(0xFFED8936);
  static const Color statusConfirmed = Color(0xFF3182CE);
  static const Color statusReady     = Color(0xFF38A169);

  // ── Couleurs paiement mobile money ────────────────────────────────────────
  static const Color paymentMTN    = Color(0xFFFFCC00);
  static const Color paymentMoov   = Color(0xFF00A2E8);
  static const Color paymentOrange = Color(0xFFFF6600);
  static const Color paymentWave   = Color(0xFF1D9BF0);

  static const Color surfaceLight      = white;
  static const Color surfaceDark       = darkSurface;
  static const Color overlayLight      = Color(0x1A000000);
  static const Color overlayDark       = Color(0x1AFFFFFF);
  static const Color overlayDarkMedium = Color(0xB3FFFFFF); // 70% blanc opaque pour la lisibilité
  static const Color darkTextSecondary = Color(0xD9FFFFFF); // 85% blanc opaque
  static const Color darkTextMuted     = Color(0xB3FFFFFF); // 70% blanc opaque
  static const Color textOnGold        = white;
  static const Color textOnDark        = white;
  static const Color textOnLight       = ink;

  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);
  static const Color white38 = Color(0x62FFFFFF);

  // ── Aliases retro-compatibilité (NE PAS UTILISER dans le nouveau code) ────
  // ignore: non_constant_identifier_names
  static const Color imperialNightBlue = darkSurface;
  // ignore: non_constant_identifier_names
  static const Color deepBlue          = darkCard;
  // ignore: non_constant_identifier_names
  static const Color champagneGold     = gold;
  // ignore: non_constant_identifier_names
  static const Color lightGold         = goldDark;
  // ignore: non_constant_identifier_names
  static const Color ecruWhite         = fog;
  // ignore: non_constant_identifier_names
  static const Color softGrey          = mist;
  // ignore: non_constant_identifier_names
  static const Color anthracite        = ink;
  // ignore: non_constant_identifier_names
  static const Color bronze            = goldDark;
  // ignore: non_constant_identifier_names
  static const Color textMuted         = inkMuted;
}

// =============================================================================
// APP DIMENSIONS — Toutes les mesures, espacements et rayons. Ne jamais
// utiliser de valeurs numériques brutes dans les pages et widgets.
// =============================================================================
class AppDimensions {
  // ── Espacements ───────────────────────────────────────────────────────────
  static const double spacingXs  = 4.0;
  static const double spacingSm  = 8.0;
  static const double spacingMd  = 16.0;
  static const double spacingLg  = 24.0;
  static const double spacingXl  = 32.0;
  static const double spacingXxl = 48.0;

  // ── Rayons de bordure ─────────────────────────────────────────────────────
  static const double radiusNone = 0.0;
  static const double radiusXs   = 4.0;
  static const double radiusSm   = 10.0;
  static const double radiusMd   = 18.0;
  static const double radiusLg   = 24.0;
  static const double radiusXl   = 28.0;
  static const double radiusXxl  = 32.0;
  static const double radiusFull = 999.0;

  // ── Épaisseurs de bordure ─────────────────────────────────────────────────
  static const double borderHair   = 0.5;
  static const double borderThin   = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick  = 2.0;

  // ── Composants UI ─────────────────────────────────────────────────────────
  static const double inputHeight      = 52.0;
  static const double buttonHeight     = 50.0;
  static const double buttonHeightSm   = 40.0;
  static const double iconSizeSm       = 16.0;
  static const double iconSizeMd       = 20.0;
  static const double iconSizeLg       = 24.0;
  static const double iconSizeXl       = 32.0;
  static const double logoSize         = 80.0;
  static const double avatarSizeSm     = 32.0;
  static const double avatarSizeMd     = 48.0;
  static const double avatarSizeLg     = 64.0;
  static const double avatarSize       = 48.0;
  static const double bottomNavHeight  = 64.0;
  static const double appBarHeight     = 56.0;

  // ── Mise en page ──────────────────────────────────────────────────────────
  static const double formMaxWidth             = 500.0;
  static const double sidebarWidth             = 240.0;
  static const double cardElevation            = 0.0;
  static const double responsiveCardMaxExtent  = 480.0;
  static const double responsiveCardMainExtent = 200.0;
  static const double pagePaddingH             = spacingLg;
  static const double pagePaddingV             = spacingMd;
  static const double cardPaddingH             = spacingMd;
  static const double cardPaddingV             = spacingMd;

  // ── Breakpoints responsive ────────────────────────────────────────────────
  static const double breakpointSm = 480.0;
  static const double breakpointMd = 600.0;
  static const double breakpointLg = 1024.0;

  // ── Gaps réutilisables (Vertical & Horizontal) ────────────────────────────
  static const SizedBox gapXs  = SizedBox(height: spacingXs, width: spacingXs);
  static const SizedBox gapSm  = SizedBox(height: spacingSm, width: spacingSm);
  static const SizedBox gapMd  = SizedBox(height: spacingMd, width: spacingMd);
  static const SizedBox gapLg  = SizedBox(height: spacingLg, width: spacingLg);
  static const SizedBox gapXl  = SizedBox(height: spacingXl, width: spacingXl);

  static const SizedBox vGapXs = SizedBox(height: spacingXs);
  static const SizedBox vGapSm = SizedBox(height: spacingSm);
  static const SizedBox vGapMd = SizedBox(height: spacingMd);
  static const SizedBox vGapLg = SizedBox(height: spacingLg);
  static const SizedBox vGapXl = SizedBox(height: spacingXl);

  static const SizedBox hGapXs = SizedBox(width: spacingXs);
  static const SizedBox hGapSm = SizedBox(width: spacingSm);
  static const SizedBox hGapMd = SizedBox(width: spacingMd);
  static const SizedBox hGapLg = SizedBox(width: spacingLg);
  static const SizedBox hGapXl = SizedBox(width: spacingXl);

  // ── Paddings réutilisables ────────────────────────────────────────────────
  static const EdgeInsets paddingXsAll = EdgeInsets.all(spacingXs);
  static const EdgeInsets paddingSmAll = EdgeInsets.all(spacingSm);
  static const EdgeInsets paddingMdAll = EdgeInsets.all(spacingMd);
  static const EdgeInsets paddingLgAll = EdgeInsets.all(spacingLg);
  static const EdgeInsets paddingXlAll = EdgeInsets.all(spacingXl);
}

// =============================================================================
// APP SHADOWS — Ombres portées réutilisables. Ne jamais hardcoder BoxShadow.
// =============================================================================
class AppShadows {
  /// Ombre standard pour les cartes blanches sur fond crème
  static const BoxShadow card = BoxShadow(
    color: Color(0x24212222), offset: Offset(0, 8),
    blurRadius: 24, spreadRadius: -4,
  );

  /// Ombre douce pour les grandes sections
  static const BoxShadow soft = BoxShadow(
    color: Color(0x14212222), offset: Offset(0, 16),
    blurRadius: 40, spreadRadius: -8,
  );

  /// Ombre dorée incandescente — boutons gold
  static const BoxShadow gold = BoxShadow(
    color: Color(0x6E8F6B36), offset: Offset(0, 8),
    blurRadius: 20, spreadRadius: -4,
  );

  /// Ombre dorée réduite — état disabled
  static const BoxShadow goldDisabled = BoxShadow(
    color: Color(0x268F6B36), offset: Offset(0, 4),
    blurRadius: 12, spreadRadius: -2,
  );

  /// Ombre flottante — FAB, modales
  static const BoxShadow floating = BoxShadow(
    color: Color(0x30212222), offset: Offset(0, 12),
    blurRadius: 32, spreadRadius: -6,
  );

  // ── Aliases retro-compatibilité ───────────────────────────────────────────
  static const BoxShadow shadowCard         = card;
  static const BoxShadow shadowSoft         = soft;
  static const BoxShadow shadowGold         = gold;
  static const BoxShadow shadowGoldDisabled = goldDisabled;
}

// =============================================================================
// APP TEXT STYLES — Styles typographiques réutilisables.
// RÈGLE : Ne jamais appeler GoogleFonts.* directement dans les widgets/pages.
//         Polices : Playfair Display (titres serif) + Raleway (corps sans-serif).
// =============================================================================
class AppTextStyles {
  // ── Titres display (Playfair Display — prestige, serif) ───────────────────

  static TextStyle get displayXl => GoogleFonts.playfairDisplay(
    fontSize: 40, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.15,
  );

  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.2,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.25,
  );

  static TextStyle get displaySmall => GoogleFonts.playfairDisplay(
    fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.3,
  );

  // ── Titres section (Playfair Display) ─────────────────────────────────────

  static TextStyle get titleLarge => GoogleFonts.playfairDisplay(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.35,
  );

  static TextStyle get titleMedium => GoogleFonts.playfairDisplay(
    fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.ink, height: 1.35,
  );

  static TextStyle get titleSmall => GoogleFonts.playfairDisplay(
    fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.ink, height: 1.4,
  );

  // ── Corps de texte (Raleway — modernité, lisibilité) ──────────────────────

  static TextStyle get bodyLarge => GoogleFonts.raleway(
    fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.ink, height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.raleway(
    fontSize: 14.5, fontWeight: FontWeight.w500, color: AppColors.inkSoft, height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.raleway(
    fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.inkMuted, height: 1.45,
  );

  // ── Labels (Raleway — UI, formulaires) ────────────────────────────────────

  /// Label uppercase doré — titres de champs, SectionHeader
  static TextStyle get labelUppercase => GoogleFonts.raleway(
    fontSize: 11.5, fontWeight: FontWeight.w700,
    letterSpacing: 1.8, color: AppColors.gold, height: 1.2,
  );

  /// Label muted — sous-titres de section, méta-données
  static TextStyle get labelMuted => GoogleFonts.raleway(
    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.inkMuted, height: 1.4,
  );

  /// Label standard — tags, chips
  static TextStyle get labelNormal => GoogleFonts.raleway(
    fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inkSoft, height: 1.4,
  );

  // ── Boutons (Raleway — uppercase, serré) ──────────────────────────────────

  static TextStyle get buttonLabel => GoogleFonts.raleway(
    fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.6, height: 1.2,
  );

  static TextStyle get buttonLabelSm => GoogleFonts.raleway(
    fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.4, height: 1.2,
  );

  // ── Prix (Playfair Display — prestige) ────────────────────────────────────

  static TextStyle get priceLarge => GoogleFonts.playfairDisplay(
    fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.1,
  );

  static TextStyle get priceMedium => GoogleFonts.playfairDisplay(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.2,
  );

  static TextStyle get priceSmall => GoogleFonts.playfairDisplay(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.3,
  );

  // ── Monospace (codes, références, factures) ───────────────────────────────
  static const TextStyle monospace = TextStyle(
    fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.w400,
  );

  static const TextStyle monospaceLg = TextStyle(
    fontFamily: 'monospace', fontSize: 14, fontWeight: FontWeight.w500,
  );
}

// =============================================================================
// APP THEME — Configuration des thèmes clair et sombre.
// =============================================================================
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.gold,
      colorScheme: const ColorScheme.light(
        primary:                 AppColors.gold,
        onPrimary:               AppColors.white,
        secondary:               AppColors.goldDark,
        onSecondary:             AppColors.white,
        surface:                 AppColors.white,
        onSurface:               AppColors.ink,
        surfaceContainerHighest: AppColors.fog,
        error:                   AppColors.statusError,
        onError:                 AppColors.white,
        outline:                 AppColors.mist,
      ),
      scaffoldBackgroundColor: AppColors.fog,
      textTheme: GoogleFonts.ralewayTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge:  AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall:  AppTextStyles.displaySmall,
        titleLarge:    AppTextStyles.titleLarge,
        titleMedium:   AppTextStyles.titleMedium,
        titleSmall:    AppTextStyles.titleSmall,
        bodyLarge:     AppTextStyles.bodyLarge,
        bodyMedium:    AppTextStyles.bodyMedium,
        bodySmall:     AppTextStyles.bodySmall,
        labelLarge:    AppTextStyles.buttonLabel,
        labelSmall:    AppTextStyles.labelUppercase,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor:  AppColors.white,
        foregroundColor:  AppColors.ink,
        elevation:        AppDimensions.cardElevation,
        centerTitle:      false,
        iconTheme:        IconThemeData(color: AppColors.gold),
        actionsIconTheme: IconThemeData(color: AppColors.gold),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.mist, thickness: AppDimensions.borderHair,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.white,
        labelStyle: AppTextStyles.labelUppercase,
        hintStyle: GoogleFonts.raleway(
          fontSize: 13, fontWeight: FontWeight.w300, color: AppColors.inkMuted,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd, vertical: AppDimensions.spacingMd,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.mist),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.mist, width: AppDimensions.borderThin),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.gold, width: AppDimensions.borderMedium),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.statusError, width: AppDimensions.borderThin),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.statusError, width: AppDimensions.borderMedium),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
          elevation: AppDimensions.cardElevation,
          textStyle: AppTextStyles.buttonLabel,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold, width: AppDimensions.borderMedium),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
          textStyle: AppTextStyles.buttonLabel,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold, textStyle: AppTextStyles.buttonLabel,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white, elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.mist, selectedColor: AppColors.gold,
        labelStyle: AppTextStyles.labelNormal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
      ),
      iconTheme:        const IconThemeData(color: AppColors.inkSoft, size: AppDimensions.iconSizeLg),
      primaryIconTheme: const IconThemeData(color: AppColors.gold,    size: AppDimensions.iconSizeLg),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkCard,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
        titleTextStyle:   AppTextStyles.titleLarge,
        contentTextStyle: AppTextStyles.bodyMedium,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor:     AppColors.white,
        selectedItemColor:   AppColors.gold,
        unselectedItemColor: AppColors.inkMuted,
        elevation:           0,
        type:                BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.gold,
      colorScheme: const ColorScheme.dark(
        primary:                 AppColors.gold,
        onPrimary:               AppColors.white,
        secondary:               AppColors.goldDark,
        onSecondary:             AppColors.white,
        surface:                 AppColors.darkCard,
        onSurface:               AppColors.white,
        surfaceContainerHighest: AppColors.darkElevated,
        error:                   AppColors.statusError,
        onError:                 AppColors.white,
        outline:                 AppColors.darkBorder,
      ),
      scaffoldBackgroundColor: AppColors.darkSurface,
      textTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge:  AppTextStyles.displayLarge.copyWith(color: AppColors.gold),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.gold),
        displaySmall:  AppTextStyles.displaySmall.copyWith(color: AppColors.goldLight2),
        titleLarge:    AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        titleMedium:   AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        titleSmall:    AppTextStyles.titleSmall.copyWith(color: AppColors.white),
        bodyLarge:     AppTextStyles.bodyLarge.copyWith(color: AppColors.white),
        bodyMedium:    AppTextStyles.bodyMedium.copyWith(color: AppColors.darkTextSecondary),
        bodySmall:     AppTextStyles.bodySmall.copyWith(color: AppColors.darkTextMuted),
        labelLarge:    AppTextStyles.buttonLabel,
        labelSmall:    AppTextStyles.labelUppercase,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor:  AppColors.darkCard,
        foregroundColor:  AppColors.gold,
        elevation:        AppDimensions.cardElevation,
        centerTitle:      false,
        iconTheme:        IconThemeData(color: AppColors.gold),
        actionsIconTheme: IconThemeData(color: AppColors.gold),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder, thickness: AppDimensions.borderHair,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.darkCard,
        labelStyle: AppTextStyles.labelUppercase,
        hintStyle: GoogleFonts.raleway(
          fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0x99FFFFFF),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMd, vertical: AppDimensions.spacingMd,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.darkBorder),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.darkBorder, width: AppDimensions.borderThin),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.gold, width: AppDimensions.borderMedium),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.statusError, width: AppDimensions.borderThin),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.statusError, width: AppDimensions.borderMedium),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
          elevation: AppDimensions.cardElevation,
          textStyle: AppTextStyles.buttonLabel,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold, width: AppDimensions.borderMedium),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
          textStyle: AppTextStyles.buttonLabel,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold, textStyle: AppTextStyles.buttonLabel,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard, elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkElevated, selectedColor: AppColors.gold,
        labelStyle: AppTextStyles.labelNormal.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
      ),
      iconTheme:        const IconThemeData(color: AppColors.overlayDarkMedium, size: AppDimensions.iconSizeLg),
      primaryIconTheme: const IconThemeData(color: AppColors.gold,              size: AppDimensions.iconSizeLg),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkElevated,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusXl)),
        titleTextStyle:   AppTextStyles.titleLarge.copyWith(color: AppColors.white),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.overlayDarkMedium),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor:     AppColors.darkCard,
        selectedItemColor:   AppColors.gold,
        unselectedItemColor: AppColors.inkMuted,
        elevation:           0,
        type:                BottomNavigationBarType.fixed,
      ),
    );
  }
}
