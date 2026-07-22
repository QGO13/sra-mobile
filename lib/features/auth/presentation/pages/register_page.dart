import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/core/widgets/sra_logo.dart';
import 'package:sra_hotel/core/widgets/sra_input.dart';
import 'package:sra_hotel/core/widgets/sra_dropdown.dart';
import 'package:sra_hotel/core/widgets/phone_input_field.dart';
import 'package:sra_hotel/core/constants/countries.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final String _profileType = 'Particulier'; // 'Particulier', 'Corporate', 'Agence'

  // Text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  String _fullPhoneNumber = '';
  String? _selectedCountry;
  final _addressController = TextEditingController();

  // Particulier Specific Controllers
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  String _selectedGender = 'M';

  // Company Specific Controllers
  final _companyNameController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      // Le numéro complet (indicatif + numéro local) est construit par PhoneInputField
      final phone = _fullPhoneNumber.isNotEmpty
          ? _fullPhoneNumber
          : _phoneController.text.trim();
      final country = _selectedCountry ?? '';
      final address = _addressController.text.trim();

      if (_profileType == 'Particulier') {
        context.read<AuthBloc>().add(
          RegisterParticulierSubmitted(
            email: email,
            password: password,
            nom: _lastNameController.text.trim(),
            prenoms: _firstNameController.text.trim(),
            telephone: phone,
            sexe: _selectedGender,
            pays: country,
            adresse: address,
          ),
        );
      } else {
        final isAgence = _profileType == 'Agence';
        context.read<AuthBloc>().add(
          RegisterCompanySubmitted(
            email: email,
            password: password,
            companyName: _companyNameController.text.trim(),
            telephone: phone,
            pays: country,
            adresse: address,
            isExterne: isAgence,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations.createAccount),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.champagneGold),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.search, (route) => false);
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SraLogo(size: 80),
                    const SizedBox(height: 16),
                    Text(
                      localizations.welcomeBack,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : AppColors.imperialNightBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      localizations.joinSlogan,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Profile type selection hidden - physically forced to 'Particulier' (Personne physique)
                    const SizedBox.shrink(),
                    const SizedBox(height: 12),

                    // Form container Card style matching the Web
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.deepBlue : Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        border: Border.all(
                          color: isDark ? Colors.white10 : AppColors.softGrey,
                          width: 1.0,
                        ),
                        boxShadow: const [AppShadows.shadowCard],
                      ),
                      child: Form(
                        key: _formKey,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 550;

                            Widget buildEmailField() => SraInput(
                              controller: _emailController,
                              label: localizations.email,
                              placeholder: "contact@email.com",
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email_outlined, size: 18, color: AppColors.champagneGold),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez saisir votre adresse email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                                  return 'Veuillez saisir une adresse email valide';
                                }
                                return null;
                              },
                            );

                            Widget buildPasswordField() => SraInput(
                              controller: _passwordController,
                              label: localizations.password,
                              placeholder: "••••••••",
                              obscureText: _obscurePassword,
                              prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.champagneGold),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
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
                            );

                            Widget buildLastNameField() => SraInput(
                              controller: _lastNameController,
                              label: localizations.lastNameLabel,
                              placeholder: "Traoré",
                              prefixIcon: const Icon(Icons.person_outline, size: 18, color: AppColors.champagneGold),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty) ? 'Veuillez saisir votre nom' : null,
                            );

                            Widget buildFirstNameField() => SraInput(
                              controller: _firstNameController,
                              label: localizations.firstNameLabel,
                              placeholder: "Koffi",
                              prefixIcon: const Icon(Icons.person_outline, size: 18, color: AppColors.champagneGold),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty) ? 'Veuillez saisir votre prénom' : null,
                            );

                            Widget buildGenderField() => SraDropdown(
                              label: localizations.genderLabel,
                              value: _selectedGender,
                              placeholder: "",
                              items: const ['M', 'F'],
                              itemLabels: {
                                'M': localizations.maleGender,
                                'F': localizations.femaleGender,
                              },
                              prefixIcon: const Icon(Icons.wc_outlined, size: 18, color: AppColors.champagneGold),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value ?? 'M';
                                });
                              },
                            );

                            Widget buildCompanyField() => SraInput(
                              controller: _companyNameController,
                              label: localizations.companyNameLabel,
                              placeholder: "SRA Enterprise SA",
                              prefixIcon: const Icon(Icons.business_outlined, size: 18, color: AppColors.champagneGold),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty) ? 'Veuillez saisir la raison sociale' : null,
                            );

                            Widget buildPhoneField() => PhoneInputField(
                              numberController: _phoneController,
                              initialCountryCode: 'CI',
                              onChanged: (fullNumber) {
                                setState(() => _fullPhoneNumber = fullNumber);
                              },
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                      ? 'Veuillez saisir votre numéro de téléphone'
                                      : null,
                            );

                            Widget buildCountryField() => SraDropdown(
                              value: _selectedCountry,
                              items: Countries.list,
                              label: localizations.countryLabel,
                              placeholder: "Sélectionnez votre pays",
                              prefixIcon: const Icon(Icons.flag_outlined, size: 18, color: AppColors.champagneGold),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty) ? 'Veuillez choisir votre pays' : null,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCountry = value;
                                });
                              },
                            );

                            Widget buildAddressField() => SraInput(
                              controller: _addressController,
                              label: localizations.physicalAddressLabel,
                              placeholder: "Abidjan, Cocody Mermoz",
                              maxLines: 2,
                              prefixIcon: const Icon(Icons.location_on_outlined, size: 18, color: AppColors.champagneGold),
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty) ? 'Veuillez saisir votre adresse' : null,
                            );

                            if (isWide) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: buildEmailField()),
                                      const SizedBox(width: 16),
                                      Expanded(child: buildPasswordField()),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  if (_profileType == 'Particulier') ...[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: buildLastNameField()),
                                        const SizedBox(width: 16),
                                        Expanded(child: buildFirstNameField()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: buildGenderField()),
                                        const SizedBox(width: 16),
                                        Expanded(child: buildPhoneField()),
                                      ],
                                    ),
                                  ] else ...[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: buildCompanyField()),
                                        const SizedBox(width: 16),
                                        Expanded(child: buildPhoneField()),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: buildCountryField()),
                                      const SizedBox(width: 16),
                                      Expanded(child: buildAddressField()),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) {
                                      if (state is AuthLoading) {
                                        return const LoadingIndicator(color: AppColors.champagneGold);
                                      }
                                      return SraButton(
                                        onPressed: _submit,
                                        label: localizations.createProfileButton,
                                      );
                                    },
                                  ),
                                ],
                              );
                            }

                            // Mobile (narrow layout)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                buildEmailField(),
                                const SizedBox(height: 16),
                                buildPasswordField(),
                                const SizedBox(height: 16),
                                if (_profileType == 'Particulier') ...[
                                  buildLastNameField(),
                                  const SizedBox(height: 16),
                                  buildFirstNameField(),
                                  const SizedBox(height: 16),
                                  buildGenderField(),
                                ] else ...[
                                  buildCompanyField(),
                                ],
                                const SizedBox(height: 16),
                                buildPhoneField(),
                                const SizedBox(height: 16),
                                buildCountryField(),
                                const SizedBox(height: 16),
                                buildAddressField(),
                                const SizedBox(height: 32),
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    if (state is AuthLoading) {
                                      return const LoadingIndicator(color: AppColors.champagneGold);
                                    }
                                    return SraButton(
                                      onPressed: _submit,
                                      label: localizations.createProfileButton,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Go back
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${localizations.alreadyHaveAccount} ",
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            localizations.login,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.champagneGold,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
