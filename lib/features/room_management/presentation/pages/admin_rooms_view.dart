import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/buttons/sra_button.dart';
import 'package:sra_hotel/core/widgets/display/sra_filter_bar.dart';
import 'package:sra_hotel/core/widgets/display/sra_status_badge.dart';
import 'package:sra_hotel/core/widgets/feedback/error_state_view.dart';
import 'package:sra_hotel/core/widgets/feedback/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/inputs/sra_input.dart';
import 'package:sra_hotel/core/widgets/layout/sra_data_table.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_bloc.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_event.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AdminRoomsView extends StatefulWidget {
  const AdminRoomsView({super.key});

  @override
  State<AdminRoomsView> createState() => _AdminRoomsViewState();
}

class _AdminRoomsViewState extends State<AdminRoomsView> {
  String _searchQuery = "";
  String _selectedFilter = "all";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesFilter(Room room, String filter) {
    switch (filter) {
      case "available":
        return room.occupee == 0 && room.estActive == 1 && room.statutMenage != 'MAINTENANCE';
      case "occupied":
        return room.occupee == 1;
      case "to_clean":
        return room.statutMenage == 'SALE' || room.statutMenage == 'A_NETTOYER' || room.statutMenage == 'EN_COURS';
      case "maintenance":
        return room.statutMenage == 'MAINTENANCE' || room.estActive == 0;
      case "all":
      default:
        return true;
    }
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
          final allRooms = state.rooms;
          final totalRooms = allRooms.length;
          final freeRooms = allRooms.where((r) => r.occupee == 0 && r.estActive == 1).length;
          final occupiedRooms = allRooms.where((r) => r.occupee == 1).length;
          final toCleanRooms = allRooms.where((r) => r.statutMenage == 'SALE' || r.statutMenage == 'A_NETTOYER' || r.statutMenage == 'EN_COURS').length;
          final maintenanceRooms = allRooms.where((r) => r.statutMenage == 'MAINTENANCE' || r.estActive == 0).length;
          final occRate = totalRooms > 0 ? ((occupiedRooms / totalRooms) * 100).toStringAsFixed(0) : "0";

          final filteredRooms = allRooms.where((room) {
            final matchesQuery = room.numero.contains(_searchQuery) ||
                room.type.toLowerCase().contains(_searchQuery.toLowerCase());
            return matchesQuery && _matchesFilter(room, _selectedFilter);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Bandeau KPIs Supérieur ──
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = isWide ? (constraints.maxWidth - 40) / 5 : (constraints.maxWidth - 10) / 2;
                    return Wrap(
                      spacing: AppDimensions.spacingSm,
                      runSpacing: AppDimensions.spacingSm,
                      children: [
                        _buildKpiChip(l10n.totalRooms, "$totalRooms", Icons.hotel, AppColors.gold, isDark, itemWidth),
                        _buildKpiChip(l10n.libre, "$freeRooms", Icons.check_circle_outline, AppColors.statusSuccess, isDark, itemWidth),
                        _buildKpiChip(l10n.occupee, "$occupiedRooms", Icons.person_outline, AppColors.statusInfo, isDark, itemWidth),
                        _buildKpiChip(l10n.roomStatusToClean, "$toCleanRooms", Icons.cleaning_services_outlined, AppColors.statusWarning, isDark, itemWidth),
                        _buildKpiChip(l10n.occupancyRateLabel, "$occRate%", Icons.bar_chart, AppColors.gold, isDark, itemWidth),
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
                        placeholder: l10n.searchRoomPlaceholder,
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
                    const SizedBox(width: AppDimensions.spacingSm),
                    Flexible(
                      fit: FlexFit.loose,
                      child: SraButton(
                        onPressed: () => _showRoomFormDialog(context, null, state.roomTypes),
                        icon: Icons.add,
                        label: l10n.room,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),

              // ── Chips de Filtrage par Statut ──
              SraFilterBar(
                items: [
                  SraFilterItem(id: 'all', label: "${l10n.filterAll} ($totalRooms)"),
                  SraFilterItem(id: 'available', label: "${l10n.libre} ($freeRooms)"),
                  SraFilterItem(id: 'occupied', label: "${l10n.occupee} ($occupiedRooms)"),
                  SraFilterItem(id: 'to_clean', label: "${l10n.roomStatusToClean} ($toCleanRooms)"),
                  SraFilterItem(id: 'maintenance', label: "${l10n.roomStatusMaintenance} ($maintenanceRooms)"),
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
                  child: SraDataTable<Room>(
                    items: filteredRooms,
                    minWidth: 700,
                    emptyTitle: 'Aucune chambre trouvée',
                    emptyIcon: Icons.meeting_room_outlined,
                    columns: [
                      SraTableColumn<Room>(
                        label: l10n.roomNumberLabel,
                        flex: 0.8,
                        cellBuilder: (context, room) => Text(
                          "CH. ${room.numero}",
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight2 : AppColors.gold,
                          ),
                        ),
                      ),
                      SraTableColumn<Room>(
                        label: l10n.typeLabel,
                        flex: 1.2,
                        cellBuilder: (context, room) => Text(
                          room.type,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDark ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                      SraTableColumn<Room>(
                        label: l10n.floorLabel,
                        flex: 0.6,
                        cellBuilder: (context, room) => Text(
                          "Étage ${room.etage}",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                          ),
                        ),
                      ),
                      SraTableColumn<Room>(
                        label: l10n.statusLabel,
                        flex: 1.4,
                        cellBuilder: (context, room) {
                          if (room.estActive == 0) {
                            return const SraStatusBadge.custom(label: 'Hors service', color: AppColors.inkMuted, small: true);
                          }
                          if (room.occupee == 1) {
                            return SraStatusBadge.info(
                              label: '${l10n.occupee}${room.clientActuel != null ? ' (${room.clientActuel})' : ''}',
                              small: true,
                            );
                          }
                          switch (room.statutMenage) {
                            case 'PROPRE':
                              return SraStatusBadge.success(label: 'Disponible', small: true);
                            case 'SALE':
                            case 'A_NETTOYER':
                            case 'EN_COURS':
                              return SraStatusBadge.warning(label: l10n.roomStatusToClean, small: true);
                            case 'MAINTENANCE':
                            default:
                              return SraStatusBadge.error(label: l10n.roomStatusMaintenance, small: true);
                          }
                        },
                      ),
                      SraTableColumn<Room>(
                        label: "Actions",
                        flex: 1.0,
                        alignment: Alignment.centerRight,
                        cellBuilder: (context, room) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: "Modifier",
                              icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.statusInfo),
                              onPressed: () => _showRoomFormDialog(context, room, state.roomTypes),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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

  void _showRoomFormDialog(BuildContext context, Room? room, List<RoomType> roomTypes) {
    final formKey = GlobalKey<FormState>();
    final noController = TextEditingController(text: room?.numero ?? '');
    final floorController = TextEditingController(text: room?.etage.toString() ?? '');
    String? selectedTypeId = room?.idTypeDeChambre ?? (roomTypes.isNotEmpty ? roomTypes.first.id : null);
    String selectedInitialStatus = 'PROPRE';

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final l10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
          title: Text(
            room == null ? "Créer une chambre" : "Modifier la chambre",
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
                    controller: noController,
                    placeholder: l10n.roomNumberLabel,
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  SraInput(
                    controller: floorController,
                    placeholder: l10n.floorLabel,
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                  ),
                  AppDimensions.vGapMd,
                  DropdownButtonFormField<String>(
                    initialValue: selectedTypeId,
                    decoration: const InputDecoration(
                      labelText: 'Type de chambre',
                      border: OutlineInputBorder(),
                    ),
                    items: roomTypes
                        .map((t) => DropdownMenuItem(value: t.id, child: Text(t.nom)))
                        .toList(),
                    onChanged: (v) => selectedTypeId = v,
                  ),
                  if (room == null) ...[
                    AppDimensions.vGapMd,
                    DropdownButtonFormField<String>(
                      initialValue: selectedInitialStatus,
                      decoration: InputDecoration(
                        labelText: l10n.roomInitialStatusLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: 'PROPRE', child: Text(l10n.roomStatusAvailable)),
                        DropdownMenuItem(value: 'SALE', child: Text(l10n.roomStatusToClean)),
                        DropdownMenuItem(value: 'MAINTENANCE', child: Text(l10n.roomStatusMaintenance)),
                      ],
                      onChanged: (v) {
                        if (v != null) selectedInitialStatus = v;
                      },
                    ),
                  ],
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
                  final newRoom = Room(
                    id: room?.id ?? '',
                    numero: noController.text,
                    idTypeDeChambre: selectedTypeId ?? '',
                    type: roomTypes.firstWhere((t) => t.id == selectedTypeId, orElse: () => roomTypes.first).nom,
                    etage: int.tryParse(floorController.text) ?? 1,
                    statutMenage: room?.statutMenage ?? selectedInitialStatus,
                    estActive: room?.estActive ?? 1,
                    occupee: room?.occupee ?? 0,
                  );

                  if (room == null) {
                    context.read<RoomBloc>().add(CreateRoomEvent(newRoom));
                  } else {
                    context.read<RoomBloc>().add(UpdateRoomEvent(newRoom));
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
