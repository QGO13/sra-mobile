import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/buttons/sra_button.dart';
import 'package:sra_hotel/core/widgets/feedback/confirm_delete_dialog.dart';
import 'package:sra_hotel/core/widgets/feedback/error_state_view.dart';
import 'package:sra_hotel/core/widgets/feedback/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/inputs/sra_input.dart';
import 'package:sra_hotel/core/widgets/layout/sra_data_table.dart';
import 'package:sra_hotel/features/service_management/domain/entities/hotel_service.dart';
import 'package:sra_hotel/features/service_management/presentation/bloc/service_bloc.dart';
import 'package:sra_hotel/features/service_management/presentation/bloc/service_event.dart';
import 'package:sra_hotel/features/service_management/presentation/bloc/service_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AdminServicesView extends StatelessWidget {
  const AdminServicesView({super.key});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading || state is ServiceInitial) {
          return const LoadingIndicator();
        } else if (state is ServiceFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<ServiceBloc>().add(LoadServicesEvent()),
          );
        } else if (state is ServiceLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.servicesTab,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: isDark ? AppColors.white : AppColors.ink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: SraButton(
                        onPressed: () => _showServiceFormDialog(context, null),
                        icon: Icons.add,
                        label: l10n.servicesTab.split(' ')[0],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                  child: SraDataTable<HotelService>(
                    items: state.services,
                    minWidth: 700,
                    emptyTitle: 'Aucun service hôtelier',
                    emptyIcon: Icons.design_services_outlined,
                    columns: [
                      SraTableColumn<HotelService>(
                        label: "Libellé du Service",
                        flex: 1.4,
                        cellBuilder: (context, service) => Text(
                          service.nom,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                      SraTableColumn<HotelService>(
                        label: "Tarif",
                        flex: 1.0,
                        cellBuilder: (context, service) => Text(
                          _formatCurrency(service.prix),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight2 : AppColors.gold,
                          ),
                        ),
                      ),
                      SraTableColumn<HotelService>(
                        label: l10n.categoryLabel,
                        flex: 1.0,
                        cellBuilder: (context, service) {
                          String localizedCat = service.categorie;
                          if (service.categorie == 'RESTAURATION') localizedCat = l10n.restorationCat;
                          if (service.categorie == 'SPA') localizedCat = l10n.spaCat;
                          if (service.categorie == 'TRANSPORT') localizedCat = l10n.transportCat;
                          return Text(
                            localizedCat,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.white : AppColors.ink,
                            ),
                          );
                        },
                      ),
                      SraTableColumn<HotelService>(
                        label: l10n.descriptionLabel,
                        flex: 1.8,
                        cellBuilder: (context, service) => Text(
                          service.description.isNotEmpty ? service.description : "Aucune description",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                          ),
                        ),
                      ),
                      SraTableColumn<HotelService>(
                        label: "Actions",
                        flex: 0.8,
                        alignment: Alignment.centerRight,
                        cellBuilder: (context, service) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: "Modifier",
                              icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.statusInfo),
                              onPressed: () => _showServiceFormDialog(context, service),
                            ),
                            IconButton(
                              tooltip: "Supprimer",
                              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusError),
                              onPressed: () async {
                                final serviceBloc = context.read<ServiceBloc>();
                                final confirmed = await ConfirmDeleteDialog.show(
                                  context,
                                  title: l10n.deleteServiceTitle,
                                  message: l10n.deleteServiceMessage,
                                  confirmLabel: l10n.deleteLabel,
                                  cancelLabel: l10n.cancelLabel,
                                  isDestructive: true,
                                );
                                if (confirmed) {
                                  serviceBloc.add(DeleteServiceEvent(service.id));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  void _showServiceFormDialog(BuildContext context, HotelService? service) {
    final formKey = GlobalKey<FormState>();
    final nomController = TextEditingController(text: service?.nom ?? '');
    final prixController = TextEditingController(text: service?.prix.toString() ?? '');
    final descController = TextEditingController(text: service?.description ?? '');
    String selectedCat = service?.categorie ?? 'RESTAURATION';

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          title: Text(
            service == null ? "Créer un service" : "Modifier le service",
            style: AppTextStyles.titleMedium.copyWith(
              color: isDark ? AppColors.white : AppColors.ink,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SraInput(
                    controller: nomController,
                    placeholder: "Nom du service",
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  SraInput(
                    controller: prixController,
                    placeholder: "Prix (FCFA)",
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  DropdownButtonFormField<String>(
                    initialValue: selectedCat,
                    decoration: InputDecoration(
                      labelText: l10n.categoryLabel,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 'RESTAURATION', child: Text(l10n.restorationCat)),
                      DropdownMenuItem(value: 'SPA', child: Text(l10n.spaCat)),
                      DropdownMenuItem(value: 'TRANSPORT', child: Text(l10n.transportCat)),
                      const DropdownMenuItem(value: 'AUTRE', child: Text('Autre')),
                    ],
                    onChanged: (v) {
                      if (v != null) selectedCat = v;
                    },
                  ),
                  AppDimensions.vGapMd,
                  SraInput(
                    controller: descController,
                    placeholder: l10n.descriptionLabel,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            SraButton.secondary(
              label: l10n.cancelLabel,
              onPressed: () => Navigator.pop(ctx),
            ),
            SraButton(
              label: 'Enregistrer',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newService = HotelService(
                    id: service?.id ?? 0,
                    nom: nomController.text,
                    prix: double.tryParse(prixController.text) ?? 0.0,
                    categorie: selectedCat,
                    description: descController.text,
                  );

                  if (service == null) {
                    context.read<ServiceBloc>().add(CreateServiceEvent(newService));
                  } else {
                    context.read<ServiceBloc>().add(UpdateServiceEvent(newService));
                  }
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
