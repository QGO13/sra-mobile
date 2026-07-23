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

/// Page d'inscription SRA Hotel — Reproduction Pixel-Perfect avec `AuthShell`.
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
    final l10n = AppLocalizations.of(context)!;
    final prenom = _prenomController.text.trim();
    final nom = _nomController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final phone = _phoneController.text.trim();

    if (prenom.isEmpty || nom.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = l10n.fillAllRequiredFields);
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage = l10n.passwordTooShort);
      return;
    }
    if (password != confirm) {
      setState(() => _errorMessage = l10n.passwordsDoNotMatch);
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
                    Icons.person_add_outlined,
                    color: AppColors.gold,
                    size: AppDimensions.iconSizeLg,
                  ),
                ),
                AppDimensions.vGapMd,

                Text(
                  l10n.accountCreationHeader,
                  style: AppTextStyles.labelUppercase.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 2.0,
                  ),
                ),
                AppDimensions.vGapXs,

                Text(
                  l10n.joinUsTitle,
                  style: AppTextStyles.displayMedium.copyWith(
                    fontSize: 34,
                    height: 1.1,
                    color: isDark ? AppColors.white : AppColors.ink,
                  ),
                ),
                AppDimensions.vGapXs,

                Text(
                  l10n.registerSubtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textMuted,
                  ),
                ),
                AppDimensions.vGapLg,

                Row(
                  children: [
                    Expanded(
                      child: SraInput(
                        label: l10n.firstNameRequired,
                        placeholder: l10n.firstNamePlaceholder,
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
                        label: l10n.lastNameRequired,
                        placeholder: l10n.lastNamePlaceholder,
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

                SraInput(
                  label: l10n.email,
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

                PhoneInputField(
                  numberController: _phoneController,
                ),
                AppDimensions.vGapLg,

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

                SraInput(
                  label: l10n.confirmPasswordRequired,
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
                      label: l10n.createMyAccountButton,
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
                      l10n.alreadyHaveAccount,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textMuted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        l10n.login,
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
