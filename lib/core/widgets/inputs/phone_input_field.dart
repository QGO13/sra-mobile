import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sra_hotel/core/constants/country_dial_codes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Widget de saisie du numéro de téléphone international.
/// Compose un volet indicatif (sélecteur de pays) + un champ de saisie du numéro local.
/// La valeur complète est accessible via [onChanged] sous la forme "+225 0707070707".
class PhoneInputField extends StatefulWidget {
  /// Contrôleur pour le numéro local (sans indicatif)
  final TextEditingController numberController;

  /// Pays sélectionné initialement (code ISO, ex: "CI")
  final String? initialCountryCode;

  /// Callback appelé quand l'indicatif ou le numéro change.
  /// Reçoit le numéro complet (indicatif + numéro local).
  final ValueChanged<String>? onChanged;

  /// Validateur pour le champ numéro
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
      backgroundColor: const Color(0x00000000),
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

    final borderColor = isDark ? AppColors.white12 : AppColors.mist;
    final fillColor = isDark ? AppColors.darkCard : AppColors.white;
    final textColor = isDark ? AppColors.white : AppColors.ink;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.phoneLabel,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Volet indicatif ──
            GestureDetector(
              onTap: _selectCountry,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: fillColor,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedCountry.flag,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _selectedCountry.dialCode,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.gold,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // ── Champ numéro local ──
            Expanded(
              child: TextFormField(
                controller: widget.numberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-]')),
                ],
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  hintText: l10n.phoneNumberHint,
                  hintStyle: TextStyle(
                    color: isDark ? AppColors.white38 : AppColors.inkMuted,
                    fontSize: 13,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  fillColor: fillColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.gold, width: 1.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.statusError),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.statusError, width: 1.2),
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
    final bgColor =
        isDark ? AppColors.ink : AppColors.fog;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Poignée
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inkMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  l10n.selectCountryDialCode,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.ink,
                  ),
                ),
              ),
              // Barre de recherche
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filter,
                  style: TextStyle(
                    color: isDark ? AppColors.white : AppColors.ink,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.searchCountry,
                    hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.gold, size: 20),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    fillColor: isDark ? AppColors.darkCard : AppColors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: isDark ? AppColors.white12 : AppColors.mist),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.gold, width: 1.2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
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
                            horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.gold.withValues(alpha: 0.08)
                              : null,
                          border: Border(
                            bottom: BorderSide(
                              color: isDark
                                  ? AppColors.white10
                                  : AppColors.mist,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(country.flag,
                                style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                country.name,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.ink,
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              country.dialCode,
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.check,
                                  color: AppColors.gold, size: 18),
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
