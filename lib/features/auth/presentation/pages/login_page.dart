import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';
import 'package:sra_hotel/main.dart';

/// Page de connexion SRA Hotel — Refonte Pixel-Perfect utilisant exclusivement les composants Core.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Veuillez remplir tous les champs.');
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

  void _selectDemoAccount(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
      body: BlocListener<AuthBloc, AuthState>(
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
              _errorMessage = state.message.isNotEmpty
                  ? state.message
                  : 'Identifiants incorrects. Utilisez un des comptes de démo ci-dessous.';
            });
          }
        },
        child: SafeArea(
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
                    // ── Logo Officiel Asset (logo-SweetRestAparthotel_simple.png) ──
                    const SraLogo(height: AppDimensions.avatarSizeLg * 1.5),
                    AppDimensions.vGapLg,

                    // ── Titres Playfair Display + Raleway ────────────
                    Text(
                      l10n.welcomeBack,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? AppColors.white : AppColors.ink,
                      ),
                    ),
                    AppDimensions.vGapXs,
                    Text(
                      l10n.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textMuted,
                      ),
                    ),
                    AppDimensions.vGapLg,

                    // ── Comptes de Démonstration Accordéon ──
                    DemoAccountsBanner(onSelect: _selectDemoAccount),
                    AppDimensions.vGapLg,

                    // ── Card du Formulaire ──────
                    SraCard(
                      padding: const EdgeInsets.all(AppDimensions.spacingXl),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ── Champ Email ──
                            SraInput(
                              label: l10n.email,
                              placeholder: "contact@email.com",
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
                              label: l10n.password,
                              placeholder: "••••••••",
                              controller: _passwordController,
                              obscureText: true,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.gold,
                                size: AppDimensions.iconSizeMd,
                              ),
                            ),
                            AppDimensions.vGapLg,

                            // ── Erreur sémantique ──
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

                            // ── Bouton de connexion SRA ──
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return SraButton(
                                  label: l10n.login.toUpperCase(),
                                  isLoading: state is AuthLoading,
                                  onPressed: _submit,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    AppDimensions.vGapLg,

                    // ── Séparateur "OU" ──
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                          child: Text(
                            "OU",
                            style: AppTextStyles.labelUppercase.copyWith(
                              color: textMuted,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    AppDimensions.vGapLg,

                    // ── Lien Créer un compte ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pas encore de compte ? ",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: textMuted,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.register);
                          },
                          child: Text(
                            "Créer un compte",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    AppDimensions.vGapXl,

                    // ── Bouton Retour à l'accueil ──
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                        },
                        child: Text(
                          "← Retour à l'accueil",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: textMuted,
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
      ),
    );
  }
}
