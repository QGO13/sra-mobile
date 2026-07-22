import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';

class DateSelectorWidget extends StatefulWidget {
  final BookingRoomType roomType;
  final Function(DateTime checkIn, DateTime checkOut) onDatesSelected;
  final VoidCallback onCancel;

  const DateSelectorWidget({
    super.key,
    required this.roomType,
    required this.onDatesSelected,
    required this.onCancel,
  });

  @override
  State<DateSelectorWidget> createState() => _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  DateTime _checkIn = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 2));

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkIn, end: _checkOut),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.champagneGold,
              onPrimary: AppColors.imperialNightBlue,
              surface: isDark ? AppColors.imperialNightBlue : AppColors.surfaceLight,
              onSurface: isDark ? AppColors.ecruWhite : AppColors.imperialNightBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkIn = picked.start;
        _checkOut = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.champagneGold),
                onPressed: widget.onCancel,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  "${l10n.chooseDatesTitle} - ${widget.roomType.nom}",
                  style: AppTextStyles.titleLarge.copyWith(
                    color: isDark ? Colors.white : AppColors.imperialNightBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          
          InkWell(
            onTap: _selectDateRange,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                color: isDark ? AppColors.imperialNightBlue : AppColors.ecruWhite,
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range_outlined, color: AppColors.champagneGold, size: 24),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.periodOfStay.toUpperCase(),
                          style: AppTextStyles.labelUppercase.copyWith(fontSize: 9),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${DateFormat('dd MMM yyyy', Localizations.localeOf(context).toString()).format(_checkIn)}  ➔  ${DateFormat('dd MMM yyyy', Localizations.localeOf(context).toString()).format(_checkOut)}",
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_outlined, size: 18, color: AppColors.champagneGold),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingXl),
          
          SraButton(
            onPressed: () {
              widget.onDatesSelected(_checkIn, _checkOut);
            },
            label: l10n.verifyAvailability,
          ),
        ],
      ),
    );
  }
}
