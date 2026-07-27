import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/cards/kpi_card.dart';
import 'package:sra_hotel/core/widgets/cards/sra_card.dart';
import 'package:sra_hotel/core/widgets/display/sra_status_badge.dart';
import 'package:sra_hotel/core/widgets/feedback/error_state_view.dart';
import 'package:sra_hotel/core/widgets/feedback/loading_indicator.dart';
import 'package:sra_hotel/features/admin_dashboard/presentation/widgets/admin_action_queue.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_bloc.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_event.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_state.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/widgets/inventory_status_card.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/widgets/kpi_charts.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_bloc.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_state.dart';

class AdminKpisView extends StatelessWidget {
  const AdminKpisView({super.key});

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  double _parseDelta(String deltaStr) {
    final cleaned = deltaStr.replaceAll('%', '').replaceAll('+', '').replaceAll(',', '.').trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width >= 1024;

    return BlocBuilder<KpiBloc, KpiState>(
      builder: (context, state) {
        if (state is KpiLoading || state is KpiInitial) {
          return const LoadingIndicator();
        } else if (state is KpiFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<KpiBloc>().add(LoadKpiDashboardEvent()),
          );
        } else if (state is KpiLoaded) {
          final kpis = state.kpi;
          final history = state.history;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── En-tête de Direction ──
                Text(
                  "PILOTAGE · YIELD MANAGEMENT",
                  style: AppTextStyles.buttonLabelSm.copyWith(
                    color: isDark ? AppColors.goldLight2 : AppColors.gold,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Tableau de bord de direction",
                  style: AppTextStyles.titleLarge.copyWith(
                    color: isDark ? AppColors.white : AppColors.ink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Une lecture opérationnelle des performances, arrivées à protéger et leviers de revenu.",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingMd),

                // ── KPIs Grid (Desktop: 4 colonnes, Mobile: 2 colonnes) ──
                GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppDimensions.spacingMd,
                  mainAxisSpacing: AppDimensions.spacingMd,
                  childAspectRatio: isWide ? 1.6 : 1.3,
                  children: [
                    KpiCard(
                      label: "RevPAR",
                      value: _formatCurrency(kpis.revpar),
                      delta: _parseDelta(kpis.revparDelta),
                      icon: Icons.trending_up_rounded,
                      comparisonPeriod: "vs mois dernier",
                    ),
                    KpiCard(
                      label: "Taux d'occupation",
                      value: "${kpis.tauxOccupation.toStringAsFixed(0)}%",
                      delta: _parseDelta(kpis.tauxDelta),
                      icon: Icons.hotel_rounded,
                      comparisonPeriod: "vs mois dernier",
                    ),
                    KpiCard(
                      label: "CA Mensuel",
                      value: _formatCurrency(kpis.caMensuel),
                      delta: _parseDelta(kpis.caDelta),
                      icon: Icons.payments_rounded,
                      comparisonPeriod: "vs mois dernier",
                    ),
                    KpiCard(
                      label: "ADR (panier moyen)",
                      value: _formatCurrency(kpis.panierMoyen),
                      delta: _parseDelta(kpis.panierDelta),
                      icon: Icons.star_rounded,
                      comparisonPeriod: "vs mois dernier",
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                // ── Mises en Page 2 Colonnes (Desktop) ou Empilée (Mobile) ──
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Colonne Gauche (60%) : Graphiques & Dernières Transactions
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _buildChartCard(
                              title: "Chiffre d'affaires mensuel",
                              subtitle: "Historique sur les 6 derniers mois (FCFA)",
                              badgeLabel: kpis.caDelta,
                              chart: RevenueAreaChart(values: history.revenue, labels: history.labels),
                              isDark: isDark,
                            ),
                            const SizedBox(height: AppDimensions.spacingMd),
                            _buildChartCard(
                              title: "Taux d'occupation par mois",
                              subtitle: "Pourcentage de remplissage des chambres",
                              badgeLabel: kpis.tauxDelta,
                              chart: OccupancyBarChart(values: history.occupancy, labels: history.labels),
                              isDark: isDark,
                            ),
                            const SizedBox(height: AppDimensions.spacingMd),
                            _buildRecentTransactionsCard(isDark),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacingLg),

                      // Colonne Droite (40%) : Actions & Parc Hôtelier
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: const [
                            AdminActionQueue(),
                            SizedBox(height: AppDimensions.spacingMd),
                            InventoryStatusCard(),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildChartCard(
                        title: "Chiffre d'affaires mensuel",
                        subtitle: "Historique sur les 6 derniers mois (FCFA)",
                        badgeLabel: kpis.caDelta,
                        chart: RevenueAreaChart(values: history.revenue, labels: history.labels),
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _buildChartCard(
                        title: "Taux d'occupation par mois",
                        subtitle: "Pourcentage de remplissage des chambres",
                        badgeLabel: kpis.tauxDelta,
                        chart: OccupancyBarChart(values: history.occupancy, labels: history.labels),
                        isDark: isDark,
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      const InventoryStatusCard(),
                      const SizedBox(height: AppDimensions.spacingMd),
                      const AdminActionQueue(),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _buildRecentTransactionsCard(isDark),
                    ],
                  ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required String badgeLabel,
    required Widget chart,
    required bool isDark,
  }) {
    final isPositive = !badgeLabel.contains('-');
    return SraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
              SraStatusBadge(
                label: badgeLabel,
                type: isPositive ? SraStatusType.success : SraStatusType.error,
                small: true,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          chart,
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsCard(bool isDark) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        if (state is InvoiceLoaded && state.invoices.isNotEmpty) {
          final recent = state.invoices.take(5).toList();
          return SraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dernières transactions",
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recent.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, thickness: 0.5),
                  itemBuilder: (context, index) {
                    final inv = recent[index];
                    final isPaid = inv.statutFacture.toUpperCase() == 'PAYEE';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  inv.clientNom,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.white : AppColors.ink,
                                  ),
                                ),
                                Text(
                                  "${inv.code} · Date : ${inv.dateCreation}",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              SraStatusBadge(
                                label: isPaid ? "PAYÉE" : "EN ATTENTE",
                                type: isPaid ? SraStatusType.success : SraStatusType.warning,
                                small: true,
                              ),
                              const SizedBox(width: AppDimensions.spacingSm),
                              Text(
                                _formatCurrency(inv.prixTotal),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.goldLight2 : AppColors.gold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
