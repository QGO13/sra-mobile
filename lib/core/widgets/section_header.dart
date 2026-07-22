import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Section header with a gold uppercase title, an optional muted subtitle,
/// an optional trailing action widget, and a fine divider below.
///
/// Usage:
/// ```dart
/// SectionHeader(
///   title: 'Chambres disponibles',
///   subtitle: '12 résultats',
///   action: TextButton(onPressed: _seeAll, child: const Text('Voir tout')),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// Primary label rendered in [AppTextStyles.labelUppercase] (champagneGold).
  final String title;

  /// Optional secondary label rendered below the title in [AppTextStyles.labelMuted].
  final String? subtitle;

  /// Optional trailing widget (e.g. a `TextButton` or `IconButton`).
  final Widget? action;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Title row ───────────────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left block: title + optional subtitle
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelUppercase,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      subtitle!,
                      style: AppTextStyles.labelMuted,
                    ),
                  ],
                ],
              ),
            ),
            // Right block: optional action
            ?action,
          ],
        ),
        // ── Divider ─────────────────────────────────────────────────────
        SizedBox(height: AppDimensions.spacingSm),
        const Divider(
          color: AppColors.softGrey,
          thickness: AppDimensions.borderThin,
          height: AppDimensions.borderThin,
        ),
      ],
    );
  }
}
