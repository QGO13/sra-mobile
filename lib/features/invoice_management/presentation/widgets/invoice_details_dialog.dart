import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/buttons/sra_button.dart';
import 'package:sra_hotel/core/widgets/display/sra_status_badge.dart';
import 'package:sra_hotel/features/invoice_management/domain/entities/client_invoice.dart';

/// Dialogue modal de détail de facture — Équivalent de `InvoiceDetailsDialog.tsx` de SRAh V2.
///
/// Affiche la ventilation financière complète (Nuitées, TST 2.5%, Taxe de séjour) SANS TVA.
class InvoiceDetailsDialog extends StatelessWidget {
  final ClientInvoice invoice;

  const InvoiceDetailsDialog({
    super.key,
    required this.invoice,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  static void show(BuildContext context, ClientInvoice invoice) {
    showDialog(
      context: context,
      builder: (context) => InvoiceDetailsDialog(invoice: invoice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPaid = invoice.statutFacture.toUpperCase() == 'PAYEE';
    final date = DateTime.tryParse(invoice.dateCreation);
    final localeStr = Localizations.localeOf(context).toString();
    final formattedDate = date != null ? DateFormat.yMMMMd(localeStr).format(date) : invoice.dateCreation;

    // Calculs financiers SANS TVA (conformément aux directives de l'établissement)
    // TST = 2.5% du sous-total HT, Taxe de séjour = 500 FCFA / nuitée
    final totalAmount = invoice.prixTotal;
    final tstTax = totalAmount * 0.025;
    final stayTax = 500.0;
    final subTotal = totalAmount - tstTax - stayTax;

    return Dialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingLg,
        vertical: AppDimensions.spacingXl,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 540),
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec Titre et Statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FACTURE DE SÉJOUR',
                        style: AppTextStyles.labelUppercase.copyWith(
                          color: isDark ? AppColors.goldLight2 : AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppDimensions.vGapXs,
                      Text(
                        invoice.code,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: isDark ? AppColors.white : AppColors.ink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SraStatusBadge(
                    label: isPaid ? 'PAYÉE' : 'EN ATTENTE',
                    type: isPaid ? SraStatusType.success : SraStatusType.warning,
                  ),
                ],
              ),
              AppDimensions.vGapMd,
              const Divider(color: AppColors.mist),
              AppDimensions.vGapMd,

              // Client et Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Client',
                        style: AppTextStyles.labelMuted,
                      ),
                      Text(
                        invoice.clientNom,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.white : AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Date d\'émission',
                        style: AppTextStyles.labelMuted,
                      ),
                      Text(
                        formattedDate,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isDark ? AppColors.white : AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppDimensions.vGapLg,

              // Lignes de Facture
              Text(
                'DÉTAILS DES PRESTATIONS',
                style: AppTextStyles.labelUppercase.copyWith(
                  color: isDark ? AppColors.goldLight2 : AppColors.gold,
                ),
              ),
              AppDimensions.vGapSm,
              _buildLineItem(
                label: 'Séjour & Nuitées hôtelières',
                amount: subTotal > 0 ? subTotal : totalAmount,
                isDark: isDark,
              ),
              const Divider(color: AppColors.mist, height: AppDimensions.spacingMd * 2),

              // Taxes Réglementaires (TST 2.5% + Taxe séjour - PAS DE TVA)
              Text(
                'TAXES RÉGLEMENTAIRES (SANS TVA)',
                style: AppTextStyles.labelUppercase.copyWith(
                  color: isDark ? AppColors.inkMuted : AppColors.inkMuted,
                ),
              ),
              AppDimensions.vGapSm,
              _buildLineItem(
                label: 'Taxe de Séjour (TST 2,5%)',
                amount: tstTax > 0 ? tstTax : totalAmount * 0.025,
                isDark: isDark,
              ),
              AppDimensions.vGapXs,
              _buildLineItem(
                label: 'Taxe de Séjour Forfaitaire (500 FCFA/nuit)',
                amount: stayTax,
                isDark: isDark,
              ),
              AppDimensions.vGapLg,
              const Divider(color: AppColors.gold, thickness: AppDimensions.borderMedium),
              AppDimensions.vGapSm,

              // Total Général
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL À PAYER',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.ink,
                    ),
                  ),
                  Text(
                    _formatCurrency(invoice.prixTotal),
                    style: AppTextStyles.displaySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.goldLight2 : AppColors.gold,
                    ),
                  ),
                ],
              ),
              AppDimensions.vGapXl,

              // Actions du bas
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SraButton.secondary(
                    label: 'Fermer',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  AppDimensions.hGapSm,
                  SraButton(
                    label: 'Imprimer / PDF',
                    icon: Icons.print_outlined,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineItem({
    required String label,
    required double amount,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.white : AppColors.ink,
            ),
          ),
        ),
        Text(
          _formatCurrency(amount),
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.ink,
          ),
        ),
      ],
    );
  }
}
