import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class DemoAccount {
  final String role;
  final String email;
  final String password;

  const DemoAccount({
    required this.role,
    required this.email,
    required this.password,
  });
}

class DemoAccountsBanner extends StatefulWidget {
  final Function(String email, String password) onSelect;

  const DemoAccountsBanner({
    super.key,
    required this.onSelect,
  });

  @override
  State<DemoAccountsBanner> createState() => _DemoAccountsBannerState();
}

class _DemoAccountsBannerState extends State<DemoAccountsBanner> {
  bool _isExpanded = false;

  final List<DemoAccount> _accounts = const [
    DemoAccount(role: 'Client', email: 'client@sra-hotel.com', password: 'Client2024!'),
    DemoAccount(role: 'Administrateur', email: 'admin@sra-hotel.com', password: 'Admin2024!'),
    DemoAccount(role: 'Réception', email: 'reception@sra-hotel.com', password: 'Reception2024!'),
    DemoAccount(role: 'Ménage', email: 'menage@sra-hotel.com', password: 'Menage2024!'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: isDark ? 0.4 : 0.3),
          width: AppDimensions.borderThin,
        ),
      ),
      child: Column(
        children: [
          // Header Toggle button
          InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMd,
                vertical: AppDimensions.spacingSm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.gold,
                        size: AppDimensions.iconSizeSm,
                      ),
                      AppDimensions.hGapSm,
                      Text(
                        "COMPTES DE DÉMONSTRATION",
                        style: AppTextStyles.labelUppercase,
                      ),
                    ],
                  ),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.gold,
                    size: AppDimensions.iconSizeSm,
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded contents
          if (_isExpanded) ...[
            Container(
              padding: AppDimensions.paddingSmAll,
              color: isDark ? AppColors.darkElevated : AppColors.white24,
              child: Column(
                children: _accounts.map((acc) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
                    child: InkWell(
                      onTap: () => widget.onSelect(acc.email, acc.password),
                      child: Container(
                        padding: AppDimensions.paddingSmAll,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.mist,
                            width: AppDimensions.borderThin,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  acc.role,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.white : AppColors.ink,
                                  ),
                                ),
                                AppDimensions.vGapXs,
                                Text(
                                  acc.email,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              acc.password,
                              style: AppTextStyles.monospace.copyWith(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
