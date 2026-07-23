import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/error/error_handler.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page de connexion SRA Hotel — Reproduction Pixel-Perfect de `LoginPage.tsx` + `AuthShell.tsx`.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = l10n.loginValidationError);
      return;
    }
    setState(() => _errorMessage = null);

    context.read<AuthBloc>().add(
      LoginSubmitted(
        login: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
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
            final role = state.user.role.toLowerCase();
            if (role.contains('admin')) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.backofficeAdmin);
            } else if (role.contains('reception')) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.backofficeReception);
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            }
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Icône dorée en boîte carrée arrondie (44x44) ──
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.16),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                  ),
                  child: const Icon(
                    Icons.lock_outlined,
                    color: AppColors.gold,
                    size: AppDimensions.iconSizeLg,
                  ),
                ),
                AppDimensions.vGapMd,

                // ── Titre "VOTRE ESPACE SWEET REST" ──
                Text(
                  l10n.yourSweetRestSpace,
                  style: AppTextStyles.labelUppercase.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 2.0,
                  ),
                ),
                AppDimensions.vGapXs,

                // ── Titre Playfair Display "Ravi de vous revoir." ──
                Text(
                  l10n.welcomeBack,
                  style: AppTextStyles.displayMedium.copyWith(
                    fontSize: 34,
                    height: 1.1,
                    color: isDark ? AppColors.white : AppColors.ink,
                  ),
                ),
                AppDimensions.vGapXs,

                // ── Sous-titre ──
                Text(
                  l10n.loginSubtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textMuted,
                  ),
                ),
                AppDimensions.vGapLg,

                // ── Bannière de déconnexion réussie ──
                if (ModalRoute.of(context)?.settings.arguments is Map &&
                    (ModalRoute.of(context)!.settings.arguments as Map)['signedOut'] == true) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMd,
                      vertical: AppDimensions.spacingSm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.statusSuccess.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      border: Border.all(
                        color: AppColors.statusSuccess,
                        width: AppDimensions.borderThin,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.statusSuccess,
                          size: AppDimensions.iconSizeMd,
                        ),
                        AppDimensions.hGapSm,
                        Expanded(
                          child: Text(
                            l10n.signedOutSuccessMessage,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.statusSuccess,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppDimensions.vGapLg,
                ],

                // ── Champ Email ──
                SraInput(
                  label: l10n.emailAddressRequired,
                  placeholder: l10n.emailPlaceholder,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.alternate_email_rounded,
                    color: AppColors.gold,
                    size: AppDimensions.iconSizeMd,
                  ),
                ),
                AppDimensions.vGapLg,

                // ── Champ Mot de passe ──
                SraInput(
                  label: l10n.passwordRequired,
                  placeholder: "••••••••",
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.gold,
                    size: AppDimensions.iconSizeMd,
                  ),
                ),
                AppDimensions.vGapSm,

                // ── Ligne Rester connecté(e) + Modifier le mot de passe ──
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppDimensions.spacingSm,
                  runSpacing: AppDimensions.spacingSm,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.gold,
                            onChanged: (val) => setState(() => _rememberMe = val ?? false),
                          ),
                        ),
                        AppDimensions.hGapXs,
                        Text(
                          l10n.rememberMe,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.changePassword);
                      },
                      child: Text(
                        l10n.changePasswordTitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                AppDimensions.vGapLg,

                // ── Message d'erreur ──
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

                // ── Bouton Continuer ──
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SraButton(
                      label: l10n.continueButton,
                      isLoading: state is AuthLoading,
                      onPressed: _submit,
                    );
                  },
                ),
                const Divider(),
                AppDimensions.vGapMd,

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppDimensions.spacingXs,
                  children: [
                    Text(
                      l10n.noAccountYet,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textMuted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.register);
                      },
                      child: Text(
                        l10n.createAccount,
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
