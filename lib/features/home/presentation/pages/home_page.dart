import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/core/widgets/confirm_delete_dialog.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.champagneGold),
            onPressed: () async {
              final confirmed = await ConfirmDeleteDialog.show(
                context,
                title: localizations.confirmLogoutTitle,
                message: localizations.confirmLogoutMessage,
                confirmLabel: localizations.logout,
                cancelLabel: localizations.cancelLabel,
                isDestructive: false,
              );
              if (confirmed && context.mounted) {
                context.read<AuthBloc>().add(LogoutRequested());
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingIndicator();
          }

          if (state is Authenticated) {
            final user = state.user;
            final isCompany = user.prenoms == 'Corporate' || user.prenoms == 'Agence';

            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                      const Icon(
                        Icons.account_circle_outlined,
                        size: 90,
                        color: AppColors.champagneGold,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isCompany ? localizations.professionalSpace : localizations.clientSpace,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.champagneGold,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.nom ?? "Utilisateur",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (user.prenoms != null && !isCompany) ...[
                        const SizedBox(height: 4),
                        Text(
                          user.prenoms!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.anthracite.withValues(alpha: 0.8),
                            fontSize: 18,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      // User detail container V2
                      Container(
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? AppColors.deepBlue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                          border: Border.all(
                            color: theme.brightness == Brightness.dark ? Colors.white10 : AppColors.softGrey,
                            width: 1.0,
                          ),
                          boxShadow: const [AppShadows.shadowCard],
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(context, localizations.idEmailLabel, user.login),
                            const Divider(height: 24),
                            _buildDetailRow(
                              context,
                              localizations.profileLabel,
                              isCompany ? (user.prenoms == 'Agence' ? localizations.partnerAgency : localizations.corporate) : localizations.individual,
                            ),
                            const Divider(height: 24),
                            _buildDetailRow(context, localizations.phoneLabelWithColon, user.telephone ?? localizations.notSpecified),
                            const Divider(height: 24),
                            _buildDetailRow(context, localizations.systemRoleLabel, user.role.toUpperCase()),
                            const Divider(height: 24),
                            _buildDetailRow(context, localizations.countryLabelWithColon, user.pays ?? localizations.notSpecified),
                            if (user.adresse != null && user.adresse!.isNotEmpty) ...[
                              const Divider(height: 24),
                              _buildDetailRow(context, localizations.addressLabelWithColon, user.adresse!),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                   SraButton(
                     onPressed: () {
                       Navigator.of(context).pushNamed(AppRoutes.search);
                     },
                     icon: Icons.search,
                     label: localizations.searchRoom,
                     backgroundColor: AppColors.champagneGold,
                     foregroundColor: Colors.black,
                   ),
                    const SizedBox(height: 24),
                   SraButton(
                     onPressed: () async {
                       final confirmed = await ConfirmDeleteDialog.show(
                         context,
                         title: localizations.confirmLogoutTitle,
                         message: localizations.confirmLogoutMessage,
                         confirmLabel: localizations.logout,
                         cancelLabel: localizations.cancelLabel,
                         isDestructive: false,
                       );
                       if (confirmed && context.mounted) {
                         context.read<AuthBloc>().add(LogoutRequested());
                       }
                     },
                     icon: Icons.logout,
                     label: localizations.logout,
                     backgroundColor: Colors.redAccent,
                     foregroundColor: Colors.white,
                   ),
                   const SizedBox(height: 12),
                       ],
                     ),
                   ),
                 ),
               ),
             );
           }
 
           return Center(
             child: Text(localizations.authSessionExpired),
           );
        },
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.champagneGold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: theme.brightness == Brightness.dark ? Colors.white : AppColors.anthracite,
            ),
          ),
        ),
      ],
    );
  }
}

