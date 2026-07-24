import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page de confirmation de déconnexion — Pixel-Perfect de `LogoutPage.tsx`.
///
/// Structure : cercle icône 58×58 · centré · titre · encadré sécurité crème
/// · alerte annulation (SraAlert or) · deux boutons côte à côte.
class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  bool _cancelled = false;

  void _logout() {
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
      arguments: {'signedOut': true},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n   = AppLocalizations.of(context)!;
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final textMuted  = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final cardBg     = isDark ? AppColors.darkCard  : AppColors.white;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.mist;
    // Fond de l'encadré sécurité : crème #F6F1E8 light / blanc 5% dark
    final securityBg = isDark
        ? AppColors.white.withValues(alpha: 0.05)
        : const Color(0xFFF6F1E8);

    return AuthShell(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(color: cardBorder, width: AppDimensions.borderThin),
          boxShadow: const [AppShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [

            // ── Cercle icône 58×58 ─────────────────────────────────────────
            Container(
              width: 58, height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: isDark ? 0.20 : 0.16),
              ),
              child: const Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.goldDark,
                size: 28,
              ),
            ),
            AppDimensions.vGapLg,

            // ── Overline or ────────────────────────────────────────────────
            Text(
              l10n.endOfSessionHeader,
              style: AppTextStyles.labelUppercase.copyWith(color: AppColors.goldDark),
            ),
            AppDimensions.vGapXs,

            // ── Titre Cormorant ────────────────────────────────────────────
            Text(
              l10n.leavingUsAlreadyTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.displayMedium.copyWith(
                fontSize: 34, height: 1.1,
                color: isDark ? AppColors.white : AppColors.ink,
              ),
            ),
            AppDimensions.vGapXs,

            // ── Sous-titre ─────────────────────────────────────────────────
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340),
              child: Text(
                l10n.logoutSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: textMuted),
              ),
            ),
            AppDimensions.vGapLg,

            // ── Encadré sécurité crème ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              decoration: BoxDecoration(
                color: securityBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lock_outlined, color: AppColors.goldDark, size: 19),
                  AppDimensions.hGapSm,
                  Expanded(
                    child: Text(
                      l10n.logoutSecurityNotice,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textMuted, height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppDimensions.vGapLg,

            // ── Alerte annulation ──────────────────────────────────────────
            if (_cancelled) ...[
              SraAlert.info(message: l10n.sessionStillActive),
              AppDimensions.vGapLg,
            ],

            // ── Boutons ────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _cancelled = true);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.arrow_back_rounded, size: AppDimensions.iconSizeSm),
                    label: Text(l10n.staySignedIn),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppColors.white : AppColors.ink,
                      side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.mist),
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingMd),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      ),
                      textStyle: AppTextStyles.buttonLabel,
                    ),
                  ),
                ),
                AppDimensions.hGapMd,
                Expanded(
                  child: SraButton(
                    label: l10n.logMeOutButton,
                    onPressed: _logout,
                    leadingIcon: Icons.exit_to_app_rounded,
                  ),
                ),
              ],
            ),

            const Divider(height: AppDimensions.spacingXl * 1.5),

            // ── Pied de page ───────────────────────────────────────────────
            Text(
              l10n.needHelpContactReception,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: textMuted,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
