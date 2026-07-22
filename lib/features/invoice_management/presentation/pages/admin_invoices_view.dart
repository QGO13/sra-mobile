import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/empty_state_view.dart';
import 'package:sra_hotel/core/widgets/error_state_view.dart';
import 'package:sra_hotel/core/widgets/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/responsive_list_grid_view.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_bloc.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_event.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_state.dart';
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
          return const Center(child: LoadingIndicator(color: AppColors.champagneGold));
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
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.invoicesTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
              Expanded(
                child: ResponsiveListGridView(
                  itemCount: state.invoices.length,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                  maxCrossAxisExtent: 450,
                  mainAxisExtent: 110,
                  itemBuilder: (context, index) {
                    final invoice = state.invoices[index];
                    final isPaid = invoice.statutFacture == 'PAYEE';
                    final date = DateTime.tryParse(invoice.dateCreation);
                    final localeStr = Localizations.localeOf(context).toString();
                    final formattedDate = date != null ? DateFormat.yMMMd(localeStr).format(date) : invoice.dateCreation;

                    return Container(
                      margin: MediaQuery.of(context).size.width < AppDimensions.breakpointMd
                          ? const EdgeInsets.only(bottom: AppDimensions.spacingSm + 2)
                          : EdgeInsets.zero,
                      padding: const EdgeInsets.all(AppDimensions.spacingSm + 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.deepBlue : Colors.white,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                        boxShadow: const [AppShadows.shadowCard],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(invoice.code, style: AppTextStyles.monospace.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: AppDimensions.spacingXs / 2),
                              Text(invoice.clientNom, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              Text('${l10n.dateLabel} : $formattedDate', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatCurrency(invoice.prixTotal),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.champagneGold),
                              ),
                              const SizedBox(height: AppDimensions.spacingXs),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm - 2, vertical: AppDimensions.spacingXs / 2),
                                color: isPaid ? AppColors.statusSuccess.withValues(alpha: 0.1) : AppColors.statusWarning.withValues(alpha: 0.1),
                                child: Text(
                                  isPaid ? l10n.paidStatus : l10n.pendingStatus,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isPaid ? AppColors.statusSuccess : AppColors.statusWarning,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
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
