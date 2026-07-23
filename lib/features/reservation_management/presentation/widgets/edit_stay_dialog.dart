import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Dialogue de Modification de Séjour — Reproduction Pixel-Perfect de `MyStayPage.tsx`.
class EditStayDialog extends StatefulWidget {
  final String currentCheckIn;
  final String currentCheckOut;
  final ValueChanged<String> onSendRequest;

  const EditStayDialog({
    super.key,
    required this.currentCheckIn,
    required this.currentCheckOut,
    required this.onSendRequest,
  });

  @override
  State<EditStayDialog> createState() => _EditStayDialogState();
}

class _EditStayDialogState extends State<EditStayDialog> {
  late final TextEditingController _checkInController;
  late final TextEditingController _checkOutController;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkInController = TextEditingController(text: widget.currentCheckIn);
    _checkOutController = TextEditingController(text: widget.currentCheckOut);
  }

  @override
  void dispose() {
    _checkInController.dispose();
    _checkOutController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
      title: Text(
        l10n.editStayDialogTitle,
        style: AppTextStyles.titleMedium.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppColors.imperialNightBlue,
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.editStayNotice,
                style: AppTextStyles.bodySmall.copyWith(
                  color: textMuted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              SraInput(
                controller: _checkInController,
                label: l10n.desiredCheckIn,
                placeholder: "YYYY-MM-DD",
                prefixIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.champagneGold, size: 18),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              SraInput(
                controller: _checkOutController,
                label: l10n.desiredCheckOut,
                placeholder: "YYYY-MM-DD",
                prefixIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.champagneGold, size: 18),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              SraInput(
                controller: _messageController,
                label: l10n.messageToReception,
                placeholder: l10n.messageToReceptionPlaceholder,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancelLabel,
            style: const TextStyle(color: AppColors.champagneGold),
          ),
        ),
        SraButton(
          label: l10n.sendRequest,
          onPressed: () {
            widget.onSendRequest(_messageController.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
