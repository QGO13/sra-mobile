import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

enum SraPriceSize { small, medium, large }

/// Tag de prix SRA Hotel — typographie Playfair Display avec formatage automatique.
class SraPriceTag extends StatelessWidget {
  final double amount;
  final String currency;
  final String? period;
  final SraPriceSize size;
  final Color? color;

  const SraPriceTag({
    super.key,
    required this.amount,
    this.currency = 'FCFA',
    this.period = '/ nuit',
    this.size = SraPriceSize.medium,
    this.color,
  });

  const SraPriceTag.small({
    Key? key,
    required double amount,
    String currency = 'FCFA',
    String? period,
    Color? color,
  }) : this(
          key: key,
          amount: amount,
          currency: currency,
          period: period,
          size: SraPriceSize.small,
          color: color,
        );

  const SraPriceTag.large({
    Key? key,
    required double amount,
    String currency = 'FCFA',
    String? period = '/ nuit',
    Color? color,
  }) : this(
          key: key,
          amount: amount,
          currency: currency,
          period: period,
          size: SraPriceSize.large,
          color: color,
        );

  String get _formattedAmount {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = color ?? (isDark ? AppColors.gold : AppColors.ink);

    TextStyle priceStyle;
    TextStyle suffixStyle;

    switch (size) {
      case SraPriceSize.small:
        priceStyle = AppTextStyles.priceSmall.copyWith(color: textColor);
        suffixStyle = AppTextStyles.bodySmall.copyWith(color: AppColors.inkMuted);
        break;
      case SraPriceSize.medium:
        priceStyle = AppTextStyles.priceMedium.copyWith(color: textColor);
        suffixStyle = AppTextStyles.bodyMedium.copyWith(color: AppColors.inkMuted);
        break;
      case SraPriceSize.large:
        priceStyle = AppTextStyles.priceLarge.copyWith(color: textColor);
        suffixStyle = AppTextStyles.bodyMedium.copyWith(color: AppColors.inkMuted);
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(_formattedAmount, style: priceStyle),
        const SizedBox(width: AppDimensions.spacingXs),
        Text(currency, style: priceStyle.copyWith(fontSize: priceStyle.fontSize! * 0.7)),
        if (period != null) ...[
          const SizedBox(width: AppDimensions.spacingXs),
          Text(period!, style: suffixStyle),
        ],
      ],
    );
  }
}
