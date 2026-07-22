import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sra_hotel/core/constants/country_dial_codes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Widget de saisie du numéro de téléphone international avec support Dark Mode.
/// Compose un volet indicatif (sélecteur de pays) + un champ de saisie du numéro local.
class PhoneInputField extends StatefulWidget {
  final TextEditingController numberController;
  final String? initialCountryCode;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const PhoneInputField({
    super.key,
    required this.numberController,
    this.initialCountryCode,
    this.onChanged,
    this.validator,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late CountryDialCode _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountryCode != null
        ? (CountryDialCodes.findByCode(widget.initialCountryCode!) ??
            CountryDialCodes.defaultCountry)
        : CountryDialCodes.defaultCountry;

    widget.numberController.addListener(_notifyChange);
  }

  @override
  void dispose() {
    widget.numberController.removeListener(_notifyChange);
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged?.call(
      '${_selectedCountry.dialCode}${widget.numberController.text.trim()}',
    );
  }

  void _selectCountry() async {
    final selected = await showModalBottomSheet<CountryDialCode>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CountryPickerSheet(
        currentCode: _selectedCountry.code,
      ),
    );
    if (selected != null) {
      setState(() => _selectedCountry = selected);
      _notifyChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.mist;
    final fillColor = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.white : AppColors.ink;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.phoneLabel.toUpperCase(),
          style: AppTextStyles.labelUppercase,
        ),
        AppDimensions.vGapSm,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Volet indicatif ──
            GestureDetector(
              onTap: _selectCountry,
              child: Container(
                height: AppDimensions.inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm),
                decoration: BoxDecoration(
                  color: fillColor,
                  border: Border.all(color: borderColor, width: AppDimensions.borderThin),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedCountry.flag,
                      style: AppTextStyles.titleMedium,
                    ),
                    AppDimensions.hGapXs,
                    Text(
                      _selectedCountry.dialCode,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppDimensions.hGapXs,
                    const Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.gold,
                      size: AppDimensions.iconSizeMd,
                    ),
                  ],
                ),
              ),
            ),
            AppDimensions.hGapSm,

            // ── Champ numéro local ──
            Expanded(
              child: TextFormField(
                controller: widget.numberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-]')),
                ],
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: l10n.phoneNumberHint,
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMd,
                    vertical: AppDimensions.spacingMd,
                  ),
                  fillColor: fillColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: AppDimensions.borderThin),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.gold, width: AppDimensions.borderMedium),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.statusError, width: AppDimensions.borderThin),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.statusError, width: AppDimensions.borderMedium),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                ),
                validator: widget.validator,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Bottom sheet de sélection du pays
// ─────────────────────────────────────────────────────────────────

class _CountryPickerSheet extends StatefulWidget {
  final String currentCode;

  const _CountryPickerSheet({required this.currentCode});

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchController = TextEditingController();
  List<CountryDialCode> _filtered = CountryDialCodes.list;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      _filtered = query.isEmpty
          ? CountryDialCodes.list
          : CountryDialCodes.list
              .where((c) =>
                  c.name.toLowerCase().contains(query.toLowerCase()) ||
                  c.dialCode.contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final bgColor = isDark ? AppColors.darkCard : AppColors.fog;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
          ),
          child: Column(
            children: [
              // Poignée
              Container(
                margin: const EdgeInsets.only(top: AppDimensions.spacingSm, bottom: AppDimensions.spacingXs),
                width: AppDimensions.buttonHeightSm,
                height: AppDimensions.borderThick * 2,
                decoration: BoxDecoration(
                  color: AppColors.inkMuted,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingSm,
                ),
                child: Text(
                  l10n.selectCountryDialCode,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? AppColors.white : AppColors.ink,
                  ),
                ),
              ),
              // Barre de recherche
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingXs,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filter,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.white : AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.searchCountry,
                    hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.inkMuted),
                    prefixIcon: const Icon(Icons.search, color: AppColors.gold, size: AppDimensions.iconSizeMd),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingMd,
                      vertical: AppDimensions.spacingSm,
                    ),
                    fillColor: isDark ? AppColors.darkElevated : AppColors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.mist),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.gold, width: AppDimensions.borderMedium),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                  ),
                ),
              ),
              AppDimensions.vGapXs,
              // Liste
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) {
                    final country = _filtered[i];
                    final isSelected = country.code == widget.currentCode;
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(country),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacingLg,
                          vertical: AppDimensions.spacingSm,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.gold.withValues(alpha: isDark ? 0.18 : 0.08) : null,
                          border: Border(
                            bottom: BorderSide(
                              color: isDark ? AppColors.darkBorder : AppColors.mist,
                              width: AppDimensions.borderHair,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(country.flag, style: AppTextStyles.titleLarge),
                            AppDimensions.hGapMd,
                            Expanded(
                              child: Text(
                                country.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isDark ? AppColors.white : AppColors.ink,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              country.dialCode,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isSelected) ...[
                              AppDimensions.hGapSm,
                              const Icon(Icons.check, color: AppColors.gold, size: AppDimensions.iconSizeSm),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
