import 'package:flutter/material.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/main.dart';

/// Page de vérification OTP (2-FA) — Reproduction Pixel-Perfect de `OtpPage.tsx`.
class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({
    super.key,
    this.email = 'awa.camara@email.com',
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _codeController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_codeController.text.trim().length != 6) {
      setState(() => _errorMessage = 'Saisissez les 6 chiffres du code de vérification.');
      return;
    }
    setState(() => _errorMessage = null);
    Navigator.of(context).pushReplacementNamed(AppRoutes.backofficeAdmin);
  }

  void _resendCode() {
    setState(() {
      _errorMessage = null;
    });
    SraSnackbar.show(
      context,
      message: 'Un nouveau code vient d’être envoyé.',
      type: SraSnackbarType.success,
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
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SraLogo(height: AppDimensions.avatarSizeLg * 1.5),
                  AppDimensions.vGapLg,

                  // ── Conteneur Icône Sécurisée ──
                  Center(
                    child: Container(
                      width: AppDimensions.avatarSizeLg,
                      height: AppDimensions.avatarSizeLg,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        color: AppColors.gold,
                        size: AppDimensions.iconSizeXl,
                      ),
                    ),
                  ),
                  AppDimensions.vGapLg,

                  Text(
                    "VÉRIFICATION EN DEUX ÉTAPES",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelUppercase.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                  AppDimensions.vGapXs,
                  Text(
                    "Confirmez votre identité.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayMedium.copyWith(
                      color: isDark ? AppColors.white : AppColors.ink,
                    ),
                  ),
                  AppDimensions.vGapXs,
                  Text(
                    "Nous avons envoyé un code à usage unique à ${widget.email}.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textMuted,
                    ),
                  ),
                  AppDimensions.vGapLg,

                  SraCard(
                    padding: const EdgeInsets.all(AppDimensions.spacingXl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SraInput(
                          label: "CODE À 6 CHIFFRES *",
                          placeholder: "000000",
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(
                            Icons.lock_clock_outlined,
                            color: AppColors.gold,
                            size: AppDimensions.iconSizeMd,
                          ),
                        ),
                        AppDimensions.vGapLg,

                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacingSm,
                              vertical: AppDimensions.spacingXs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.statusError.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                              border: Border.all(
                                color: AppColors.statusError,
                                width: AppDimensions.borderThin,
                              ),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.statusError,
                              ),
                            ),
                          ),
                          AppDimensions.vGapLg,
                        ],

                        SraButton(
                          label: "VÉRIFIER ET OUVRIR MON ESPACE",
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),

                  AppDimensions.vGapLg,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          "← Modifier l'e-mail",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: textMuted,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _resendCode,
                        child: Text(
                          "Renvoyer le code",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
