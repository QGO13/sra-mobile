import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Indicateur de chargement SRA — spinner doré centré.
/// Préférer [LoadingWidget] qui offre plus d'options.
class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator({
    super.key,
    this.color = AppColors.gold,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: AppDimensions.iconSizeXl,
        height: AppDimensions.iconSizeXl,
        child: CircularProgressIndicator(
          strokeWidth: AppDimensions.borderThick,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: color.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}
