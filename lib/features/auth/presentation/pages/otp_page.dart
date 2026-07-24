import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/error/error_handler.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page de vérification OTP / 2FA — Pixel-Perfect de `OtpPage.tsx` + `AuthShell`.
///
/// Divergence consignée : 6 cases séparées (UX mobile) au lieu du champ unique
/// de la maquette desktop — meilleure ergonomie tactile + auto-avancement.
class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String? _errorMessage;
  bool _resent = false;

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
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
    final l10n  = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textMuted  = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final cardBg     = isDark ? AppColors.darkCard  : AppColors.white;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.mist;

    // Email passé via arguments de navigation
    final args  = ModalRoute.of(context)?.settings.arguments;
    final email = (args is Map && args['email'] is String)
        ? args['email'] as String
        : 'votre adresse e-mail';

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

              // ── Icône info bleue en boîte 46×46 (maquette = statusInfo) ─
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: AppColors.statusInfo.withValues(alpha: isDark ? 0.20 : 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  color: AppColors.statusInfo,
                  size: AppDimensions.iconSizeLg,
                ),
              ),
              AppDimensions.vGapMd,

              // ── Overline or ──────────────────────────────────────────────
              Text(
                l10n.secureVerificationHeader,
                style: AppTextStyles.labelUppercase.copyWith(color: AppColors.goldDark),
              ),
              AppDimensions.vGapXs,

              // ── Titre Cormorant ──────────────────────────────────────────
              Text(
                l10n.confirmationCodeTitle,
                style: AppTextStyles.displayMedium.copyWith(
                  fontSize: 34, height: 1.1,
                  color: isDark ? AppColors.white : AppColors.ink,
                ),
              ),
              AppDimensions.vGapXs,

              // ── Sous-titre avec email en gras ────────────────────────────
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyMedium.copyWith(color: textMuted),
                  children: [
                    TextSpan(text: l10n.enterCodeSubtitle),
                    TextSpan(
                      text: ' $email',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? AppColors.white : AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              AppDimensions.vGapLg,

              // ── 6 cases OTP (UX mobile — divergence consignée §7) ────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 46, height: 54,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
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
                            color: AppColors.gold, width: AppDimensions.borderMedium,
                          ),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => _errorMessage = null);
                        if (val.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (val.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (_otpCode.length == 6) _submit();
                      },
                    ),
                  );
                }),
              ),

              // ── Helper text (expire dans 10 minutes) ────────────────────
              AppDimensions.vGapXs,
              Text(
                l10n.codeExpiresInTenMinutes,
                style: AppTextStyles.labelMuted,
              ),
              AppDimensions.vGapLg,

              // ── Alerte renvoi réussi ─────────────────────────────────────
              if (_resent) ...[
                SraAlert.success(
                  message: l10n.newCodeSentSuccess,
                  icon: Icons.check_circle_outline_rounded,
                ),
                AppDimensions.vGapMd,
              ],

              // ── Alerte erreur ────────────────────────────────────────────
              if (_errorMessage != null) ...[
                SraAlert.error(message: _errorMessage!),
                AppDimensions.vGapMd,
              ],

              // ── Bouton principal ─────────────────────────────────────────
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) => SraButton(
                  label: l10n.verifyCodeButton,
                  isLoading: state is AuthLoading,
                  onPressed: _submit,
                ),
              ),

              const Divider(height: AppDimensions.spacingXl * 1.5),

              // ── Pied de page : retour + renvoi ───────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back_rounded,
                          size: AppDimensions.iconSizeSm,
                          color: AppColors.inkMuted,
                        ),
                        AppDimensions.hGapXs,
                        Text(
                          l10n.modifyEmail,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _resent = true),
                    child: Text(
                      l10n.resendCode,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.goldDark,
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
