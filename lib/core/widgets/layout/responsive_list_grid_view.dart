import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class ResponsiveListGridView extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsetsGeometry padding;
  final Widget? emptyChild;
  final double breakpoint;
  final double maxCrossAxisExtent;
  final double mainAxisExtent;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveListGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding = EdgeInsets.zero,
    this.emptyChild,
    this.breakpoint = AppDimensions.breakpointMd,
    this.maxCrossAxisExtent = AppDimensions.responsiveCardMaxExtent,
    this.mainAxisExtent = AppDimensions.responsiveCardMainExtent,
    this.crossAxisSpacing = AppDimensions.spacingMd,
    this.mainAxisSpacing = AppDimensions.spacingMd,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return emptyChild ?? const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return ListView.builder(
            padding: padding,
            shrinkWrap: shrinkWrap,
            physics: physics,
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          );
        }

        return GridView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxCrossAxisExtent,
            mainAxisExtent: mainAxisExtent,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}