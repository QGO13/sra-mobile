import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/display/sra_filter_bar.dart';
import 'package:sra_hotel/core/widgets/display/sra_status_badge.dart';
import 'package:sra_hotel/core/widgets/feedback/error_state_view.dart';
import 'package:sra_hotel/core/widgets/feedback/loading_indicator.dart';
import 'package:sra_hotel/core/widgets/inputs/sra_input.dart';
import 'package:sra_hotel/core/widgets/layout/sra_data_table.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_event.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_state.dart';
import 'package:sra_hotel/features/reservation_management/presentation/pages/booking_detail_page.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AdminBookingsView extends StatefulWidget {
  const AdminBookingsView({super.key});

  @override
  State<AdminBookingsView> createState() => _AdminBookingsViewState();
}

class _AdminBookingsViewState extends State<AdminBookingsView> {
  String _searchQuery = "";
  String _selectedFilter = "all";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  bool _matchesFilter(Booking booking, String filter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (filter) {
      case "confirmed":
        return booking.statutBooking == 'CONFIRME' || booking.statutBooking == 'CONFIRMEE';
      case "pending":
        return booking.statutBooking == 'EN_ATTENTE';
      case "past":
        final checkOutDate = DateTime.tryParse(booking.checkOut);
        return checkOutDate != null && checkOutDate.isBefore(today);
      case "cancelled":
        return booking.statutBooking == 'ANNULE' || booking.statutBooking == 'ANNULEE';
      case "check_in":
        final checkInDate = DateTime.tryParse(booking.checkIn);
        return checkInDate != null &&
            checkInDate.year == today.year &&
            checkInDate.month == today.month &&
            checkInDate.day == today.day;
      case "check_out":
        final checkOutDate = DateTime.tryParse(booking.checkOut);
        return checkOutDate != null &&
            checkOutDate.year == today.year &&
            checkOutDate.month == today.month &&
            checkOutDate.day == today.day;
      case "all":
      default:
        return true;
    }
  }

  bool _matchesSearch(Booking booking, String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();
    return booking.reference.toLowerCase().contains(lowerQuery) ||
        booking.clientNom.toLowerCase().contains(lowerQuery) ||
        booking.typeChambre.toLowerCase().contains(lowerQuery);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width >= AppDimensions.breakpointMd;

    return BlocBuilder<AdminBookingBloc, AdminBookingState>(
      builder: (context, state) {
        if (state is AdminBookingLoading || state is AdminBookingInitial) {
          return const LoadingIndicator();
        } else if (state is AdminBookingFailure) {
          return ErrorStateView(
            message: state.error,
            onRetry: () => context.read<AdminBookingBloc>().add(LoadAdminBookingsEvent()),
          );
        } else if (state is AdminBookingLoaded) {
          final allBookings = state.bookings;
          final totalBookings = allBookings.length;
          final confirmedCount = allBookings.where((b) => b.statutBooking == 'CONFIRME' || b.statutBooking == 'CONFIRMEE').length;
          final pendingCount = allBookings.where((b) => b.statutBooking == 'EN_ATTENTE').length;
          final totalRevenue = totalBookings > 0 ? allBookings.map((b) => b.prixTotal).reduce((a, b) => a + b) : 0.0;

          final filteredBookings = allBookings.where((booking) {
            return _matchesFilter(booking, _selectedFilter) &&
                _matchesSearch(booking, _searchQuery);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Bandeau KPIs Supérieur ──
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingMd),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = isWide ? (constraints.maxWidth - 30) / 4 : (constraints.maxWidth - 10) / 2;
                    return Wrap(
                      spacing: AppDimensions.spacingSm,
                      runSpacing: AppDimensions.spacingSm,
                      children: [
                        _buildKpiChip(l10n.bookingsTitle, "$totalBookings", Icons.calendar_month, AppColors.gold, isDark, itemWidth),
                        _buildKpiChip(l10n.filterConfirmed, "$confirmedCount", Icons.check_circle_outline, AppColors.statusSuccess, isDark, itemWidth),
                        _buildKpiChip(l10n.pendingStatus, "$pendingCount", Icons.hourglass_empty, AppColors.statusWarning, isDark, itemWidth),
                        _buildKpiChip(l10n.totalRevenue, _formatCurrency(totalRevenue), Icons.account_balance_wallet_outlined, AppColors.gold, isDark, itemWidth),
                      ],
                    );
                  },
                ),
              ),

              // ── Barre de recherche ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                child: SraInput(
                  controller: _searchController,
                  placeholder: l10n.searchBookingsPlaceholder,
                  prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.gold),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = "";
                            });
                          },
                        )
                      : null,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),

              // ── Chips de Filtrage par Statut ──
              SraFilterBar(
                items: [
                  SraFilterItem(id: 'all', label: "${l10n.filterAll} ($totalBookings)"),
                  SraFilterItem(id: 'confirmed', label: "${l10n.filterConfirmed} ($confirmedCount)"),
                  SraFilterItem(id: 'pending', label: "${l10n.pendingStatus} ($pendingCount)"),
                  SraFilterItem(id: 'past', label: l10n.filterPast),
                  SraFilterItem(id: 'cancelled', label: l10n.filterCancelled),
                  SraFilterItem(id: 'check_in', label: l10n.filterCheckIn),
                  SraFilterItem(id: 'check_out', label: l10n.filterCheckOut),
                ],
                selectedId: _selectedFilter,
                onSelected: (id) {
                  setState(() {
                    _selectedFilter = id;
                  });
                },
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // ── Vue Tableau CRUD Unifiée ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                  child: SraDataTable<Booking>(
                    items: filteredBookings,
                    minWidth: 750,
                    emptyTitle: l10n.noBookingFoundTitle,
                    emptyIcon: Icons.calendar_today_outlined,
                    columns: [
                      SraTableColumn<Booking>(
                        label: "Référence",
                        flex: 1.2,
                        cellBuilder: (context, booking) => Text(
                          booking.reference,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight2 : AppColors.gold,
                          ),
                        ),
                      ),
                      SraTableColumn<Booking>(
                        label: "Client",
                        flex: 1.4,
                        cellBuilder: (context, booking) => Text(
                          booking.clientNom,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                      SraTableColumn<Booking>(
                        label: "Chambre / Type",
                        flex: 1.2,
                        cellBuilder: (context, booking) => Text(
                          booking.typeChambre,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.white : AppColors.ink,
                          ),
                        ),
                      ),
                      SraTableColumn<Booking>(
                        label: "Dates Séjour",
                        flex: 1.4,
                        cellBuilder: (context, booking) {
                          final checkin = DateTime.tryParse(booking.checkIn) ?? DateTime.now();
                          final checkout = DateTime.tryParse(booking.checkOut) ?? DateTime.now();
                          final loc = Localizations.localeOf(context).toString();
                          final rangeStr = "${DateFormat.MMMd(loc).format(checkin)} → ${DateFormat.MMMd(loc).format(checkout)}";
                          return Text(
                            rangeStr,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                            ),
                          );
                        },
                      ),
                      SraTableColumn<Booking>(
                        label: "Montant",
                        flex: 1.0,
                        cellBuilder: (context, booking) => Text(
                          _formatCurrency(booking.prixTotal),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldLight2 : AppColors.gold,
                          ),
                        ),
                      ),
                      SraTableColumn<Booking>(
                        label: "Statut",
                        flex: 1.0,
                        cellBuilder: (context, booking) {
                          final isConfirmed = booking.statutBooking == 'CONFIRME' || booking.statutBooking == 'CONFIRMEE';
                          final isCancelled = booking.statutBooking == 'ANNULE' || booking.statutBooking == 'ANNULEE';
                          if (isConfirmed) {
                            return const SraStatusBadge.success(label: 'CONFIRMÉE', small: true);
                          } else if (isCancelled) {
                            return const SraStatusBadge.error(label: 'ANNULÉE', small: true);
                          } else {
                            return const SraStatusBadge.warning(label: 'EN ATTENTE', small: true);
                          }
                        },
                      ),
                      SraTableColumn<Booking>(
                        label: "Actions",
                        flex: 0.8,
                        alignment: Alignment.centerRight,
                        cellBuilder: (context, booking) => IconButton(
                          tooltip: "Détails réservation",
                          icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.gold),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingDetailPage(booking: booking),
                              ),
                            );
                          },
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

  Widget _buildKpiChip(String label, String value, IconData icon, Color color, bool isDark, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm + 2, vertical: AppDimensions.spacingSm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.mist),
        boxShadow: const [AppShadows.shadowCard],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.overlayDarkMedium : AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
