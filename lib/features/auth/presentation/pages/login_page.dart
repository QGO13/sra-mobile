import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';
import 'package:sra_hotel/main.dart';

/// Page de connexion SRA Hotel — Pixel-Perfect reproduction du design Next.js React.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
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
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLocale = Localizations.localeOf(context);

    final bgPage = isDark ? AppColors.darkSurface : AppColors.fog;
    final bgCard = isDark ? AppColors.darkCard : AppColors.white;
    final borderCard = isDark ? AppColors.darkBorder : const Color(0x17212222);
    final textMain = isDark ? AppColors.white : AppColors.ink;
    final textMuted = isDark ? AppColors.overlayDarkMedium : const Color(0xFF6B6C6C);
    final inputBg = isDark ? AppColors.darkElevated : AppColors.white;
    final inputBorder = isDark ? AppColors.darkBorder : const Color(0x1F212222);

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        backgroundColor: const Color(0x00000000),
        elevation: 0,
        actions: [
          LanguageSelector(
            currentLocale: currentLocale,
            onLocaleChanged: (newLocale) {
              MyApp.setLocale(context, newLocale);
            },
          ),
          const SizedBox(width: AppDimensions.spacingMd),
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
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Logo Next.js (160px max width) ──────────────────────
                    Center(
                      child: Image.network(
                        "https://sra-hotel.com/media/logo-SweetRestAparthotel_color.png",
                        width: 160,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SraLogo(size: 80),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Titre Serif Playfair Display + Sous-titre ────────────
                    Text(
                      localizations.welcomeBack,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: textMain,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      localizations.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: textMuted,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Comptes de Démonstration Banner (Accordéon Next.js) ──
                    DemoAccountsBanner(onSelect: _selectDemoAccount),
                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Card du Formulaire (Flat Luxury Design Next.js) ──────
                    Container(
                      padding: const EdgeInsets.fromLTRB(40, 44, 40, 38),
                      decoration: BoxDecoration(
                        color: bgCard,
                        border: Border.all(color: borderCard, width: 1.0),
                        boxShadow: const [AppShadows.card],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ── Champ Email ──────────────────────────────────
                            Text(
                              "EMAIL *",
                              style: GoogleFonts.raleway(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                color: AppColors.gold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingSm),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.raleway(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: textMain,
                              ),
                              decoration: InputDecoration(
                                hintText: "contact@email.com",
                                hintStyle: GoogleFonts.raleway(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: textMuted,
                                ),
                                filled: true,
                                fillColor: inputBg,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: inputBorder, width: 1.0),
                                  borderRadius: BorderRadius.zero,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.gold, width: 1.5),
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingLg),

                            // ── Champ Mot de passe ───────────────────────────
                            Text(
                              "MOT DE PASSE *",
                              style: GoogleFonts.raleway(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                color: AppColors.gold,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingSm),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_showPassword,
                              style: GoogleFonts.raleway(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                                color: textMain,
                              ),
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                hintStyle: GoogleFonts.raleway(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: textMuted,
                                ),
                                filled: true,
                                fillColor: inputBg,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: inputBorder, width: 1.0),
                                  borderRadius: BorderRadius.zero,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.gold, width: 1.5),
                                  borderRadius: BorderRadius.zero,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: textMuted,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    setState(() => _showPassword = !_showPassword);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingLg),

                            // ── Message d'erreur sémantique Next.js ──────────
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 11,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0x14E05555),
                                  border: Border(
                                    left: BorderSide(
                                      color: Color(0xFFE05555),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: GoogleFonts.raleway(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFC0392B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppDimensions.spacingLg),
                            ],

                            // ── Bouton de connexion Next.js (Se Connecter) ──
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;

                                return SizedBox(
                                  height: AppDimensions.buttonHeight,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.gold,
                                      foregroundColor: AppColors.white,
                                      elevation: 0,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                AppColors.white,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            "SE CONNECTER",
                                            style: GoogleFonts.raleway(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1.8,
                                              color: AppColors.white,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Séparateur "OU" Next.js ──────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: borderCard,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "OU",
                            style: GoogleFonts.raleway(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                              color: const Color(0xFFBBBCC1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: borderCard,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Lien Créer un compte ─────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pas encore de compte ? ",
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: textMuted,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.register);
                          },
                          child: Text(
                            "Créer un compte",
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.spacingXl),

                    // ── Bouton Retour à l'accueil ────────────────────────────
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                        },
                        child: Text(
                          "← Retour à l'accueil",
                          style: GoogleFonts.raleway(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            color: const Color(0xFFBBBCC1),
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
