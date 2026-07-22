import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/empty_state_view.dart';
import 'package:sra_hotel/core/widgets/error_state_view.dart';
import 'package:sra_hotel/core/widgets/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/media_uploader_box.dart';
import 'package:sra_hotel/core/widgets/responsive_list_grid_view.dart';
import 'package:sra_hotel/core/widgets/sra_button.dart';
import 'package:sra_hotel/core/widgets/sra_input.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room_type.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_bloc.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_event.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';
import 'package:sra_hotel/core/widgets/confirm_delete_dialog.dart';

class AdminRoomTypesView extends StatelessWidget {
  const AdminRoomTypesView({super.key});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.roomTypesTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
              Expanded(
                child: state.roomTypes.isEmpty
                    ? const EmptyStateView(
                        icon: Icons.list_alt_outlined,
                      )
                    : ResponsiveListGridView(
                        itemCount: state.roomTypes.length,
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                        maxCrossAxisExtent: 450,
                        mainAxisExtent: 120,
                        itemBuilder: (context, index) {
                          final type = state.roomTypes[index];

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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  type.nom,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppDimensions.spacingXs / 2),
                                Text(
                                  _formatCurrency(type.prixNuit),
                                  style: const TextStyle(color: AppColors.champagneGold, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  '${l10n.capacityLabel} : ${type.capacite}',
                                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.statusInfo),
                                onPressed: () => _showRoomTypeFormDialog(context, type),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.statusError),
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
