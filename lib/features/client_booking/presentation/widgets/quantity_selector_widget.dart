import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class QuantitySelectorWidget extends StatefulWidget {
  final BookingRoomType roomType;
  final DateTime checkIn;
  final DateTime checkOut;
  final int maxQuantity;
  final Function(int quantity) onConfirm;
  final VoidCallback onCancel;

  const QuantitySelectorWidget({
    super.key,
    required this.roomType,
    required this.checkIn,
    required this.checkOut,
    required this.maxQuantity,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<QuantitySelectorWidget> createState() => _QuantitySelectorWidgetState();
}

class _QuantitySelectorWidgetState extends State<QuantitySelectorWidget> {
  int _selectedQuantity = 1;

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final nights = widget.checkOut.difference(widget.checkIn).inDays;
    final totalCost = _selectedQuantity * widget.roomType.prixNuit * (nights > 0 ? nights : 1);

    final dateRangeStr = "${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(widget.checkIn)} ${l10n.toLabel} ${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(widget.checkOut)} (${l10n.nightsCount(nights)})";

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
                  l10n.quantityChoiceTitle,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: isDark ? Colors.white : AppColors.imperialNightBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLg),
 
          // Details summary
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingMd),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey.withValues(alpha: 0.5)),
              color: isDark ? AppColors.imperialNightBlue : AppColors.ecruWhite,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.roomType.nom,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.imperialNightBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateRangeStr,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  "${l10n.unitPriceLabel} : ${_formatCurrency(widget.roomType.prixNuit)} / ${l10n.nightLabel}",
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.champagneGold),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          Text(
            l10n.roomsQuantityToBook,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            l10n.availableRoomsCount(widget.maxQuantity),
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingMd),

          // Quantity controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 36, color: AppColors.champagneGold),
                onPressed: _selectedQuantity > 1
                    ? () => setState(() => _selectedQuantity--)
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                child: Text(
                  _selectedQuantity.toString(),
                  style: AppTextStyles.displayLarge.copyWith(color: AppColors.champagneGold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 36, color: AppColors.champagneGold),
                onPressed: _selectedQuantity < widget.maxQuantity
                    ? () => setState(() => _selectedQuantity++)
                    : null,
              ),
            ],
          ),
          
          const Divider(height: AppDimensions.spacingXl, thickness: 0.5, color: Colors.black12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.estimatedTotal.toUpperCase(),
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                _formatCurrency(totalCost.toDouble()),
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.champagneGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          SraButton(
            onPressed: () {
              widget.onConfirm(_selectedQuantity);
            },
            label: l10n.addToCart,
          ),
        ],
      ),
    );
  }
}
