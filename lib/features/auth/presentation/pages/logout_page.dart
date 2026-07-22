import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/main.dart';

/// Page de déconnexion — Reproduction Pixel-Perfect de `LogoutPage.tsx`.
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLocale = Localizations.localeOf(context);

    final bgPage = isDark ? AppColors.darkSurface : AppColors.fog;
    final textMuted = isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted;

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          LanguageSelector(
            currentLocale: currentLocale,
            onLocaleChanged: (newLocale) {
              MyApp.setLocale(context, newLocale);
            },
          ),
          AppDimensions.hGapMd,
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingLg,
              vertical: AppDimensions.spacingXl,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: SraCard(
                padding: const EdgeInsets.all(AppDimensions.spacingXl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: AppDimensions.avatarSizeLg,
                      height: AppDimensions.avatarSizeLg,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.exit_to_app_rounded,
                        color: AppColors.gold,
                        size: AppDimensions.iconSizeXl,
                      ),
                    ),
                    AppDimensions.vGapLg,

                    Text(
                      "FIN DE SESSION",
                      style: AppTextStyles.labelUppercase.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                    AppDimensions.vGapXs,
                    Text(
                      "Vous nous quittez déjà ?",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? AppColors.white : AppColors.ink,
                      ),
                    ),
                    AppDimensions.vGapXs,
                    Text(
                      "Votre session sera fermée sur cet appareil. Vous pourrez vous reconnecter à tout moment.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textMuted,
                      ),
                    ),
                    AppDimensions.vGapLg,

                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spacingMd),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkElevated : AppColors.fog,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            color: AppColors.gold,
                            size: AppDimensions.iconSizeMd,
                          ),
                          AppDimensions.hGapSm,
                          Expanded(
                            child: Text(
                              "Pour votre sécurité, fermez votre navigateur après la déconnexion sur un appareil partagé.",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_cancelled) ...[
                      AppDimensions.vGapLg,
                      Text(
                        "Votre session reste active.",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.statusSuccess,
                        ),
                      ),
                    ],

                    AppDimensions.vGapXl,

                    Row(
                      children: [
                        Expanded(
                          child: SraButton.secondary(
                            label: "RESTER CONNECTÉ(E)",
                            onPressed: () => setState(() => _cancelled = true),
                          ),
                        ),
                        AppDimensions.hGapSm,
                        Expanded(
                          child: SraButton(
                            label: "ME DÉCONNECTER",
                            onPressed: _logout,
                          ),
                        ),
                      ],
                    ),

                    AppDimensions.vGapLg,

                    Text(
                      "Besoin d’aide ? Contactez la réception Sweet Rest.",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
