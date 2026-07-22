import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/main.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';
import 'about_us_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _showAboutUs = false;

  void _showChangePasswordDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.deepBlue : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
          title: Text(l10n.password),
          content: Text(
            l10n.passwordChangeComingSoon,
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: AppColors.champagneGold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_showAboutUs) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => setState(() => _showAboutUs = false),
          ),
          title: Text(l10n.aboutUsTitle),
        ),
        body: const AboutUsPage(isNested: true),
      );
    }

    final isWide = MediaQuery.of(context).size.width >= AppDimensions.breakpointMd;

    final accountSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.myAccountSection),
        _buildSettingsCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.lock_outline, color: AppColors.champagneGold),
                title: Text(l10n.password, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(l10n.updatePasswordSubtitle),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                onTap: _showChangePasswordDialog,
              ),
            ],
          ),
        ),
      ],
    );

    final preferencesSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.preferencesSection),
        _buildSettingsCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.palette_outlined, color: AppColors.champagneGold),
                title: Text(l10n.appThemeTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(l10n.chooseThemeSubtitle),
                trailing: DropdownButton<ThemeMode>(
                  underline: const SizedBox(),
                  value: MyApp.getThemeMode(context),
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      MyApp.setThemeMode(context, value);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(l10n.systemTheme),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(l10n.lightTheme),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(l10n.darkTheme),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language_outlined, color: AppColors.champagneGold),
                title: Text(l10n.languageTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(l10n.changeLanguageSubtitle),
                trailing: DropdownButton<String>(
                  underline: const SizedBox(),
                  value: Localizations.localeOf(context).languageCode,
                  onChanged: (String? value) {
                    if (value != null) {
                      MyApp.setLocale(context, Locale(value));
                    }
                  },
                  items: const [
                    DropdownMenuItem(value: 'fr', child: Text("Français")),
                    DropdownMenuItem(value: 'en', child: Text("English")),
                    DropdownMenuItem(value: 'es', child: Text("Español")),
                    DropdownMenuItem(value: 'de', child: Text("Deutsch")),
                    DropdownMenuItem(value: 'ar', child: Text("العربية")),
                    DropdownMenuItem(value: 'zh', child: Text("中文")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final notificationsSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.notificationsSecuritySection),
        _buildSettingsCard(
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.champagneGold),
                title: Text(l10n.notificationsPushTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(l10n.notificationsPushSubtitle),
                value: _notificationsEnabled,
                activeThumbColor: AppColors.champagneGold,
                onChanged: (val) {
                  setState(() {
                    _notificationsEnabled = val;
                  });
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.fingerprint_outlined, color: AppColors.champagneGold),
                title: Text(l10n.biometricSecurityTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(l10n.biometricSecuritySubtitle),
                value: _biometricEnabled,
                activeThumbColor: AppColors.champagneGold,
                onChanged: (val) {
                  setState(() {
                    _biometricEnabled = val;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );

    final applicationSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.applicationSection),
        _buildSettingsCard(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline, color: AppColors.champagneGold),
                title: Text(l10n.aboutUsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(l10n.discoverAparthotelSubtitle),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                onTap: () => setState(() => _showAboutUs = true),
              ),
            ],
          ),
        ),
      ],
    );

    Widget content;
    if (isWide) {
      content = SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  accountSection,
                  const SizedBox(height: AppDimensions.spacingLg),
                  preferencesSection,
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spacingLg),
            Expanded(
              child: Column(
                children: [
                  notificationsSection,
                  const SizedBox(height: AppDimensions.spacingLg),
                  applicationSection,
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      content = ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        children: [
          accountSection,
          const SizedBox(height: AppDimensions.spacingLg),
          preferencesSection,
          const SizedBox(height: AppDimensions.spacingLg),
          notificationsSection,
          const SizedBox(height: AppDimensions.spacingLg),
          applicationSection,
        ],
      );
    }

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWide ? 1000 : 600),
          child: content,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.spacingXs, bottom: AppDimensions.spacingSm),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelUppercase,
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Material(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
