import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
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

  String _getRoomTypeImageUrl(RoomType type) {
    if (type.images.isNotEmpty && type.images.first.startsWith('http')) {
      return type.images.first;
    }
    final nameLower = type.nom.toLowerCase();
    if (nameLower.contains('suite')) {
      return 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80';
    } else if (nameLower.contains('prem') || nameLower.contains('sup')) {
      return 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800&q=80';
    } else {
      return 'https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800&q=80';
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
                        _buildKpiChip(l10n.roomTypesTitle, "$totalTypes", Icons.category_outlined, AppColors.champagneGold, isDark, itemWidth),
                        _buildKpiChip(l10n.avgPricePerNight, _formatCurrency(avgPrice), Icons.payments_outlined, AppColors.statusSuccess, isDark, itemWidth),
                        _buildKpiChip(l10n.totalCapacity, "$totalCap pers.", Icons.groups_outlined, AppColors.statusInfo, isDark, itemWidth),
                        _buildKpiChip(l10n.totalRooms, "$totalRoomsConfigured ch.", Icons.meeting_room_outlined, AppColors.champagneGold, isDark, itemWidth),
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
                        onPressed: () => _showRoomTypeFormDialog(context, null),
                        icon: Icons.add,
                        label: l10n.typeLabel,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // ── Liste / Grille des Typologies ──
              Expanded(
                child: filteredTypes.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.list_alt_outlined,
                      )
                    : ResponsiveListGridView(
                        itemCount: filteredTypes.length,
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                        maxCrossAxisExtent: 550,
                        mainAxisExtent: 220,
                        itemBuilder: (context, index) {
                          final type = filteredTypes[index];
                          final associatedRoomsCount = state.rooms.where((r) => r.idTypeDeChambre == type.id || r.type.toLowerCase() == type.nom.toLowerCase()).length;

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
                            child: Padding(
                              padding: const EdgeInsets.all(AppDimensions.spacingSm + 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Image Vignette
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                                        child: CachedNetworkImage(
                                          imageUrl: _getRoomTypeImageUrl(type),
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            width: 90,
                                            height: 90,
                                            color: isDark ? AppColors.darkSurface : AppColors.fog,
                                            child: const Center(
                                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.champagneGold),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            width: 90,
                                            height: 90,
                                            color: isDark ? AppColors.darkSurface : AppColors.fog,
                                            child: const Icon(Icons.hotel, color: AppColors.champagneGold, size: 28),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppDimensions.spacingSm + 4),

                                      // Contenu Détails
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    type.nom,
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  _formatCurrency(type.prixNuit),
                                                  style: const TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.bold, fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.champagneGold.withValues(alpha: 0.12),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    "${l10n.capacityLabel}: ${type.capacite} pers.",
                                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.champagneGold),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.statusInfo.withValues(alpha: 0.12),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    "$associatedRoomsCount ${l10n.associatedRooms}",
                                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.statusInfo),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              type.description.isNotEmpty ? type.description : l10n.noDescription,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Divider(height: 12),

                                  // Actions & Équipements
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Wrap(
                                        spacing: 4,
                                        children: [
                                          Icon(Icons.wifi, size: 14, color: AppColors.textMuted),
                                          Icon(Icons.ac_unit, size: 14, color: AppColors.textMuted),
                                          Icon(Icons.tv, size: 14, color: AppColors.textMuted),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit_outlined, color: AppColors.statusInfo, size: 20),
                                            onPressed: () => _showRoomTypeFormDialog(context, type),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: AppColors.statusError, size: 20),
                                            onPressed: () async {
                                              final roomBloc = context.read<RoomBloc>();
                                              final confirmed = await ConfirmDeleteDialog.show(
                                                context,
                                                title: l10n.deleteRoomTypeTitle,
                                                message: l10n.deleteRoomTypeMessage,
                                                confirmLabel: l10n.deleteLabel,
                                                cancelLabel: l10n.cancelLabel,
                                                isDestructive: true,
                                              );
                                              if (confirmed) {
                                                roomBloc.add(DeleteRoomTypeEvent(type.id));
                                              }
                                            },
                                          ),
                                        ],
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
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

  void _showRoomTypeFormDialog(BuildContext context, RoomType? type) {
    final roomBloc = context.read<RoomBloc>();
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: type?.nom ?? '');
    final priceController = TextEditingController(text: type?.prixNuit.toString() ?? '');
    final capController = TextEditingController(text: type?.capacite.toString() ?? '');
    final descController = TextEditingController(text: type?.description ?? '');
    final initialImageUrl = type != null && type.images.isNotEmpty ? type.images.first : null;
    XFile? pickedFile;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
              title: Text(
                type == null ? l10n.addTypology : l10n.editTypology,
                style: AppTextStyles.titleLarge.copyWith(color: AppColors.champagneGold),
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SraInput(
                          controller: nameController,
                          label: l10n.typologyNameLabel,
                          placeholder: "e.g. Standard",
                          validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        SraInput(
                          controller: priceController,
                          label: l10n.pricePerNightLabel,
                          placeholder: "e.g. 50000",
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        SraInput(
                          controller: capController,
                          label: l10n.capacityLabel,
                          placeholder: "e.g. 2",
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
                        MediaUploaderBox(
                          initialImageUrl: initialImageUrl,
                          onFileSelected: (file) {
                            setState(() {
                              pickedFile = file;
                            });
                          },
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
                    if (formKey.currentState!.validate()) {
                      final t = RoomType(
                        id: type?.id ?? '',
                        nom: nameController.text,
                        prixNuit: double.parse(priceController.text),
                        capacite: int.parse(capController.text),
                        description: descController.text,
                        images: initialImageUrl != null ? [initialImageUrl] : const [],
                      );
                      if (type == null) {
                        roomBloc.add(CreateRoomTypeEvent(t, imageFile: pickedFile));
                      } else {
                        roomBloc.add(UpdateRoomTypeEvent(t, imageFile: pickedFile));
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
