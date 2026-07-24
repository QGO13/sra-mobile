import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class AdminSidebarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const AdminSidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class AdminSidebarWidget extends StatelessWidget {
  final bool isExtended;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onToggleExtend;
  final List<AdminSidebarItem> items;

  const AdminSidebarWidget({
    super.key,
    required this.isExtended,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onToggleExtend,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.imperialNightBlue : AppColors.surfaceLight;
    final borderColor = isDark ? Colors.white10 : AppColors.softGrey;

    final sidebarWidth = isExtended ? 230.0 : 72.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          right: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      child: Column(
        children: [
          // ── Toggle Icon Button Header ──
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isExtended ? AppDimensions.spacingMd : 12.0,
              vertical: AppDimensions.spacingSm + 4,
            ),
            child: Row(
              mainAxisAlignment: isExtended ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              children: [
                if (isExtended)
                  IconButton(
                    tooltip: "Réduire le menu",
                    icon: const Icon(Icons.menu_open_outlined, color: AppColors.champagneGold, size: 22),
                    onPressed: onToggleExtend,
                  )
                else
                  IconButton(
                    tooltip: "Agrandir le menu",
                    icon: const Icon(Icons.menu_outlined, color: AppColors.champagneGold, size: 22),
                    onPressed: onToggleExtend,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),

          // ── Navigation Items List ──
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm + 2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm + 2),
                      onTap: () => onItemSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: EdgeInsets.symmetric(
                          horizontal: isExtended ? AppDimensions.spacingSm + 4 : 12.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.champagneGold.withValues(alpha: isDark ? 0.18 : 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusSm + 2),
                        ),
                        child: Row(
                          mainAxisAlignment: isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSelected ? item.selectedIcon : item.icon,
                              size: 20,
                              color: isSelected
                                  ? AppColors.champagneGold
                                  : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
                            ),
                            if (isExtended) ...[
                              const SizedBox(width: AppDimensions.spacingSm + 4),
                              Expanded(
                                child: Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.champagneGold
                                        : (isDark ? AppColors.darkTextSecondary : AppColors.ink),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
