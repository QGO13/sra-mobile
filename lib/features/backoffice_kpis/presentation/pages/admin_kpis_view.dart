import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/error_state_view.dart';
import 'package:sra_hotel/core/widgets/loading_indicator.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_bloc.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_event.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_state.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/widgets/kpi_charts.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AdminKpisView extends StatelessWidget {
  const AdminKpisView({super.key});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<KpiBloc, KpiState>(
      builder: (context, state) {
        if (state is KpiLoading || state is KpiInitial) {
          return const Center(child: LoadingIndicator(color: AppColors.champagneGold));
        } else if (state is KpiFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<KpiBloc>().add(LoadKpiDashboardEvent()),
          );
        } else if (state is KpiLoaded) {
          final kpis = state.kpi;
          final history = state.history;

          final isWide = MediaQuery.of(context).size.width >= 1024;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kpiTitle,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                // KPIs Grid (dynamic crossAxisCount)
                GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.5 : 1.3,
                  children: [
                    _buildKpiCard(l10n.caMensuel, _formatCurrency(kpis.caMensuel), kpis.caDelta, true, isDark, l10n.vsLastMonth),
                    _buildKpiCard(l10n.occupationRate, "${kpis.tauxOccupation.toStringAsFixed(0)}%", kpis.tauxDelta, true, isDark, l10n.vsLastMonth),
                    _buildKpiCard(l10n.revpar, _formatCurrency(kpis.revpar), kpis.revparDelta, true, isDark, l10n.vsLastMonth),
                    _buildKpiCard(l10n.panierMoyen, _formatCurrency(kpis.panierMoyen), kpis.panierDelta, false, isDark, l10n.vsLastMonth),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                // Revenue trend chart card
                _buildChartCard(
                  title: l10n.revenueHistoryTitle,
                  chart: RevenueBarChart(values: history.revenue, labels: history.labels),
                  isDark: isDark,
                  theme: theme,
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                // Occupancy trend chart card
                _buildChartCard(
                  title: l10n.occupancyHistoryTitle,
                  chart: OccupancyBarChart(values: history.occupancy, labels: history.labels),
                  isDark: isDark,
                  theme: theme,
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildKpiCard(String label, String value, String delta, bool isPositive, bool isDark, String vsLastMonthLabel) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingSm + 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, letterSpacing: 1.0, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.champagneGold)),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? AppColors.statusSuccess : AppColors.statusError,
                size: 14,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              Expanded(
                child: Text(
                  "$delta $vsLastMonthLabel",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: isPositive ? AppColors.statusSuccess : AppColors.statusError, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget chart, required bool isDark, required ThemeData theme}) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, letterSpacing: 1.0, color: AppColors.champagneGold, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spacingSm + 4),
          chart,
        ],
      ),
    );
  }
}
