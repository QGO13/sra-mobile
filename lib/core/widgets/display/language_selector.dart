import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';

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
    return DropdownButton<Locale>(
      value: currentLocale,
      dropdownColor: AppColors.imperialNightBlue,
      icon: const Icon(Icons.language, color: AppColors.champagneGold),
      underline: const SizedBox(),
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          onLocaleChanged(newLocale);
        }
      },
      items: const [
        DropdownMenuItem(
          value: Locale('fr'),
          child: Text('Français', style: TextStyle(color: AppColors.white)),
        ),
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English', style: TextStyle(color: AppColors.white)),
        ),
        DropdownMenuItem(
          value: Locale('es'),
          child: Text('Español', style: TextStyle(color: AppColors.white)),
        ),
        DropdownMenuItem(
          value: Locale('ar'),
          child: Text('العربية', style: TextStyle(color: AppColors.white)),
        ),
        DropdownMenuItem(
          value: Locale('de'),
          child: Text('Deutsch', style: TextStyle(color: AppColors.white)),
        ),
        DropdownMenuItem(
          value: Locale('zh'),
          child: Text('中文', style: TextStyle(color: AppColors.white)),
        ),
      ],
    );
  }
}
