import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/injection_container.dart' as di;

class AlternativePropositionsWidget extends StatelessWidget {
  final BookingRoomType selectedType;
  final List<BookingRoomType> alternatives;
  final Function(BookingRoomType alternativeType) onSelectAlternative;
  final VoidCallback onCancel;

  const AlternativePropositionsWidget({
    super.key,
    required this.selectedType,
    required this.alternatives,
    required this.onSelectAlternative,
    required this.onCancel,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.champagneGold),
                onPressed: onCancel,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  "Indisponible",
                  style: AppTextStyles.titleLarge.copyWith(
                    color: isDark ? Colors.white : AppColors.imperialNightBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          // Warning box V2
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.statusError.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: Border.all(color: AppColors.statusError.withValues(alpha: 0.3), width: 1.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.statusError, size: 24),
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(
                  child: Text(
                    "Aucune chambre de type '${selectedType.nom}' n'est disponible pour la période sélectionnée.",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? Colors.white70 : AppColors.imperialNightBlue,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),

          if (alternatives.isEmpty) ...[
            Text(
              "Malheureusement, l'hôtel est complet pour toutes les catégories sur cette période.",
              style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.champagneGold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusFull)),
              ),
              child: const Text("Retour au début", style: TextStyle(color: AppColors.champagneGold)),
            ),
          ] else ...[
            Text(
              "Voici les alternatives disponibles :",
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alternatives.length,
              itemBuilder: (context, index) {
                final alt = alternatives[index];
                String imageUrl = alt.images.isNotEmpty ? alt.images[0] : '';
                if (imageUrl.startsWith('/')) {
                  final baseUrl = di.sl<ApiClient>().absoluteBaseUrl;
                  imageUrl = "$baseUrl$imageUrl";
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.deepBlue : AppColors.ecruWhite,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(AppDimensions.spacingSm),
                    leading: imageUrl.isNotEmpty
                        ? SizedBox(
                            width: 60,
                            height: 60,
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.champagneGold),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.hotel,
                                color: AppColors.champagneGold,
                              ),
                            ),
                          )
                        : const Icon(Icons.hotel, color: AppColors.champagneGold),
                    title: Text(
                      alt.nom,
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${_formatCurrency(alt.prixNuit)} / nuit",
                      style: const TextStyle(color: AppColors.champagneGold, fontSize: 12),
                    ),
                    trailing: OutlinedButton(
                      onPressed: () => onSelectAlternative(alt),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.champagneGold),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Text(
                        "CHOISIR",
                        style: TextStyle(color: AppColors.champagneGold, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
