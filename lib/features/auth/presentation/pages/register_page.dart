import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';

/// Page d'inscription SRA Hotel — Pixel-Perfect reproduction du design Next.js React.
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

  bool _showPassword = false;
  bool _showConfirm = false;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgPage = isDark ? AppColors.darkSurface : AppColors.fog;
    final bgCard = isDark ? AppColors.darkCard : AppColors.white;
    final borderCard = isDark ? AppColors.darkBorder : const Color(0x17212222);
    final textMain = isDark ? AppColors.white : AppColors.ink;
    final textMuted = isDark ? AppColors.overlayDarkMedium : const Color(0xFF6B6C6C);
    final inputBg = isDark ? AppColors.darkElevated : AppColors.white;
    final inputBorder = isDark ? AppColors.darkBorder : const Color(0x1F212222);

    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final isLengthOk = password.length >= 6;
    final hasDigit = RegExp(r'\d').hasMatch(password);
    final isConfirmOk = confirm.isNotEmpty && password == confirm;

    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        backgroundColor: const Color(0x00000000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.gold),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.home,
              (route) => false,
            );
          } else if (state is AuthFailure) {
            setState(() => _errorMessage = state.message);
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
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Logo Next.js ────────────────────────────────────────
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

                    // ── Titre & Sous-titre Next.js ──────────────────────────
                    Text(
                      "Créer votre compte",
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
                      "Rejoignez Sweet Rest Aparthotel",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: textMuted,
                        height: 1.6,
                      ),
                    ),
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
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 440;

                            Widget buildLabel(String label) => Text(
                              label.toUpperCase(),
                              style: GoogleFonts.raleway(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                color: AppColors.gold,
                              ),
                            );

                            InputDecoration buildInputDecoration(String hint) =>
                                InputDecoration(
                                  hintText: hint,
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
                                    borderSide: BorderSide(
                                      color: inputBorder,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.gold,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                );

                            Widget buildPrenomField() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLabel("PRÉNOM *"),
                                const SizedBox(height: AppDimensions.spacingSm),
                                TextFormField(
                                  controller: _prenomController,
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: textMain,
                                  ),
                                  decoration: buildInputDecoration("Jean-Marc"),
                                ),
                              ],
                            );

                            Widget buildNomField() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildLabel("NOM *"),
                                const SizedBox(height: AppDimensions.spacingSm),
                                TextFormField(
                                  controller: _nomController,
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: textMain,
                                  ),
                                  decoration: buildInputDecoration("Kouassi"),
                                ),
                              ],
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Nom / Prénom Row
                                if (isWide)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: buildPrenomField()),
                                      const SizedBox(width: AppDimensions.spacingMd),
                                      Expanded(child: buildNomField()),
                                    ],
                                  )
                                else ...[
                                  buildPrenomField(),
                                  const SizedBox(height: AppDimensions.spacingMd),
                                  buildNomField(),
                                ],

                                const SizedBox(height: AppDimensions.spacingMd),

                                // Email
                                buildLabel("EMAIL *"),
                                const SizedBox(height: AppDimensions.spacingSm),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: textMain,
                                  ),
                                  decoration: buildInputDecoration("contact@email.com"),
                                ),

                                const SizedBox(height: AppDimensions.spacingMd),

                                // Téléphone
                                buildLabel("TÉLÉPHONE"),
                                const SizedBox(height: AppDimensions.spacingSm),
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: textMain,
                                  ),
                                  decoration: buildInputDecoration("+225 01 50 67 86 95"),
                                ),

                                const SizedBox(height: AppDimensions.spacingMd),

                                // Mot de passe
                                buildLabel("MOT DE PASSE *"),
                                const SizedBox(height: AppDimensions.spacingSm),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_showPassword,
                                  onChanged: (_) => setState(() {}),
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: textMain,
                                  ),
                                  decoration: buildInputDecoration("••••••••").copyWith(
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

                                const SizedBox(height: AppDimensions.spacingMd),

                                // Confirmer mot de passe
                                buildLabel("CONFIRMER LE MOT DE PASSE *"),
                                const SizedBox(height: AppDimensions.spacingSm),
                                TextFormField(
                                  controller: _confirmController,
                                  obscureText: !_showConfirm,
                                  onChanged: (_) => setState(() {}),
                                  style: GoogleFonts.raleway(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: textMain,
                                  ),
                                  decoration: buildInputDecoration("••••••••").copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _showConfirm
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: textMuted,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        setState(() => _showConfirm = !_showConfirm);
                                      },
                                    ),
                                  ),
                                ),

                                // ── Password Strength Panel (Next.js) ────────
                                if (password.isNotEmpty) ...[
                                  const SizedBox(height: AppDimensions.spacingMd),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.darkElevated
                                          : AppColors.fog,
                                      border: const Border(
                                        left: BorderSide(
                                          color: Color(0x66C5985B),
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildStrengthItem(
                                          "Au moins 6 caractères",
                                          isLengthOk,
                                        ),
                                        const SizedBox(height: 6),
                                        _buildStrengthItem(
                                          "Contient un chiffre",
                                          hasDigit,
                                        ),
                                        const SizedBox(height: 6),
                                        _buildStrengthItem(
                                          "Mots de passe identiques",
                                          isConfirmOk,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                const SizedBox(height: AppDimensions.spacingLg),

                                // ── Message d'erreur ─────────────────────────
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

                                // ── Bouton Créer mon compte ──────────────────
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
                                                "CRÉER MON COMPTE",
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
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Séparateur "OU" Next.js ──────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: borderCard),
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
                          child: Container(height: 1, color: borderCard),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimensions.spacingLg),

                    // ── Lien Se connecter ────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Déjà un compte ? ",
                          style: GoogleFonts.raleway(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: textMuted,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            "Se connecter",
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

  Widget _buildStrengthItem(String label, bool isOk) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          size: 14,
          color: isOk ? const Color(0xFF2D7A4F) : const Color(0xFFD0D0D0),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.raleway(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: isOk ? const Color(0xFF2D7A4F) : const Color(0xFF6B6C6C),
          ),
        ),
      ],
    );
  }
}
