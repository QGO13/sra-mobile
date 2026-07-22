import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// APP COLORS — Toutes les couleurs du projet. Ne jamais utiliser Colors.*
// directement dans les widgets. Toujours passer par AppColors ou
// Theme.of(context).colorScheme.
// =============================================================================
class AppColors {
  // --- Palette de marque SRA V2 ---
  static const Color imperialNightBlue = Color(0xFF1A1A1A); // Anthracite — fond dark, texte principal
  static const Color deepBlue          = Color(0xFF242322); // Anthracite Soft — surfaces secondaires dark
  static const Color champagneGold     = Color(0xFFD4AF37); // Gold 1 — accent prestige
  static const Color lightGold         = Color(0xFFAA7C11); // Gold 2 — accent prestige plus sombre
  static const Color ecruWhite         = Color(0xFFFAF8F5); // Cream/Fog — fond light
  static const Color softGrey          = Color(0xFFEDE9E2); // Mist — bordures fines 1px
  static const Color anthracite        = Color(0xFF1A1A1A); // Texte principal
  static const Color bronze            = Color(0xFF8C6221); // Bronze Satiné — sous-titres, bordures décoratives

  // --- Dégradé Or Prestige V2 ---
  static const List<Color> goldGradientColors = [Color(0xFFD4AF37), Color(0xFFAA7C11)];
  static const LinearGradient goldGradient = LinearGradient(
    colors: goldGradientColors,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Statuts sémantiques (remplacent Colors.green, Colors.red, etc.) ---
  static const Color statusSuccess = Color(0xFF22C55E); // Propre / Validé / Payé
  static const Color statusError   = Color(0xFFEF4444); // Erreur / Annulé / À nettoyer
  static const Color statusWarning = Color(0xFFF97316); // Avertissement / En attente
  static const Color statusInfo    = Color(0xFF3B82F6); // Info / Confirmé / Réservé
  static const Color textMuted     = Color(0xFF9CA3AF); // Texte secondaire / labels gris

  // --- Statuts chambre (existants — conservés) ---
  static const Color statusToClean   = Color(0xFFE53E3E); // Rouge — À nettoyer
  static const Color statusCleaned   = Color(0xFFED8936); // Orange — Nettoyage en cours
  static const Color statusConfirmed = Color(0xFF3182CE); // Bleu — Confirmé
  static const Color statusReady     = Color(0xFF38A169); // Vert — Prête / Libre

  // --- Couleurs paiement mobile money ---
  static const Color paymentMTN    = Color(0xFFFFCC00); // MTN Mobile Money
  static const Color paymentMoov   = Color(0xFF00A2E8); // Moov Money
  static const Color paymentOrange = Color(0xFFFF6600); // Orange Money
  static const Color paymentWave   = Color(0xFF1D9BF0); // Wave

  // --- Surfaces adaptatives (utiles pour dark/light sans Colors.white/black) ---
  static const Color surfaceLight     = Color(0xFFFFFFFF);
  static const Color surfaceDark      = Color(0xFF1A1A1A);
  static const Color overlayLight     = Color(0x1A000000); // Colors.black12
  static const Color overlayDark      = Color(0x1AFFFFFF); // Colors.white12
  static const Color overlayDarkMedium = Color(0x3DFFFFFF); // Colors.white24
  static const Color textOnGold       = Color(0xFFFFFFFF);
  static const Color textOnDark       = Color(0xFFFFFFFF);
  static const Color textOnLight      = Color(0xFF1A1A1A);
}

// =============================================================================
// APP DIMENSIONS — Toutes les mesures, espacements et rayons. Ne jamais
// utiliser de valeurs numériques brutes dans les pages et widgets.
// =============================================================================
class AppDimensions {
  // --- Espacements verticaux / horizontaux ---
  static const double spacingXs  = 4.0;
  static const double spacingSm  = 8.0;
  static const double spacingMd  = 16.0;
  static const double spacingLg  = 24.0;
  static const double spacingXl  = 32.0;
  static const double spacingXxl = 48.0;

  // --- Rayons de bordure (BorderRadius.circular) ---
  static const double radiusNone = 0.0;   // Design flat luxury (défaut SRA)
  static const double radiusXs   = 2.0;
  static const double radiusSm   = 10.0;  // V2 adouci pour inputs
  static const double radiusMd   = 18.0;  // V2 adouci pour cartes moyennes (paniers, etc.)
  static const double radiusLg   = 28.0;  // V2 adouci pour grandes cartes et formulaires
  static const double radiusXl   = 32.0;
  static const double radiusFull = 999.0; // V2 pour boutons pilules

  // --- Épaisseurs de bordure ---
  static const double borderThin   = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick  = 2.0;

  // --- Composants UI ---
  static const double inputHeight  = 52.0;
  static const double buttonHeight = 48.0;
  static const double iconSizeSm   = 16.0;
  static const double iconSizeMd   = 20.0;
  static const double iconSizeLg   = 24.0;
  static const double logoSize     = 80.0;
  static const double avatarSize   = 48.0;

  // --- Mise en page ---
  static const double formMaxWidth    = 500.0;
  static const double sidebarWidth    = 240.0;
  static const double cardElevation   = 0.0; // Design flat luxury
  static const double responsiveCardMaxExtent = 480.0;
  static const double responsiveCardMainExtent = 200.0;
  static const double pagePaddingH    = spacingLg; // Padding horizontal des pages
  static const double pagePaddingV    = spacingMd; // Padding vertical des pages

  // --- Breakpoints responsive ---
  static const double breakpointMd   = 600.0;  // Tablette
  static const double breakpointLg   = 1024.0; // Bureau / Web
}

// =============================================================================
// APP SHADOWS — Ombres portées réutilisables (V2 Design System). Évite de 
// hardcoder des BoxShadow dans les pages et widgets.
// =============================================================================
class AppShadows {
  // Ombre standard pour les cartes blanches sur fond crème
  static const BoxShadow shadowCard = BoxShadow(
    color: Color(0x591A1A1A), // 35% opacity of #1A1A1A
    offset: Offset(0, 14),
    blurRadius: 34,
    spreadRadius: -18,
  );

  // Ombre plus diffuse pour les grandes sections ou les formulaires
  static const BoxShadow shadowSoft = BoxShadow(
    color: Color(0x401A1A1A), // 25% opacity of #1A1A1A
    offset: Offset(0, 20),
    blurRadius: 50,
    spreadRadius: -20,
  );

  // Ombre dorée incandescente (Boutons dorés)
  static const BoxShadow shadowGold = BoxShadow(
    color: Color(0x8CAA7C11), // 55% opacity of #AA7C11
    offset: Offset(0, 10),
    blurRadius: 24,
    spreadRadius: -8,
  );

  // Ombre dorée incandescente réduite (Boutons dorés désactivés)
  static const BoxShadow shadowGoldDisabled = BoxShadow(
    color: Color(0x26AA7C11), // 15% opacity of #AA7C11
    offset: Offset(0, 8),
    blurRadius: 20,
    spreadRadius: -6,
  );
}

// =============================================================================
// APP TEXT STYLES — Styles typographiques réutilisables. Évite les appels
// GoogleFonts.* directs dans les widgets. Préférer Theme.of(context).textTheme
// quand possible, sinon utiliser ces constantes.
// =============================================================================
class AppTextStyles {
  // --- Titres (Cormorant Garamond V2) ---
  static TextStyle get displayLarge => GoogleFonts.cormorantGaramond(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.anthracite,
  );

  static TextStyle get displayMedium => GoogleFonts.cormorantGaramond(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.anthracite,
  );

  static TextStyle get titleLarge => GoogleFonts.cormorantGaramond(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.anthracite,
  );

  static TextStyle get titleMedium => GoogleFonts.cormorantGaramond(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // --- Corps (Montserrat V2) ---
  static TextStyle get bodyLarge => GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );

  static TextStyle get bodySmall => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.textMuted,
  );

  // --- Labels majuscules (style SRA V2) ---
  static TextStyle get labelUppercase => GoogleFonts.montserrat(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.8,
    color: AppColors.champagneGold,
  );

  static TextStyle get labelMuted => GoogleFonts.montserrat(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // --- Monospace (pour codes, numéros de référence, factures) ---
  static const TextStyle monospace = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle monospaceLg = TextStyle(
    fontFamily: 'monospace',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // --- Boutons ---
  static TextStyle get buttonLabel => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.4,
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
      primaryColor: AppColors.champagneGold,
      colorScheme: const ColorScheme.light(
        primary: AppColors.champagneGold,
        secondary: AppColors.lightGold,
        surface: AppColors.surfaceLight,
        onPrimary: AppColors.textOnGold,
        onSecondary: AppColors.textOnLight,
        error: AppColors.statusError,
        outline: AppColors.softGrey,
        surfaceContainerHighest: AppColors.ecruWhite,
      ),
      scaffoldBackgroundColor: AppColors.ecruWhite,
      textTheme: GoogleFonts.montserratTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        titleLarge: AppTextStyles.titleLarge,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.imperialNightBlue,
        elevation: AppDimensions.cardElevation,
        iconTheme: IconThemeData(color: AppColors.champagneGold),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.softGrey,
        thickness: AppDimensions.borderThin,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.softGrey),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.softGrey, width: AppDimensions.borderThin),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.champagneGold, width: AppDimensions.borderMedium),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        filled: true,
        fillColor: AppColors.surfaceLight,
        labelStyle: AppTextStyles.labelUppercase,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.champagneGold,
          foregroundColor: AppColors.textOnGold,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
          textStyle: AppTextStyles.buttonLabel,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.champagneGold,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.champagneGold,
        secondary: AppColors.lightGold,
        surface: AppColors.surfaceDark,
        onPrimary: AppColors.textOnLight,
        onSecondary: AppColors.textOnDark,
        error: AppColors.statusError,
        outline: AppColors.deepBlue,
        surfaceContainerHighest: AppColors.deepBlue,
      ),
      scaffoldBackgroundColor: AppColors.imperialNightBlue,
      textTheme: GoogleFonts.montserratTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.champagneGold),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.champagneGold),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.champagneGold),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.imperialNightBlue,
        foregroundColor: AppColors.champagneGold,
        elevation: AppDimensions.cardElevation,
        iconTheme: IconThemeData(color: AppColors.champagneGold),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.deepBlue,
        thickness: AppDimensions.borderThin,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.deepBlue),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.deepBlue, width: AppDimensions.borderThin),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.champagneGold, width: AppDimensions.borderMedium),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        ),
        filled: true,
        fillColor: AppColors.deepBlue,
        labelStyle: AppTextStyles.labelUppercase,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.champagneGold,
          foregroundColor: AppColors.textOnLight,
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
          textStyle: AppTextStyles.buttonLabel,
        ),
      ),
    );
  }
}
