import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/main.dart';

/// Page de changement de mot de passe — Reproduction Pixel-Perfect de `ChangePasswordPage.tsx`.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_currentController.text.length < 6 || _newController.text.length < 8) {
      setState(() => _errorMessage = 'Votre nouveau mot de passe doit compter au moins 8 caractères.');
      return;
    }
    if (_newController.text != _confirmController.text) {
      setState(() => _errorMessage = 'La confirmation ne correspond pas au nouveau mot de passe.');
      return;
    }
    setState(() {
      _errorMessage = null;
    });
    SraSnackbar.show(
      context,
      message: 'Votre mot de passe a été mis à jour avec succès.',
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

                  Center(
                    child: Container(
                      width: AppDimensions.avatarSizeLg,
                      height: AppDimensions.avatarSizeLg,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.key_rounded,
                        color: AppColors.gold,
                        size: AppDimensions.iconSizeXl,
                      ),
                    ),
                  ),
                  AppDimensions.vGapLg,

                  Text(
                    "SÉCURITÉ DU COMPTE",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelUppercase.copyWith(
                      color: AppColors.gold,
                    ),
                  ),
                  AppDimensions.vGapXs,
                  Text(
                    "Changez votre mot de passe.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayMedium.copyWith(
                      color: isDark ? AppColors.white : AppColors.ink,
                    ),
                  ),
                  AppDimensions.vGapXs,
                  Text(
                    "Choisissez un mot de passe unique pour sécuriser vos accès.",
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
                          label: "MOT DE PASSE ACTUEL *",
                          placeholder: "••••••••",
                          controller: _currentController,
                          obscureText: true,
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.gold,
                            size: AppDimensions.iconSizeMd,
                          ),
                        ),
                        AppDimensions.vGapLg,

                        SraInput(
                          label: "NOUVEAU MOT DE PASSE *",
                          placeholder: "8 caractères minimum",
                          controller: _newController,
                          obscureText: true,
                          prefixIcon: const Icon(
                            Icons.key_rounded,
                            color: AppColors.gold,
                            size: AppDimensions.iconSizeMd,
                          ),
                        ),
                        AppDimensions.vGapLg,

                        SraInput(
                          label: "CONFIRMER LE NOUVEAU MOT DE PASSE *",
                          placeholder: "••••••••",
                          controller: _confirmController,
                          obscureText: true,
                          prefixIcon: const Icon(
                            Icons.key_rounded,
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
                          label: "METTRE À JOUR LE MOT DE PASSE",
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),

                  AppDimensions.vGapLg,

                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        "← Se connecter",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
