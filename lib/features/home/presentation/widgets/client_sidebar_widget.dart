import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

class ClientSidebarItem {
  final Widget icon;
  final Widget selectedIcon;
  final String label;

  const ClientSidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class ClientSidebarWidget extends StatelessWidget {
  final bool isExtended;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onToggleExtend;
  final List<ClientSidebarItem> items;
  final ClientSidebarItem? footerItem;
  final VoidCallback? onFooterSelected;

  const ClientSidebarWidget({
    super.key,
    required this.isExtended,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onToggleExtend,
    required this.items,
    this.footerItem,
    this.onFooterSelected,
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
          // ── Header Toggle Button ──
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

          // ── Liste des items principaux ──
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 3.0),
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
                            isSelected ? item.selectedIcon : item.icon,
                            if (isExtended) ...[
                              const SizedBox(width: AppDimensions.spacingSm + 4),
                              Expanded(
                                child: Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5,
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

          // ── Item d'Ancrage Bas (Paramètres) ──
          if (footerItem != null)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingSm),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm + 2),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm + 2),
                  onTap: onFooterSelected,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: isExtended ? AppDimensions.spacingSm + 4 : 12.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: selectedIndex == 3
                          ? AppColors.champagneGold.withValues(alpha: isDark ? 0.18 : 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm + 2),
                      border: Border.all(
                        color: selectedIndex == 3
                            ? AppColors.champagneGold
                            : (isDark ? Colors.white10 : AppColors.softGrey),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
                      children: [
                        selectedIndex == 3 ? footerItem!.selectedIcon : footerItem!.icon,
                        if (isExtended) ...[
                          const SizedBox(width: AppDimensions.spacingSm + 4),
                          Expanded(
                            child: Text(
                              footerItem!.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: selectedIndex == 3 ? FontWeight.bold : FontWeight.w500,
                                color: selectedIndex == 3
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
            ),
        ],
      ),
    );
  }
}
