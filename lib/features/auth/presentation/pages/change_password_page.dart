import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/error/error_handler.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page de modification du mot de passe — Reproduction Pixel-Perfect avec `AuthShell`.
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      setState(() => _errorMessage = l10n.fillAllFields);
      return;
    }
    if (newPass.length < 6) {
      setState(() => _errorMessage = l10n.newPasswordTooShort);
      return;
    }
    if (newPass != confirm) {
      setState(() => _errorMessage = l10n.passwordsDoNotMatch);
      return;
    }

    setState(() => _errorMessage = null);
    SraSnackbar.show(
      context,
      message: l10n.passwordChangedSuccess,
      type: SraSnackbarType.success,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final cardBg = isDark ? AppColors.darkCard : AppColors.white;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.mist;

    return AuthShell(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            setState(() {
              _errorMessage = ErrorMapper.getSubtitle(state.message, l10n);
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
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.16),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  ),
                  child: const Icon(
                    Icons.vpn_key_outlined,
                    color: AppColors.gold,
                    size: AppDimensions.iconSizeLg,
                  ),
                ),
                AppDimensions.vGapMd,

                Text(
                  l10n.resetHeader,
                  style: AppTextStyles.labelUppercase.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 2.0,
                  ),
                ),
                AppDimensions.vGapXs,

                Text(
                  l10n.password,
                  style: AppTextStyles.displayMedium.copyWith(
                    fontSize: 34,
                    height: 1.1,
                    color: isDark ? AppColors.white : AppColors.ink,
                  ),
                ),
                AppDimensions.vGapXs,

                Text(
                  l10n.changePasswordSubtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textMuted,
                  ),
                ),
                AppDimensions.vGapLg,

                SraInput(
                  label: l10n.currentPasswordRequired,
                  placeholder: "••••••••",
                  controller: _currentPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.gold,
                    size: AppDimensions.iconSizeMd,
                  ),
                ),
                AppDimensions.vGapLg,

                SraInput(
                  label: l10n.newPasswordRequired,
                  placeholder: "••••••••",
                  controller: _newPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.gold,
                    size: AppDimensions.iconSizeMd,
                  ),
                ),
                AppDimensions.vGapLg,

                SraInput(
                  label: l10n.confirmNewPasswordRequired,
                  placeholder: "••••••••",
                  controller: _confirmPasswordController,
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
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

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SraButton(
                      label: l10n.changeMyPasswordButton,
                      isLoading: state is AuthLoading,
                      onPressed: _submit,
                    );
                  },
                ),
                AppDimensions.vGapLg,

                const Divider(),
                AppDimensions.vGapMd,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        l10n.cancelAndReturn,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700,
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
    );
  }
}
