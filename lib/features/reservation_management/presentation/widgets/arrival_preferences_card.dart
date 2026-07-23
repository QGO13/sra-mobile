import 'package:flutter/material.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Carte des Préférences d'Arrivée du Séjour — Reproduction Pixel-Perfect de `ArrivalPreferences.tsx`.
class ArrivalPreferencesCard extends StatefulWidget {
  const ArrivalPreferencesCard({super.key});

  @override
  State<ArrivalPreferencesCard> createState() => _ArrivalPreferencesCardState();
}

class _ArrivalPreferencesCardState extends State<ArrivalPreferencesCard> {
  String _selectedSlot = '14:00 — 16:00';
  bool _transferRequested = false;
  final TextEditingController _noteController = TextEditingController();
  bool _saved = false;

  final List<String> _slots = ['Avant 14:00', '14:00 — 16:00', 'Après 16:00'];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _saved = true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.inkMuted;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête de carte avec icône Voiture ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.champagneGold.withValues(alpha: isDark ? 0.2 : 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.champagneGold,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.prepareYourArrival,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.imperialNightBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.prepareArrivalSubtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textMuted,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingLg),

          // ── Créneau d'arrivée ──
          Text(
            l10n.arrivalSlot,
            style: AppTextStyles.labelUppercase.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.champagneGold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _slots.map((slot) {
                final isSelected = _selectedSlot == slot;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(slot),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedSlot = slot;
                          _saved = false;
                        });
                      }
                    },
                    selectedColor: AppColors.champagneGold.withValues(alpha: 0.2),
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.fog,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? Colors.white : AppColors.imperialNightBlue)
                          : textMuted,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                      side: BorderSide(
                        color: isSelected ? AppColors.champagneGold : (isDark ? Colors.white10 : AppColors.softGrey),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingLg),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: AppDimensions.spacingMd),

          // ── Transfert Aéroport Switch ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          l10n.airportTransfer,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: isDark ? Colors.white : AppColors.imperialNightBlue,
                          ),
                        ),
                        if (_transferRequested) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.statusSuccess.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                            ),
                            child: const Text(
                              "Demandé",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.statusSuccess,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.airportTransferSubtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _transferRequested,
                activeThumbColor: AppColors.champagneGold,
                onChanged: (val) {
                  setState(() {
                    _transferRequested = val;
                    _saved = false;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingMd),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: AppDimensions.spacingMd),

          // ── Note / Demande Particulière ──
          SraInput(
            controller: _noteController,
            label: l10n.specialRequests,
            placeholder: l10n.specialRequestsPlaceholder,
            maxLines: 2,
          ),

          const SizedBox(height: AppDimensions.spacingMd),

          // ── Bouton d'Enregistrement ──
          SizedBox(
            width: double.infinity,
            child: SraButton(
              label: l10n.savePreferences,
              icon: Icons.save_rounded,
              onPressed: _save,
            ),
          ),

          if (_saved) ...[
            const SizedBox(height: AppDimensions.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingSm),
              decoration: BoxDecoration(
                color: AppColors.statusSuccess.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                border: Border.all(color: AppColors.statusSuccess, width: 0.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, color: AppColors.statusSuccess, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.preferencesSavedSuccess,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.statusSuccess,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
