import 'package:flutter/material.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/display/language_selector.dart';
import 'package:sra_hotel/core/widgets/display/sra_logo.dart';
import 'package:sra_hotel/main.dart';

/// Layout Shell pour les pages d'authentification — Reproduction Pixel-Perfect de `AuthShell.tsx`.
///
/// Sur grand écran (width >= 1024px) : Split-screen avec panneau de gauche Anthracite "Espace Sécurisé"
/// + cercles décoratifs dorés + indicateurs de confiance.
/// Sur petit écran (< 1024px) : Disposition mono-colonne réactive.
class AuthShell extends StatelessWidget {
  final Widget child;

  const AuthShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= AppDimensions.breakpointLg;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLocale = Localizations.localeOf(context);

    final bgRight = isDark ? AppColors.darkSurface : AppColors.fog;

    return Scaffold(
      backgroundColor: bgRight,
      body: SafeArea(
        child: isWide
            ? Row(
                children: [
                  // ── Panneau de gauche Anthracite (Grand Écran >= 1024px) ──
                  Expanded(
                    flex: 11,
                    child: _AuthLeftPanel(
                      currentLocale: currentLocale,
                    ),
                  ),

                  // ── Zone de contenu principal (Formulaire à droite) ──
                  Expanded(
                    flex: 10,
                    child: _AuthRightPanel(
                      currentLocale: currentLocale,
                      child: child,
                    ),
                  ),
                ],
              )
            : _AuthMobileLayout(
                currentLocale: currentLocale,
                child: child,
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Panneau de gauche Anthracite (Grand écran)
// ─────────────────────────────────────────────────────────────────────────────

class _AuthLeftPanel extends StatelessWidget {
  final Locale currentLocale;

  const _AuthLeftPanel({required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkSurface,
      padding: const EdgeInsets.all(AppDimensions.spacingXl * 1.5),
      child: Stack(
        children: [
          // ── Cercle décoratif doré 1 ──
          Positioned(
            top: -120,
            right: -140,
            child: Container(
              width: 420,
              height: 420,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.22),
                  width: AppDimensions.borderThin,
                ),
              ),
            ),
          ),

          // ── Cercle décoratif doré 2 ──
          Positioned(
            bottom: -130,
            right: 60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  width: AppDimensions.borderThin,
                ),
              ),
            ),
          ),

          // ── Contenu principal du panneau ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // En-tête : Marque & Commutateur de Thème
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SraLogo(height: AppDimensions.avatarSizeLg),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Theme.of(context).brightness == Brightness.dark
                              ? Icons.wb_sunny_outlined
                              : Icons.dark_mode_outlined,
                          color: AppColors.gold,
                        ),
                        onPressed: () {
                          final current = MyApp.getThemeMode(context);
                          final next = current == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                          MyApp.setThemeMode(context, next);
                        },
                      ),
                      LanguageSelector(
                        currentLocale: currentLocale,
                        onLocaleChanged: (locale) => MyApp.setLocale(context, locale),
                      ),
                    ],
                  ),
                ],
              ),

              // Centre : Titre & Points de confiance
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 510),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "ESPACE SÉCURISÉ",
                      style: AppTextStyles.labelUppercase.copyWith(
                        color: AppColors.gold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    AppDimensions.vGapSm,
                    Text(
                      "L’hospitalité commence par la confiance.",
                      style: AppTextStyles.displayXl.copyWith(
                        color: AppColors.white,
                        fontSize: 46,
                        height: 1.05,
                      ),
                    ),
                    AppDimensions.vGapLg,
                    Text(
                      "Accédez à vos outils, vos séjours et vos services en toute simplicité, avec une vérification pensée pour votre sécurité.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.75),
                        height: 1.6,
                      ),
                    ),
                    AppDimensions.vGapXl,
                    const Row(
                      children: [
                        _TrustPoint(
                          icon: Icons.shield_outlined,
                          label: "Accès chiffré",
                        ),
                        AppDimensions.hGapLg,
                        _TrustPoint(
                          icon: Icons.vpn_key_outlined,
                          label: "Vérification renforcée",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Pied de page
              Text(
                "© 2026 Sweet Rest Aparthotel · Abidjan",
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.white.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrustPoint extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TrustPoint({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.gold, size: AppDimensions.iconSizeMd),
        AppDimensions.hGapXs,
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Panneau de droite (Grand écran)
// ─────────────────────────────────────────────────────────────────────────────

class _AuthRightPanel extends StatelessWidget {
  final Locale currentLocale;
  final Widget child;

  const _AuthRightPanel({
    required this.currentLocale,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Layout Mobile / Tablette (< 1024px)
// ─────────────────────────────────────────────────────────────────────────────

class _AuthMobileLayout extends StatelessWidget {
  final Locale currentLocale;
  final Widget child;

  const _AuthMobileLayout({
    required this.currentLocale,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMd,
            vertical: AppDimensions.spacingSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SraLogo(height: AppDimensions.avatarSizeLg),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.wb_sunny_outlined
                          : Icons.dark_mode_outlined,
                      color: AppColors.gold,
                    ),
                    onPressed: () {
                      final current = MyApp.getThemeMode(context);
                      final next = current == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark;
                      MyApp.setThemeMode(context, next);
                    },
                  ),
                  LanguageSelector(
                    currentLocale: currentLocale,
                    onLocaleChanged: (locale) => MyApp.setLocale(context, locale),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
