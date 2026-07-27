import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/buttons/sra_button.dart';
import 'package:sra_hotel/core/widgets/display/sra_filter_bar.dart';
import 'package:sra_hotel/core/widgets/display/sra_status_badge.dart';
import 'package:sra_hotel/core/widgets/feedback/confirm_delete_dialog.dart';
import 'package:sra_hotel/core/widgets/feedback/error_state_view.dart';
import 'package:sra_hotel/core/widgets/feedback/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/inputs/sra_input.dart';
import 'package:sra_hotel/core/widgets/layout/sra_data_table.dart';
import 'package:sra_hotel/features/equipment_management/domain/entities/equipment.dart';
import 'package:sra_hotel/features/equipment_management/presentation/bloc/equipment_bloc.dart';
import 'package:sra_hotel/features/equipment_management/presentation/bloc/equipment_event.dart';
import 'package:sra_hotel/features/equipment_management/presentation/bloc/equipment_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AdminEquipmentsView extends StatefulWidget {
  const AdminEquipmentsView({super.key});

  @override
  State<AdminEquipmentsView> createState() => _AdminEquipmentsViewState();
}

class _AdminEquipmentsViewState extends State<AdminEquipmentsView> {
  String _searchQuery = "";
  String _selectedFilter = "all";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<EquipmentBloc>().add(LoadEquipmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<EquipmentBloc, EquipmentState>(
      builder: (context, state) {
        if (state is EquipmentLoading || state is EquipmentInitial) {
          return const LoadingIndicator();
        } else if (state is EquipmentFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<EquipmentBloc>().add(LoadEquipmentsEvent()),
          );
        } else if (state is EquipmentLoaded) {
          final filtered = state.equipments.where((eq) {
            final matchesSearch = eq.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                eq.description.toLowerCase().contains(_searchQuery.toLowerCase());
            bool matchesFilter = true;
            if (_selectedFilter == "available") {
              matchesFilter = eq.status == "AVAILABLE";
            } else if (_selectedFilter == "unavailable") {
              matchesFilter = eq.status == "UNAVAILABLE";
            }
            return matchesSearch && matchesFilter;
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Barre de recherche & Action ──
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  children: [
                    Expanded(
                      child: SraInput(
                        controller: _searchController,
                        placeholder: l10n.searchEquipmentPlaceholder,
                        prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.gold),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = "";
                                  });
                                },
                              )
                            : null,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm + 4),
                    Flexible(
                      fit: FlexFit.loose,
                      child: SraButton(
                        onPressed: () => _showEquipmentFormDialog(context, null),
                        icon: Icons.add,
                        label: l10n.equipment,
                      ),
                    ),
                  ],
                ),
              ),
              SraFilterBar(
                items: [
                  SraFilterItem(id: 'all', label: l10n.allFilter),
                  SraFilterItem(id: 'available', label: l10n.availableStatus),
                  SraFilterItem(id: 'unavailable', label: l10n.unavailableStatus),
                ],
                selectedId: _selectedFilter,
                onSelected: (id) {
                  setState(() {
                    _selectedFilter = id;
                  });
                },
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // ── Vue Tableau CRUD Unifiée ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                  child: SraDataTable<Equipment>(
                    items: filtered,
                    minWidth: 650,
                    emptyTitle: 'Aucun équipement enregistré',
                    emptyIcon: Icons.electrical_services_outlined,
                    columns: [
                      SraTableColumn<Equipment>(
                        label: "Équipement",
                        flex: 1.4,
                        cellBuilder: (context, eq) => Text(
                          eq.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                      SraTableColumn<Equipment>(
                        label: "Statut",
                        flex: 1.0,
                        cellBuilder: (context, eq) {
                          final isAvailable = eq.status == 'AVAILABLE';
                          return SraStatusBadge(
                            label: isAvailable ? l10n.availableStatus : l10n.unavailableStatus,
                            type: isAvailable ? SraStatusType.success : SraStatusType.error,
                            small: true,
                          );
                        },
                      ),
                      SraTableColumn<Equipment>(
                        label: l10n.descriptionLabel,
                        flex: 2.0,
                        cellBuilder: (context, eq) => Text(
                          eq.description.isNotEmpty ? eq.description : "Aucune description",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                          ),
                        ),
                      ),
                      SraTableColumn<Equipment>(
                        label: "Actions",
                        flex: 0.8,
                        alignment: Alignment.centerRight,
                        cellBuilder: (context, eq) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: "Modifier",
                              icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.statusInfo),
                              onPressed: () => _showEquipmentFormDialog(context, eq),
                            ),
                            IconButton(
                              tooltip: "Supprimer",
                              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.statusError),
                              onPressed: () async {
                                final eqBloc = context.read<EquipmentBloc>();
                                final confirmed = await ConfirmDeleteDialog.show(
                                  context,
                                  title: l10n.deleteEquipmentTitle,
                                  message: "Voulez-vous supprimer cet équipement ?",
                                  confirmLabel: l10n.deleteLabel,
                                  cancelLabel: l10n.cancelLabel,
                                  isDestructive: true,
                                );
                                if (confirmed) {
                                  eqBloc.add(DeleteEquipmentEvent(eq.id));
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

  void _showEquipmentFormDialog(BuildContext context, Equipment? eq) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: eq?.name ?? '');
    final descController = TextEditingController(text: eq?.description ?? '');
    String selectedStatus = eq?.status ?? 'AVAILABLE';

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          title: Text(
            eq == null ? "Créer un équipement" : "Modifier l'équipement",
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
                    controller: nameController,
                    placeholder: "Nom de l'équipement",
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: InputDecoration(
                      labelText: l10n.statusLabel,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(value: 'AVAILABLE', child: Text(l10n.availableStatus)),
                      DropdownMenuItem(value: 'UNAVAILABLE', child: Text(l10n.unavailableStatus)),
                    ],
                    onChanged: (v) {
                      if (v != null) selectedStatus = v;
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
                  final newEq = Equipment(
                    id: eq?.id ?? '',
                    name: nameController.text,
                    status: selectedStatus,
                    description: descController.text,
                  );

                  if (eq == null) {
                    context.read<EquipmentBloc>().add(CreateEquipmentEvent(newEq));
                  } else {
                    context.read<EquipmentBloc>().add(UpdateEquipmentEvent(newEq));
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
