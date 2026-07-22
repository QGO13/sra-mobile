import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Onglet "Mon Profil" du shell client.
/// Affiche les informations du compte connecté.
class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: LoadingIndicator(color: AppColors.champagneGold));
        }

        if (state is Authenticated) {
          final user = state.user;
          final isCompany = user.prenoms == 'Corporate' || user.prenoms == 'Agence';

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Avatar section ──
                    const SizedBox(height: AppDimensions.spacingMd),
                    Center(
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.champagneGold,
                            width: AppDimensions.borderMedium,
                          ),
                          color: AppColors.champagneGold.withValues(alpha: 0.08),
                        ),
                        child: const Icon(
                          Icons.account_circle_outlined,
                          size: 52,
                          color: AppColors.champagneGold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),

                    // ── Name ──
                    Text(
                      isCompany
                          ? (user.prenoms == 'Agence' ? 'Agence Partenaire' : 'Espace Professionnel')
                          : 'Espace Client',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelUppercase.copyWith(
                        color: AppColors.champagneGold,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      user.nom ?? 'Utilisateur',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.displayMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (user.prenoms != null && !isCompany) ...[
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        user.prenoms!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppDimensions.spacingXl),

                    // ── Info card V2 ──
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.deepBlue : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        border: Border.all(
                          color: isDark ? Colors.white10 : AppColors.softGrey,
                          width: 1.0,
                        ),
                        boxShadow: const [AppShadows.shadowCard],
                      ),
                      padding: const EdgeInsets.all(AppDimensions.spacingLg),
                      child: Column(
                        children: [
                          _buildRow(context, l10n.emailLabel, user.login, isDark),
                          _buildDivider(),
                          _buildRow(
                            context,
                            l10n.roleLabel,
                            isCompany
                                ? (user.prenoms == 'Agence' ? 'Agence Partenaire' : 'Corporate')
                                : 'Particulier',
                            isDark,
                          ),
                          _buildDivider(),
                          _buildRow(context, l10n.phoneLabel, user.telephone ?? 'Non renseigné', isDark),
                          _buildDivider(),
                          _buildRow(context, l10n.countryLabel, user.pays ?? 'Non renseigné', isDark),
                          if (user.adresse != null && user.adresse!.isNotEmpty) ...[
                            _buildDivider(),
                            _buildRow(context, l10n.physicalAddressLabel, user.adresse!, isDark),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXxl),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(
          child: Text(
            'Erreur de session.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.statusError),
          ),
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.champagneGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? AppColors.ecruWhite : AppColors.imperialNightBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(
        height: AppDimensions.spacingLg,
        thickness: AppDimensions.borderThin,
        color: AppColors.softGrey,
      );
}
