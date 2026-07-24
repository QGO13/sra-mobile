import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
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
  bool _isTableView = false;
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
          return const LoadingWidget();
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
                        _buildKpiChip(l10n.totalRooms, "$totalRooms", Icons.hotel, AppColors.champagneGold, isDark, itemWidth),
                        _buildKpiChip(l10n.libre, "$freeRooms", Icons.check_circle_outline, AppColors.statusSuccess, isDark, itemWidth),
                        _buildKpiChip(l10n.occupee, "$occupiedRooms", Icons.person_outline, AppColors.statusInfo, isDark, itemWidth),
                        _buildKpiChip(l10n.roomStatusToClean, "$toCleanRooms", Icons.cleaning_services_outlined, AppColors.statusWarning, isDark, itemWidth),
                        _buildKpiChip(l10n.occupancyRateLabel, "$occRate%", Icons.bar_chart, AppColors.champagneGold, isDark, itemWidth),
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
                    const SizedBox(width: AppDimensions.spacingSm),
                    // Bouton bascule Grille / Tableau
                    IconButton(
                      tooltip: _isTableView ? l10n.viewModeGrid : l10n.viewModeTable,
                      icon: Icon(_isTableView ? Icons.grid_view : Icons.table_chart_outlined, color: AppColors.champagneGold),
                      onPressed: () {
                        setState(() {
                          _isTableView = !_isTableView;
                        });
                      },
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

              // ── Vue Contenu (Grille ou Tableau) ──
              Expanded(
                child: filteredRooms.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.meeting_room_outlined,
                      )
                    : _isTableView
                        ? _buildTableView(filteredRooms, state.roomTypes, isDark, l10n)
                        : ResponsiveListGridView(
                            itemCount: filteredRooms.length,
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                            maxCrossAxisExtent: 460,
                            mainAxisExtent: 155,
                            itemBuilder: (context, index) {
                              final room = filteredRooms[index];
                              return _buildRoomCard(room, state.roomTypes, isDark, l10n);
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

  Widget _buildKpiChip(String label, String value, IconData icon, Color color, bool isDark, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm + 2, vertical: AppDimensions.spacingSm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Room room, List<RoomType> roomTypes, bool isDark, AppLocalizations l10n) {
    final isOccupied = room.occupee == 1;

    SraStatusType statusType = SraStatusType.success;
    Color? statusCustomColor;
    String statusLabel;
    if (room.estActive == 0) {
      statusType = SraStatusType.custom;
      statusCustomColor = AppColors.textMuted;
      statusLabel = l10n.horsService;
    } else if (isOccupied) {
      statusType = SraStatusType.info;
      statusLabel = l10n.occupee;
    } else if (room.statutMenage == 'MAINTENANCE') {
      statusType = SraStatusType.error;
      statusLabel = l10n.dirtyStatus;
    } else if (room.statutMenage == 'SALE' || room.statutMenage == 'A_NETTOYER') {
      statusType = SraStatusType.warning;
      statusLabel = l10n.dirtyStatus;
    } else if (room.statutMenage == 'EN_COURS') {
      statusType = SraStatusType.warning;
      statusLabel = l10n.cleaningStatus;
    } else {
      statusType = SraStatusType.success;
      statusLabel = l10n.libre;
    }

    final isPremiumType = room.type.toLowerCase().contains('suite') || room.type.toLowerCase().contains('prem');

    return Container(
      margin: MediaQuery.of(context).size.width < AppDimensions.breakpointMd
          ? const EdgeInsets.only(bottom: AppDimensions.spacingSm + 2)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        onTap: () => _showRoomFormDialog(context, room, roomTypes),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingSm + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header: Numéro + Étage + Bouton d'édition unifié
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.champagneGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                          ),
                          child: Text(
                            "CH. ${room.numero}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.champagneGold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${l10n.floorLabel} ${room.etage}",
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_outlined, color: AppColors.statusInfo, size: 20),
                ],
              ),

              // Occupant actuel le cas échéant
              if (room.clientActuel != null && room.clientActuel!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 13, color: AppColors.statusInfo),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          room.clientActuel!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.statusInfo),
                        ),
                      ),
                    ],
                  ),
                ),

              // Footer avec Pastille Typologie + Pastille Statut (Sans débordement)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  SraStatusBadge.custom(
                    label: room.type,
                    color: isPremiumType ? AppColors.gold : AppColors.inkMuted,
                    dot: false,
                    small: true,
                  ),
                  SraStatusBadge(
                    label: statusLabel,
                    type: statusType,
                    customColor: statusCustomColor,
                    dot: true,
                    small: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableView(List<Room> rooms, List<RoomType> roomTypes, bool isDark, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.deepBlue : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        ),
        child: DataTable(
          columns: [
            DataColumn(label: Text(l10n.roomNumberLabel, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(l10n.typeLabel, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(l10n.floorLabel, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(l10n.statusLabel, style: const TextStyle(fontWeight: FontWeight.bold))),
            const DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: rooms.map((room) {
            return DataRow(
              cells: [
                DataCell(Text(room.numero, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(room.type)),
                DataCell(Text("${room.etage}")),
                DataCell(Text(room.occupee == 1 ? l10n.occupee : room.statutMenage)),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.statusInfo),
                    onPressed: () => _showRoomFormDialog(context, room, roomTypes),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showRoomFormDialog(BuildContext context, Room? room, List<RoomType> roomTypes) {
    final formKey = GlobalKey<FormState>();
    final noController = TextEditingController(text: room?.numero ?? '');
    final floorController = TextEditingController(text: room?.etage.toString() ?? '');
    String? selectedTypeId = room?.idTypeDeChambre ?? (roomTypes.isNotEmpty ? roomTypes.first.id : null);
    String selectedStatus = room?.statutMenage ?? 'PROPRE';
    bool isActiveState = room?.estActive == 1;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
              title: Text(
                room == null ? l10n.addRoom : l10n.editRoom,
                style: AppTextStyles.titleLarge.copyWith(color: AppColors.champagneGold),
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SraInput(
                          controller: noController,
                          label: l10n.roomNumberLabel,
                          placeholder: "e.g. 101",
                          validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        SraInput(
                          controller: floorController,
                          label: l10n.floorLabel,
                          placeholder: "e.g. 1",
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        SraDropdown(
                          value: selectedTypeId,
                          label: l10n.typeLabel,
                          placeholder: l10n.selectOption,
                          items: roomTypes.map((type) => type.id).toList(),
                          itemLabels: Map.fromEntries(roomTypes.map((type) => MapEntry(type.id, type.nom))),
                          onChanged: (val) {
                            if (val != null) {
                              setStateModal(() {
                                selectedTypeId = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        SraDropdown(
                          value: selectedStatus,
                          label: "Statut de propreté / maintenance",
                          placeholder: l10n.selectOption,
                          items: const ['PROPRE', 'SALE', 'EN_COURS', 'MAINTENANCE'],
                          itemLabels: {
                            'PROPRE': l10n.cleanStatus,
                            'SALE': l10n.dirtyStatus,
                            'EN_COURS': l10n.cleaningStatus,
                            'MAINTENANCE': l10n.maintenanceStatus,
                          },
                          onChanged: (val) {
                            if (val != null) {
                              setStateModal(() {
                                selectedStatus = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        // Interrupteur d'activation / désactivation dans la modale
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Activer la chambre",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.white : AppColors.ink,
                              ),
                            ),
                            Switch(
                              value: isActiveState,
                              activeTrackColor: AppColors.champagneGold,
                              onChanged: (val) {
                                setStateModal(() {
                                  isActiveState = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
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
                    if (formKey.currentState!.validate() && selectedTypeId != null) {
                      final typ = roomTypes.firstWhere((t) => t.id == selectedTypeId);
                      final r = Room(
                        id: room?.id ?? '',
                        numero: noController.text,
                        idTypeDeChambre: selectedTypeId!,
                        type: typ.nom,
                        etage: int.parse(floorController.text),
                        statutMenage: selectedStatus,
                        estActive: isActiveState ? 1 : 0,
                        occupee: room?.occupee ?? 0,
                        clientActuel: room?.clientActuel,
                      );
                      if (room == null) {
                        context.read<RoomBloc>().add(CreateRoomEvent(r));
                      } else {
                        context.read<RoomBloc>().add(UpdateRoomEvent(r));
                      }
                      Navigator.of(ctx).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
