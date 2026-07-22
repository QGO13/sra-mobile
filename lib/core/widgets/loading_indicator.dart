import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;

  const LoadingIndicator({
    super.key,
    this.color = AppColors.champagneGold,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

