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

/// Page de connexion SRA Hotel — Pixel-Perfect de `LoginPage.tsx` + `AuthShell.tsx`.
///
/// Structure : icône-boîte 44×44 · overline or · titre Cormorant · corps Montserrat
/// · champ email + mot de passe · ligne rememberMe + lien mot de passe
/// · alerte erreur (SraAlert) · bouton Continuer · divider · lien client séjour.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool  _rememberMe    = false;
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
        login:    _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textMuted  = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;
    final cardBg     = isDark ? AppColors.darkCard  : AppColors.white;
    final cardBorder = isDark ? AppColors.darkBorder : AppColors.mist;

    // Vérifier si la page est ouverte après une déconnexion
    final args = ModalRoute.of(context)?.settings.arguments;
    final signedOut = (args is Map) && args['signedOut'] == true;

    return AuthShell(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            final role = state.user.role.toLowerCase();
            if (role.contains('admin')) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.backofficeAdmin);
            } else if (role.contains('reception') || role.contains('housekeeping') ||
                       role.contains('gouvernante') || role.contains('femme')) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // ── Icône dorée en boîte carrée arrondie 44×44 ──────────────
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: isDark ? 0.20 : 0.16),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                ),
                child: const Icon(Icons.lock_outlined, color: AppColors.goldDark, size: AppDimensions.iconSizeLg),
              ),
              AppDimensions.vGapMd,

              // ── Overline or — "VOTRE ESPACE SWEET REST" ─────────────────
              Text(
                l10n.yourSweetRestSpace,
                style: AppTextStyles.labelUppercase.copyWith(color: AppColors.goldDark),
              ),
              AppDimensions.vGapXs,

              // ── Titre Cormorant Garamond — "Ravi de vous revoir." ────────
              Text(
                l10n.welcomeBack,
                style: AppTextStyles.displayMedium.copyWith(
                  fontSize: 34, height: 1.1,
                  color: isDark ? AppColors.white : AppColors.ink,
                ),
              ),
              AppDimensions.vGapXs,

              // ── Sous-titre Montserrat ────────────────────────────────────
              Text(
                l10n.loginSubtitle,
                style: AppTextStyles.bodyMedium.copyWith(color: textMuted),
              ),
              AppDimensions.vGapLg,

              // ── Alerte déconnexion réussie ───────────────────────────────
              if (signedOut) ...[
                SraAlert.success(message: l10n.signedOutSuccessMessage),
                AppDimensions.vGapMd,
              ],

              // ── Champ Email ──────────────────────────────────────────────
              SraInput(
                label: l10n.emailAddressRequired,
                placeholder: l10n.emailPlaceholder,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.alternate_email_rounded,
                  color: isDark ? AppColors.gold.withValues(alpha: 0.7) : AppColors.inkMuted,
                  size: AppDimensions.iconSizeMd,
                ),
              ),
              AppDimensions.vGapMd,

              // ── Champ Mot de passe ───────────────────────────────────────
              SraInput(
                label: l10n.passwordRequired,
                placeholder: '••••••••',
                controller: _passwordController,
                obscureText: true,
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: isDark ? AppColors.gold.withValues(alpha: 0.7) : AppColors.inkMuted,
                  size: AppDimensions.iconSizeMd,
                ),
              ),
              AppDimensions.vGapSm,

              // ── Ligne Rester connecté(e) + Modifier le mot de passe ─────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 24, height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            activeColor: AppColors.gold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimensions.radiusXs / 2),
                            ),
                            onChanged: (val) => setState(() => _rememberMe = val ?? false),
                          ),
                        ),
                        AppDimensions.hGapXs,
                        Flexible(
                          child: Text(
                            l10n.rememberMe,
                            style: AppTextStyles.bodySmall.copyWith(color: textMuted),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.changePassword),
                    child: Text(
                      l10n.changePasswordTitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              AppDimensions.vGapLg,

              // ── Alerte erreur ────────────────────────────────────────────
              if (_errorMessage != null) ...[
                SraAlert.error(message: _errorMessage!),
                AppDimensions.vGapMd,
              ],

              // ── Bouton Continuer ─────────────────────────────────────────
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) => SraButton(
                  label: l10n.continueButton,
                  isLoading: state is AuthLoading,
                  onPressed: _submit,
                  trailingIcon: Icons.arrow_forward_rounded,
                ),
              ),

              const Divider(height: AppDimensions.spacingXl * 1.5),

              // ── Lien client — Accéder à mon séjour ──────────────────────
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppDimensions.spacingXs,
                  children: [
                    Text(
                      l10n.haveAReservation,
                      style: AppTextStyles.bodySmall.copyWith(color: textMuted),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.myStay),
                      child: Text(
                        l10n.accessMyStay,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.goldDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
