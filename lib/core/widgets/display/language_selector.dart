import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

/// Sélecteur de langue 6 langues SRA Hotel (FR, EN, ES, AR, DE, ZH).
class LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  const LanguageSelector({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButton<Locale>(
      value: currentLocale,
      dropdownColor: isDark ? AppColors.darkCard : AppColors.white,
      icon: const Icon(Icons.language_rounded, color: AppColors.gold),
      underline: const SizedBox.shrink(),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          onLocaleChanged(newLocale);
        }
      },
      items: [
        DropdownMenuItem(
          value: const Locale('fr'),
          child: Text('Français', style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.white : AppColors.ink)),
        ),
        DropdownMenuItem(
          value: const Locale('en'),
          child: Text('English', style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.white : AppColors.ink)),
        ),
        DropdownMenuItem(
          value: const Locale('es'),
          child: Text('Español', style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.white : AppColors.ink)),
        ),
        DropdownMenuItem(
          value: const Locale('ar'),
          child: Text('العربية', style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.white : AppColors.ink)),
        ),
        DropdownMenuItem(
          value: const Locale('de'),
          child: Text('Deutsch', style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.white : AppColors.ink)),
        ),
        DropdownMenuItem(
          value: const Locale('zh'),
          child: Text('中文', style: AppTextStyles.bodyMedium.copyWith(color: isDark ? AppColors.white : AppColors.ink)),
        ),
      ],
    );
  }
}
