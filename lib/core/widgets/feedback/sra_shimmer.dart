import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Chargement squelette animé (Shimmer) SRA Hotel.
class SraShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SraShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppDimensions.radiusSm,
  });

  const SraShimmer.card({
    Key? key,
    double width = double.infinity,
    double height = AppDimensions.responsiveCardMainExtent,
  }) : this(
          key: key,
          width: width,
          height: height,
          borderRadius: AppDimensions.radiusLg,
        );

  const SraShimmer.line({
    Key? key,
    double width = double.infinity,
    double height = AppDimensions.iconSizeSm,
  }) : this(
          key: key,
          width: width,
          height: height,
          borderRadius: AppDimensions.radiusXs,
        );

  @override
  State<SraShimmer> createState() => _SraShimmerState();
}

class _SraShimmerState extends State<SraShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkElevated : AppColors.mist;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
