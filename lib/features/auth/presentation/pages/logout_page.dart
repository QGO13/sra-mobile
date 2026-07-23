import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page de confirmation de déconnexion — Reproduction Pixel-Perfect de `LogoutPage.tsx`.
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.mist;
    final infoBg = isDark ? AppColors.white.withValues(alpha: 0.05) : const Color(0xFFF6F1E8);

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
            // ── Cercle d'icône 58x58 Or ──
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.16),
              ),
              child: const Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.gold,
                size: 28,
              ),
            ),
            AppDimensions.vGapLg,

            // ── Tag FIN DE SESSION ──
            Text(
              l10n.endOfSessionHeader,
              style: AppTextStyles.labelUppercase.copyWith(
                color: AppColors.gold,
                letterSpacing: 2.0,
              ),
            ),
            AppDimensions.vGapXs,

            // ── Titre "Vous nous quittez déjà ?" ──
            Text(
              l10n.leavingUsAlreadyTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.displayMedium.copyWith(
                fontSize: 34,
                height: 1.1,
                color: isDark ? AppColors.white : AppColors.ink,
              ),
            ),
            AppDimensions.vGapXs,

            // ── Description ──
            Text(
              l10n.logoutSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: textMuted,
              ),
            ),
            AppDimensions.vGapLg,

            // ── Encadré d'information de sécurité ──
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              decoration: BoxDecoration(
                color: infoBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lock_outlined,
                    color: AppColors.gold,
                    size: 19,
                  ),
                  AppDimensions.hGapSm,
                  Expanded(
                    child: Text(
                      l10n.logoutSecurityNotice,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textMuted,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppDimensions.vGapLg,

            // ── Alerte d'annulation si cliqué sur Rester connecté(e) ──
            if (_cancelled) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingSm,
                  vertical: AppDimensions.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  border: Border.all(
                    color: AppColors.gold,
                    width: AppDimensions.borderThin,
                  ),
                ),
                child: Text(
                  l10n.sessionStillActive,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AppDimensions.vGapLg,
            ],

            // ── Boutons d'action ──
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
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.mist,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingMd,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      ),
                    ),
                  ),
                ),
                AppDimensions.hGapMd,
                Expanded(
                  child: SraButton(
                    label: l10n.logMeOutButton,
                    onPressed: _logout,
                  ),
                ),
              ],
            ),
            AppDimensions.vGapLg,

            const Divider(),
            AppDimensions.vGapMd,

            // ── Pied de page ──
            Text(
              l10n.needHelpContactReception,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
