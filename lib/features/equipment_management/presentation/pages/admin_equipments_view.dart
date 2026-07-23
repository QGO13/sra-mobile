import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
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

    return BlocBuilder<EquipmentBloc, EquipmentState>(
      builder: (context, state) {
        if (state is EquipmentLoading || state is EquipmentInitial) {
          return const LoadingWidget();
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

          final l10n = AppLocalizations.of(context)!;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  children: [
                    Expanded(
                      child: SraInput(
                        controller: _searchController,
                        placeholder: l10n.searchEquipmentPlaceholder,
                        prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.champagneGold),
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
              Expanded(
                child: filtered.isEmpty
                  ? const EmptyStateView(icon: Icons.electrical_services_outlined)
                  : ResponsiveListGridView(
                      itemCount: filtered.length,
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                      maxCrossAxisExtent: 450,
                      mainAxisExtent: 110,
                      itemBuilder: (context, index) {
                        final eq = filtered[index];
                        final isAvailable = eq.status == 'AVAILABLE';

                        return Opacity(
                          opacity: isAvailable ? 1.0 : 0.5,
                          child: Container(
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
                                        eq.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(height: AppDimensions.spacingXs / 2),
                                      Text(
                                        eq.description.isNotEmpty ? eq.description : l10n.noDescription,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5),
                                      ),
                                      const SizedBox(height: AppDimensions.spacingXs),
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: isAvailable ? AppColors.statusSuccess : AppColors.statusError,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: AppDimensions.spacingSm - 2),
                                          Text(
                                            (isAvailable ? l10n.availableStatus : l10n.unavailableStatus).toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: isAvailable ? AppColors.statusSuccess : AppColors.statusError,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: AppColors.statusInfo),
                                      onPressed: () => _showEquipmentFormDialog(context, eq),
                                    ),
                                    Switch(
                                      value: isAvailable,
                                      activeTrackColor: AppColors.champagneGold,
                                      onChanged: (val) {
                                        final updated = Equipment(
                                          id: eq.id,
                                          name: eq.name,
                                          description: eq.description,
                                          status: val ? 'AVAILABLE' : 'UNAVAILABLE',
                                        );
                                        context.read<EquipmentBloc>().add(UpdateEquipmentEvent(updated));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

  void _showEquipmentFormDialog(BuildContext context, Equipment? eq) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: eq?.name ?? '');
    final descController = TextEditingController(text: eq?.description ?? '');
    final rawStatus = (eq?.status ?? 'AVAILABLE').toUpperCase();
    String selectedStatus = 'AVAILABLE';
    if (rawStatus == 'UNAVAILABLE' || rawStatus == 'MAUVAIS_ETAT' || rawStatus == 'INDISPONIBLE') {
      selectedStatus = 'UNAVAILABLE';
    }
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
          title: Text(
            eq == null ? l10n.addEquipment : l10n.editEquipment,
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
                    label: l10n.equipmentNameLabel,
                    placeholder: "e.g. Téléviseur",
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
                    value: selectedStatus,
                    label: l10n.statusLabel,
                    placeholder: l10n.selectOption,
                    items: const ["AVAILABLE", "UNAVAILABLE"],
                    itemLabels: {
                      "AVAILABLE": l10n.availableStatus,
                      "UNAVAILABLE": l10n.unavailableStatus,
                    },
                    onChanged: (val) {
                      if (val != null) selectedStatus = val;
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
                  final e = Equipment(
                    id: eq?.id ?? '',
                    name: nameController.text,
                    description: descController.text,
                    status: selectedStatus,
                  );
                  if (eq == null) {
                    context.read<EquipmentBloc>().add(CreateEquipmentEvent(e));
                  } else {
                    context.read<EquipmentBloc>().add(UpdateEquipmentEvent(e));
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
