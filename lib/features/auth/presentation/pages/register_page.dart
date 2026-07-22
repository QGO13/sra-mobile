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

/// Page d'inscription SRA Hotel — Refonte Pixel-Perfect utilisant exclusivement les composants Core.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final prenom = _prenomController.text.trim();
    final nom = _nomController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final phone = _phoneController.text.trim();

    if (prenom.isEmpty || nom.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Veuillez remplir tous les champs obligatoires.');
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = 'Le mot de passe doit contenir au moins 6 caractères.');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMessage = 'Les mots de passe ne correspondent pas.');
      return;
    }

    setState(() => _errorMessage = null);

    context.read<AuthBloc>().add(
      RegisterParticulierSubmitted(
        email: email,
        password: password,
        nom: nom,
        prenoms: prenom,
        telephone: phone,
        sexe: 'M',
        pays: '',
        adresse: '',
      ),
    );
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
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          } else if (state is AuthFailure) {
            setState(() {
              _errorMessage = state.message.isNotEmpty
                  ? state.message
                  : 'Échec de la création de compte. Veuillez réessayer.';
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
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Logo Officiel Asset ──
                    const SraLogo(height: AppDimensions.avatarSizeLg * 1.5),
                    AppDimensions.vGapLg,

                    // ── Titre Playfair Display + Sous-titre ────────────
                    Text(
                      "Créer un compte",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.displayMedium.copyWith(
                        color: isDark ? AppColors.white : AppColors.ink,
                      ),
                    ),
                    AppDimensions.vGapXs,
                    Text(
                      "Créez votre compte pour réserver votre séjour et accéder à nos services.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textMuted,
                      ),
                    ),
                    AppDimensions.vGapLg,

                    // ── Card du Formulaire ──────
                    SraCard(
                      padding: const EdgeInsets.all(AppDimensions.spacingXl),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ── Prénom & Nom ──
                            Row(
                              children: [
                                Expanded(
                                  child: SraInput(
                                    label: "PRÉNOM *",
                                    placeholder: "Jean",
                                    controller: _prenomController,
                                    prefixIcon: const Icon(
                                      Icons.person_outline_rounded,
                                      color: AppColors.gold,
                                      size: AppDimensions.iconSizeMd,
                                    ),
                                  ),
                                ),
                                AppDimensions.hGapSm,
                                Expanded(
                                  child: SraInput(
                                    label: "NOM *",
                                    placeholder: "Dupont",
                                    controller: _nomController,
                                    prefixIcon: const Icon(
                                      Icons.person_outline_rounded,
                                      color: AppColors.gold,
                                      size: AppDimensions.iconSizeMd,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppDimensions.vGapLg,

                            // ── Email ──
                            SraInput(
                              label: l10n.email,
                              placeholder: "jean.dupont@email.com",
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(
                                Icons.alternate_email_rounded,
                                color: AppColors.gold,
                                size: AppDimensions.iconSizeMd,
                              ),
                            ),
                            AppDimensions.vGapLg,

                            // ── Téléphone avec indicatif ──
                            PhoneInputField(
                              numberController: _phoneController,
                            ),
                            AppDimensions.vGapLg,

                            // ── Mot de passe ──
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

                            // ── Confirmation mot de passe ──
                            SraInput(
                              label: "CONFIRMER MOT DE PASSE *",
                              placeholder: "••••••••",
                              controller: _confirmController,
                              obscureText: true,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: AppColors.gold,
                                size: AppDimensions.iconSizeMd,
                              ),
                            ),
                            AppDimensions.vGapLg,

                            // ── Message d'erreur sémantique ──
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

                            // ── Bouton d'inscription ──
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return SraButton(
                                  label: "CRÉER MON COMPTE",
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

                    // ── Lien Se connecter ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Déjà un compte ? ",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: textMuted,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            l10n.login,
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
