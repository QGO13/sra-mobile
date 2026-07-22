import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/language_selector.dart';
import 'package:sra_hotel/core/widgets/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/core/widgets/sra_logo.dart';
import 'package:sra_hotel/core/widgets/sra_input.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';
import 'package:sra_hotel/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginSubmitted(
          login: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
          const SizedBox(width: 16),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            final role = state.user.role.toLowerCase();
            if (role.contains('admin')) {
              Navigator.of(
                context,
              ).pushReplacementNamed(AppRoutes.backofficeAdmin);
            } else if (role.contains('reception')) {
              Navigator.of(
                context,
              ).pushReplacementNamed(AppRoutes.backofficeReception);
            } else {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Header
                    const SraLogo(size: 100),
                    const SizedBox(height: 20),
                    Text(
                      localizations.welcomeBack,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Colors.white
                            : AppColors.imperialNightBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      localizations.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Demo Accounts banner widget
                    //DemoAccountsBanner(onSelect: _selectDemoAccount),
                    //const SizedBox(height: 24),

                    // Form container Card style matching the Web V2
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.deepBlue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        border: Border.all(
                          color: isDark ? Colors.white10 : AppColors.softGrey,
                          width: 1.0,
                        ),
                        boxShadow: const [AppShadows.shadowCard],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email SraInput
                            SraInput(
                              controller: _emailController,
                              label: localizations.email,
                              placeholder: "contact@email.com",
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                size: 18,
                                color: AppColors.champagneGold,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez saisir votre adresse email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value.trim())) {
                                  return 'Veuillez saisir une adresse email valide';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Password SraInput
                            SraInput(
                              controller: _passwordController,
                              label: localizations.password,
                              placeholder: "••••••••",
                              obscureText: _obscurePassword,
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                size: 18,
                                color: AppColors.champagneGold,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.champagneGold,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez saisir votre mot de passe';
                                }
                                if (value.length < 6) {
                                  return 'Le mot de passe doit comporter au moins 6 caractères';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            // Submit Button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoading) {
                                  return const LoadingIndicator(
                                    color: AppColors.champagneGold,
                                  );
                                }
                                return SraButton(
                                  onPressed: _submit,
                                  label: localizations.login,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    // Navigation links
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "${localizations.noAccountYet} ",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.register);
                          },
                          child: Text(
                            localizations.createAccount,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.champagneGold,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    /*Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
                        },
                        child: Text(
                          "← ${localizations.backToHome}",
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),*/
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
