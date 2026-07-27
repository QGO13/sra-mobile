import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/display/sra_status_badge.dart';
import 'package:sra_hotel/core/widgets/feedback/empty_state_view.dart';
import 'package:sra_hotel/core/widgets/feedback/error_state_view.dart';
import 'package:sra_hotel/core/widgets/feedback/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/layout/sra_data_table.dart';
import 'package:sra_hotel/features/invoice_management/domain/entities/client_invoice.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_bloc.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_event.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_state.dart';
import 'package:sra_hotel/features/invoice_management/presentation/widgets/invoice_details_dialog.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AdminInvoicesView extends StatelessWidget {
  const AdminInvoicesView({super.key});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        if (state is InvoiceLoading || state is InvoiceInitial) {
          return const LoadingIndicator();
        } else if (state is InvoiceFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<InvoiceBloc>().add(LoadInvoicesEvent()),
          );
        } else if (state is InvoiceLoaded) {
          if (state.invoices.isEmpty) {
            return const EmptyStateView(
              icon: Icons.receipt_long_outlined,
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.invoicesTitle,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: isDark ? AppColors.white : AppColors.ink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${state.invoices.length} factures',
                      style: AppTextStyles.labelMuted,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                  child: SraDataTable<ClientInvoice>(
                    items: state.invoices,
                    minWidth: 700,
                    emptyTitle: 'Aucune facture enregistrée',
                    emptyIcon: Icons.receipt_long_outlined,
                    columns: [
                      SraTableColumn<ClientInvoice>(
                        label: "Code Facture",
                        flex: 1.2,
                        cellBuilder: (context, invoice) => Text(
                          invoice.code,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight2 : AppColors.gold,
                          ),
                        ),
                      ),
                      SraTableColumn<ClientInvoice>(
                        label: "Client",
                        flex: 1.4,
                        cellBuilder: (context, invoice) => Text(
                          invoice.clientNom,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                      SraTableColumn<ClientInvoice>(
                        label: l10n.dateLabel,
                        flex: 1.0,
                        cellBuilder: (context, invoice) {
                          final date = DateTime.tryParse(invoice.dateCreation);
                          final localeStr = Localizations.localeOf(context).toString();
                          final formattedDate = date != null ? DateFormat.yMMMd(localeStr).format(date) : invoice.dateCreation;
                          return Text(
                            formattedDate,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                            ),
                          );
                        },
                      ),
                      SraTableColumn<ClientInvoice>(
                        label: "Montant Total",
                        flex: 1.2,
                        cellBuilder: (context, invoice) => Text(
                          _formatCurrency(invoice.prixTotal),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight2 : AppColors.gold,
                          ),
                        ),
                      ),
                      SraTableColumn<ClientInvoice>(
                        label: "Statut",
                        flex: 1.0,
                        cellBuilder: (context, invoice) {
                          final isPaid = invoice.statutFacture.toUpperCase() == 'PAYEE';
                          return SraStatusBadge(
                            label: isPaid ? l10n.paidStatus : l10n.pendingStatus,
                            type: isPaid ? SraStatusType.success : SraStatusType.warning,
                            small: true,
                          );
                        },
                      ),
                      SraTableColumn<ClientInvoice>(
                        label: "Actions",
                        flex: 0.8,
                        alignment: Alignment.centerRight,
                        cellBuilder: (context, invoice) => IconButton(
                          tooltip: "Détails & Impression",
                          icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.gold),
                          onPressed: () => InvoiceDetailsDialog.show(context, invoice),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
