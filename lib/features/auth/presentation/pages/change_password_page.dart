import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/error/error_handler.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page de modification du mot de passe — Pixel-Perfect de `ChangePasswordPage.tsx`.
///
/// Structure : icône clé 46×46 · overline "SÉCURITÉ DU COMPTE" · titre
/// · 3 champs mot de passe · validation 8 chars min (conforme maquette)
/// · SraAlert erreur/succès · bouton Mettre à jour · divider · lien retour.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey                  = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController    = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  bool _saved = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n    = AppLocalizations.of(context)!;
    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      setState(() { _errorMessage = l10n.fillAllFields; _saved = false; });
      return;
    }
    // 8 chars minimum (conforme ChangePasswordPage.tsx)
    if (newPass.length < 8) {
      setState(() { _errorMessage = l10n.newPasswordTooShort; _saved = false; });
      return;
    }
    if (newPass != confirm) {
      setState(() { _errorMessage = l10n.passwordsDoNotMatch; _saved = false; });
      return;
    }
    setState(() { _errorMessage = null; _saved = true; });
  }

  @override
  Widget build(BuildContext context) {
    final l10n   = AppLocalizations.of(context)!;
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final textMuted  = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final cardBg     = isDark ? AppColors.darkCard  : AppColors.white;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.mist;

    return AuthShell(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            setState(() {
              _errorMessage = ErrorMapper.getSubtitle(state.message, l10n);
              _saved = false;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            border: Border.all(color: cardBorder, width: AppDimensions.borderThin),
            boxShadow: const [AppShadows.card],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── Icône clé 46×46 ───────────────────────────────────────
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: isDark ? 0.20 : 0.16),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  ),
                  child: const Icon(
                    Icons.vpn_key_rounded,
                    color: AppColors.goldDark,
                    size: AppDimensions.iconSizeLg,
                  ),
                ),
                AppDimensions.vGapMd,

                // ── Overline "SÉCURITÉ DU COMPTE" ─────────────────────────
                Text(
                  l10n.resetHeader,
                  style: AppTextStyles.labelUppercase.copyWith(color: AppColors.goldDark),
                ),
                AppDimensions.vGapXs,

                // ── Titre Cormorant ────────────────────────────────────────
                Text(
                  l10n.changeYourPasswordTitle,
                  style: AppTextStyles.displayMedium.copyWith(
                    fontSize: 34, height: 1.1,
                    color: isDark ? AppColors.white : AppColors.ink,
                  ),
                ),
                AppDimensions.vGapXs,

                // ── Sous-titre ─────────────────────────────────────────────
                Text(
                  l10n.changePasswordSubtitle,
                  style: AppTextStyles.bodyMedium.copyWith(color: textMuted),
                ),
                AppDimensions.vGapLg,

                // ── Champ Mot de passe actuel ──────────────────────────────
                SraInput(
                  label: l10n.currentPasswordRequired,
                  placeholder: '••••••••',
                  controller: _currentPasswordController,
                  obscureText: true,
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: isDark ? AppColors.gold.withValues(alpha: 0.7) : AppColors.inkMuted,
                    size: AppDimensions.iconSizeMd,
                  ),
                  onChanged: (_) => setState(() { _errorMessage = null; _saved = false; }),
                ),
                AppDimensions.vGapMd,

                // ── Champ Nouveau mot de passe ─────────────────────────────
                SraInput(
                  label: l10n.newPasswordRequired,
                  placeholder: '••••••••',
                  controller: _newPasswordController,
                  obscureText: true,
                  helperText: l10n.newPasswordHelper,
                  prefixIcon: Icon(
                    Icons.vpn_key_rounded,
                    color: isDark ? AppColors.gold.withValues(alpha: 0.7) : AppColors.inkMuted,
                    size: AppDimensions.iconSizeMd,
                  ),
                  onChanged: (_) => setState(() { _errorMessage = null; _saved = false; }),
                ),
                AppDimensions.vGapMd,

                // ── Champ Confirmer le nouveau mot de passe ────────────────
                SraInput(
                  label: l10n.confirmNewPasswordRequired,
                  placeholder: '••••••••',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: Icon(
                    Icons.vpn_key_rounded,
                    color: isDark ? AppColors.gold.withValues(alpha: 0.7) : AppColors.inkMuted,
                    size: AppDimensions.iconSizeMd,
                  ),
                  onChanged: (_) => setState(() { _errorMessage = null; _saved = false; }),
                ),
                AppDimensions.vGapLg,

                // ── Alerte erreur ──────────────────────────────────────────
                if (_errorMessage != null) ...[
                  SraAlert.error(message: _errorMessage!),
                  AppDimensions.vGapMd,
                ],

                // ── Alerte succès ──────────────────────────────────────────
                if (_saved) ...[
                  SraAlert.success(message: l10n.passwordChangedSuccess),
                  AppDimensions.vGapMd,
                ],

                // ── Bouton Mettre à jour ───────────────────────────────────
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) => SraButton(
                    label: l10n.changeMyPasswordButton,
                    isLoading: state is AuthLoading,
                    onPressed: _saved ? null : _submit,
                  ),
                ),

                const Divider(height: AppDimensions.spacingXl * 1.5),

                // ── Lien retour ────────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.rememberYourPassword,
                      style: AppTextStyles.bodySmall.copyWith(color: textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
