import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
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
          return const Center(child: LoadingIndicator(color: AppColors.champagneGold));
        } else if (state is ServiceFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<ServiceBloc>().add(LoadServicesEvent()),
          );
        } else if (state is ServiceLoaded) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.servicesTab,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm + 4),
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
                child: state.services.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.design_services_outlined,
                      )
                    : ResponsiveListGridView(
                        itemCount: state.services.length,
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                        maxCrossAxisExtent: 450,
                        mainAxisExtent: 110,
                        itemBuilder: (context, index) {
                    final service = state.services[index];

                    String localizedCat = service.categorie;
                    if (service.categorie == 'RESTAURATION') localizedCat = l10n.restorationCat;
                    if (service.categorie == 'SPA') localizedCat = l10n.spaCat;
                    if (service.categorie == 'TRANSPORT') localizedCat = l10n.transportCat;

                      return Container(
                        margin: MediaQuery.of(context).size.width < AppDimensions.breakpointMd
                            ? const EdgeInsets.only(bottom: AppDimensions.spacingSm + 2)
                            : EdgeInsets.zero,
                        padding: const EdgeInsets.all(AppDimensions.spacingSm + 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.deepBlue : Colors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                          border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                          boxShadow: const [AppShadows.shadowCard],
                        ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.nom,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: AppDimensions.spacingXs / 2),
                                Text(
                                  _formatCurrency(service.prix),
                                  style: const TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  "${l10n.categoryLabel} : $localizedCat • ${service.description}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.statusInfo),
                                onPressed: () => _showServiceFormDialog(context, service),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.statusError),
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
                        ],
                      ),
                    );
                  },
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
    final nameController = TextEditingController(text: service?.nom ?? '');
    final priceController = TextEditingController(text: service?.prix.toString() ?? '');
    final descController = TextEditingController(text: service?.description ?? '');
    String selectedCat = service?.categorie ?? "RESTAURATION";
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
          title: Text(
            service == null ? l10n.addService : l10n.editService,
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.champagneGold),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SraInput(
                    controller: nameController,
                    label: l10n.serviceNameLabel,
                    placeholder: "e.g. Petit déjeuner",
                    validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  SraInput(
                    controller: priceController,
                    label: l10n.priceLabel,
                    placeholder: "e.g. 5000",
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  SraInput(
                    controller: descController,
                    label: l10n.descriptionLabel,
                    placeholder: "Description",
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  SraDropdown(
                    value: selectedCat,
                    label: l10n.categoryLabel,
                    placeholder: l10n.selectOption,
                    items: const ["RESTAURATION", "SPA", "TRANSPORT"],
                    itemLabels: {
                      "RESTAURATION": l10n.restorationCat,
                      "SPA": l10n.spaCat,
                      "TRANSPORT": l10n.transportCat,
                    },
                    onChanged: (val) {
                      if (val != null) selectedCat = val;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            SraButton(
              label: l10n.cancelLabel,
              isOutlined: true,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            SraButton(
              label: l10n.validateLabel,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final s = HotelService(
                    id: service?.id ?? 0,
                    nom: nameController.text,
                    prix: double.parse(priceController.text),
                    categorie: selectedCat,
                    description: descController.text,
                  );
                  if (service == null) {
                    context.read<ServiceBloc>().add(CreateServiceEvent(s));
                  } else {
                    context.read<ServiceBloc>().add(UpdateServiceEvent(s));
                  }
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
