import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/empty_state_view.dart';
import 'package:sra_hotel/core/widgets/error_state_view.dart';
import 'package:sra_hotel/core/widgets/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/responsive_list_grid_view.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/core/widgets/sra_input.dart';
import 'package:sra_hotel/core/widgets/sra_dropdown.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        if (state is RoomLoading || state is RoomInitial) {
          return const Center(child: LoadingIndicator(color: AppColors.champagneGold));
        } else if (state is RoomFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<RoomBloc>().add(LoadRoomsAndTypesEvent()),
          );
        } else if (state is RoomLoaded) {
          final filteredRooms = state.rooms.where((room) {
            return room.numero.contains(_searchQuery) ||
                room.type.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
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
                    const SizedBox(width: AppDimensions.spacingSm + 4),
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
              Expanded(
                child: filteredRooms.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.meeting_room_outlined,
                      )
                    : ResponsiveListGridView(
                        itemCount: filteredRooms.length,
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                        maxCrossAxisExtent: 450,
                        mainAxisExtent: 110,
                        itemBuilder: (context, index) {
                          final room = filteredRooms[index];
                          final isOccupied = room.occupee == 1;

                          Color statusColor = AppColors.statusSuccess;
                          if (room.estActive == 0) {
                            statusColor = AppColors.textMuted;
                          } else if (isOccupied) {
                            statusColor = AppColors.champagneGold;
                          } else if (room.statutMenage == 'SALE') {
                            statusColor = AppColors.statusError;
                          }

                          String localizedMenage = room.statutMenage;
                          if (room.statutMenage == 'PROPRE') localizedMenage = l10n.cleanStatus;
                          if (room.statutMenage == 'SALE') localizedMenage = l10n.dirtyStatus;
                          if (room.statutMenage == 'EN_COURS') localizedMenage = l10n.cleaningStatus;

                          return Container(
                            margin: MediaQuery.of(context).size.width < AppDimensions.breakpointMd
                                ? const EdgeInsets.only(bottom: AppDimensions.spacingSm + 2)
                                : EdgeInsets.zero,
                            padding: const EdgeInsets.all(AppDimensions.spacingSm + 4),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.deepBlue : AppColors.surfaceLight,
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
                                  "${l10n.room} ${room.numero}",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppDimensions.spacingXs / 2),
                                Text(
                                  "${room.type} • ${l10n.floorLabel} ${room.etage}",
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppDimensions.spacingXs),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: AppDimensions.spacingSm - 2),
                                    Expanded(
                                      child: Text(
                                        room.estActive == 0
                                            ? l10n.horsService
                                            : (isOccupied ? l10n.occupee : "${l10n.libre} ($localizedMenage)"),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                onPressed: () => _showRoomFormDialog(context, room, state.roomTypes),
                              ),
                              Switch(
                                value: room.estActive == 1,
                                activeTrackColor: AppColors.champagneGold,
                                onChanged: (val) {
                                  final updated = Room(
                                    id: room.id,
                                    numero: room.numero,
                                    idTypeDeChambre: room.idTypeDeChambre,
                                    type: room.type,
                                    etage: room.etage,
                                    statutMenage: room.statutMenage,
                                    estActive: val ? 1 : 0,
                                    occupee: room.occupee,
                                    clientActuel: room.clientActuel,
                                  );
                                  context.read<RoomBloc>().add(UpdateRoomEvent(updated));
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

  void _showRoomFormDialog(BuildContext context, Room? room, List<RoomType> roomTypes) {
    final formKey = GlobalKey<FormState>();
    final noController = TextEditingController(text: room?.numero ?? '');
    final floorController = TextEditingController(text: room?.etage.toString() ?? '');
    String? selectedTypeId = room?.idTypeDeChambre ?? (roomTypes.isNotEmpty ? roomTypes.first.id : null);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
          title: Text(
            room == null ? l10n.addRoom : l10n.editRoom,
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.champagneGold),
          ),
          content: Form(
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
                    if (val != null) selectedTypeId = val;
                  },
                ),
              ],
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
                    statutMenage: room?.statutMenage ?? "PROPRE",
                    estActive: room?.estActive ?? 1,
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
  }
}
