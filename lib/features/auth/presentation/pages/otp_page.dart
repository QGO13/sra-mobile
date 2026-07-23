import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/error/error_handler.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page de vérification OTP / 2FA — Reproduction Pixel-Perfect avec `AuthShell`.
class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String? _errorMessage;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (_otpCode.length < 6) {
      setState(() => _errorMessage = l10n.enterFullSixDigitCode);
      return;
    }
    setState(() => _errorMessage = null);
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
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
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          } else if (state is AuthFailure) {
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
                  Icons.mark_email_read_outlined,
                  color: AppColors.gold,
                  size: AppDimensions.iconSizeLg,
                ),
              ),
              AppDimensions.vGapMd,

              Text(
                l10n.secureVerificationHeader,
                style: AppTextStyles.labelUppercase.copyWith(
                  color: AppColors.gold,
                  letterSpacing: 2.0,
                ),
              ),
              AppDimensions.vGapXs,

              Text(
                l10n.confirmationCodeTitle,
                style: AppTextStyles.displayMedium.copyWith(
                  fontSize: 34,
                  height: 1.1,
                  color: isDark ? AppColors.white : AppColors.ink,
                ),
              ),
              AppDimensions.vGapXs,

              Text(
                l10n.enterCodeSubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textMuted,
                ),
              ),
              AppDimensions.vGapLg,

              // ── 6 cases OTP ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 46,
                    height: 54,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurface : AppColors.fog,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isDark ? AppColors.darkBorder : AppColors.mist,
                          ),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.gold,
                            width: AppDimensions.borderMedium,
                          ),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                        ),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (val.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (_otpCode.length == 6) {
                          _submit();
                        }
                      },
                    ),
                  );
                }),
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
                    label: l10n.verifyCodeButton,
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
                  Text(
                    l10n.didNotReceiveCode,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textMuted,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SraSnackbar.show(
                        context,
                        message: l10n.newCodeSentSuccess,
                        type: SraSnackbarType.success,
                      );
                    },
                    child: Text(
                      l10n.resendCode,
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
    );
  }
}
