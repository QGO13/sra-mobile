import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/buttons/sra_button.dart';
import 'package:sra_hotel/core/widgets/feedback/error_state_view.dart';
import 'package:sra_hotel/core/widgets/feedback/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/inputs/sra_input.dart';
import 'package:sra_hotel/core/widgets/layout/sra_data_table.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_bloc.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_event.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AdminRoomTypesView extends StatefulWidget {
  const AdminRoomTypesView({super.key});

  @override
  State<AdminRoomTypesView> createState() => _AdminRoomTypesViewState();
}

class _AdminRoomTypesViewState extends State<AdminRoomTypesView> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width >= AppDimensions.breakpointMd;

    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        if (state is RoomLoading || state is RoomInitial) {
          return const LoadingIndicator();
        } else if (state is RoomFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<RoomBloc>().add(LoadRoomsAndTypesEvent()),
          );
        } else if (state is RoomLoaded) {
          final types = state.roomTypes;
          final totalTypes = types.length;
          final avgPrice = totalTypes > 0 ? types.map((t) => t.prixNuit).reduce((a, b) => a + b) / totalTypes : 0.0;
          final totalCap = totalTypes > 0 ? types.map((t) => t.capacite).reduce((a, b) => a + b) : 0;
          final totalRoomsConfigured = state.rooms.length;

          final filteredTypes = types.where((t) {
            return t.nom.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                t.description.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Bandeau KPIs Supérieur ──
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = isWide ? (constraints.maxWidth - 30) / 4 : (constraints.maxWidth - 10) / 2;
                    return Wrap(
                      spacing: AppDimensions.spacingSm,
                      runSpacing: AppDimensions.spacingSm,
                      children: [
                        _buildKpiChip(l10n.roomTypesTitle, "$totalTypes", Icons.category_outlined, AppColors.gold, isDark, itemWidth),
                        _buildKpiChip(l10n.avgPricePerNight, _formatCurrency(avgPrice), Icons.payments_outlined, AppColors.statusSuccess, isDark, itemWidth),
                        _buildKpiChip(l10n.totalCapacity, "$totalCap pers.", Icons.groups_outlined, AppColors.statusInfo, isDark, itemWidth),
                        _buildKpiChip(l10n.totalRooms, "$totalRoomsConfigured ch.", Icons.meeting_room_outlined, AppColors.gold, isDark, itemWidth),
                      ],
                    );
                  },
                ),
              ),

              // ── Barre de recherche & Action ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                child: Row(
                  children: [
                    Expanded(
                      child: SraInput(
                        controller: _searchController,
                        placeholder: "Rechercher une typologie...",
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
                        onPressed: () => _showRoomTypeFormDialog(context, null),
                        icon: Icons.add,
                        label: l10n.typeLabel,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // ── Vue Tableau CRUD Unifiée ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                  child: SraDataTable<RoomType>(
                    items: filteredTypes,
                    minWidth: 700,
                    emptyTitle: 'Aucune typologie trouvée',
                    emptyIcon: Icons.list_alt_outlined,
                    columns: [
                      SraTableColumn<RoomType>(
                        label: "Typologie",
                        flex: 1.2,
                        cellBuilder: (context, type) => Text(
                          type.nom,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                      SraTableColumn<RoomType>(
                        label: l10n.pricePerNightLabel,
                        flex: 1.0,
                        cellBuilder: (context, type) => Text(
                          _formatCurrency(type.prixNuit),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.statusSuccess,
                          ),
                        ),
                      ),
                      SraTableColumn<RoomType>(
                        label: l10n.totalCapacity,
                        flex: 0.8,
                        cellBuilder: (context, type) => Row(
                          children: [
                            const Icon(Icons.person_outline, size: 16, color: AppColors.gold),
                            const SizedBox(width: 4),
                            Text(
                              "${type.capacite} pers.",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark ? AppColors.white : AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SraTableColumn<RoomType>(
                        label: "Chambres",
                        flex: 0.8,
                        cellBuilder: (context, type) {
                          final count = state.rooms.where((r) => r.idTypeDeChambre == type.id || r.type.toLowerCase() == type.nom.toLowerCase()).length;
                          return Text(
                            "$count ch.",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                            ),
                          );
                        },
                      ),
                      SraTableColumn<RoomType>(
                        label: l10n.descriptionLabel,
                        flex: 1.8,
                        cellBuilder: (context, type) => Text(
                          type.description.isNotEmpty ? type.description : "Aucune description",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                          ),
                        ),
                      ),
                      SraTableColumn<RoomType>(
                        label: "Actions",
                        flex: 0.8,
                        alignment: Alignment.centerRight,
                        cellBuilder: (context, type) => IconButton(
                          tooltip: "Modifier",
                          icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.statusInfo),
                          onPressed: () => _showRoomTypeFormDialog(context, type),
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

  Widget _buildKpiChip(String label, String value, IconData icon, Color color, bool isDark, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm + 2, vertical: AppDimensions.spacingSm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.mist),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRoomTypeFormDialog(BuildContext context, RoomType? type) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: type?.nom ?? '');
    final priceController = TextEditingController(text: type?.prixNuit.toString() ?? '');
    final capController = TextEditingController(text: type?.capacite.toString() ?? '2');
    final descController = TextEditingController(text: type?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          title: Text(
            type == null ? "Créer une typologie" : "Modifier la typologie",
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
                    placeholder: "Nom de la typologie",
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  SraInput(
                    controller: priceController,
                    placeholder: l10n.pricePerNightLabel,
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  SraInput(
                    controller: capController,
                    placeholder: l10n.capacityLabel,
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
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
                  final newType = RoomType(
                    id: type?.id ?? '',
                    nom: nameController.text,
                    prixNuit: double.tryParse(priceController.text) ?? 0.0,
                    capacite: int.tryParse(capController.text) ?? 1,
                    description: descController.text,
                    images: type?.images ?? [],
                  );

                  if (type == null) {
                    context.read<RoomBloc>().add(CreateRoomTypeEvent(newType));
                  } else {
                    context.read<RoomBloc>().add(UpdateRoomTypeEvent(newType));
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
