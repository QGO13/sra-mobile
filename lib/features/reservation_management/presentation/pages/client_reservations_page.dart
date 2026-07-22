import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_event.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_state.dart';
import 'package:sra_hotel/features/reservation_management/presentation/pages/booking_detail_page.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

/// Page affichant les réservations du client avec filtres et recherche.
class ClientReservationsPage extends StatefulWidget {
  final VoidCallback onNavigateToSearch;

  const ClientReservationsPage({
    super.key,
    required this.onNavigateToSearch,
  });

  @override
  State<ClientReservationsPage> createState() => _ClientReservationsPageState();
}

class _ClientReservationsPageState extends State<ClientReservationsPage> {
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
        booking.typeChambre.toLowerCase().contains(lowerQuery);
  }

  Widget _buildFilterChips(BuildContext context, AppLocalizations l10n, bool isDark) {
    final filters = [
      {'id': 'all', 'label': l10n.filterAll},
      {'id': 'confirmed', 'label': l10n.filterConfirmed},
      {'id': 'past', 'label': l10n.filterPast},
      {'id': 'cancelled', 'label': l10n.filterCancelled},
      {'id': 'check_in', 'label': l10n.filterCheckIn},
      {'id': 'check_out', 'label': l10n.filterCheckOut},
    ];

    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['id'];
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
            child: ChoiceChip(
              label: Text(
                filter['label']!,
                style: TextStyle(
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.imperialNightBlue),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedFilter = filter['id']!;
                  });
                }
              },
              selectedColor: AppColors.champagneGold,
              backgroundColor: isDark ? AppColors.deepBlue : AppColors.surfaceLight,
              checkmarkColor: Colors.white,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors.softGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return Center(
            child: Text(
              'Veuillez vous connecter pour voir vos réservations.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.statusError),
            ),
          );
        }

        return BlocBuilder<AdminBookingBloc, AdminBookingState>(
          builder: (context, state) {
            if (state is AdminBookingLoading || state is AdminBookingInitial) {
              return const Center(child: LoadingIndicator(color: AppColors.champagneGold));
            }

            if (state is AdminBookingFailure) {
              return ErrorStateView(
                message: state.error,
                onRetry: () => context.read<AdminBookingBloc>().add(LoadAdminBookingsEvent()),
              );
            }

            if (state is AdminBookingLoaded) {
              final filteredBookings = state.bookings.where((booking) {
                return _matchesFilter(booking, _selectedFilter) && _matchesSearch(booking, _searchQuery);
              }).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingMd),
                    child: SraInput(
                      controller: _searchController,
                      placeholder: l10n.searchBookingsPlaceholder,
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.champagneGold),
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
                  _buildFilterChips(context, l10n, isDark),
                  Expanded(
                    child: filteredBookings.isEmpty
                        ? EmptyStateView(
                            icon: Icons.calendar_today_outlined,
                            title: l10n.noBookingFoundTitle,
                            subtitle: _searchQuery.isNotEmpty || _selectedFilter != "all"
                                ? l10n.noBookingMatchingCriteria
                                : l10n.noBookingYet,
                            actionLabel: _searchQuery.isNotEmpty || _selectedFilter != "all"
                                ? l10n.resetFilters
                                : l10n.bookNow,
                            onAction: _searchQuery.isNotEmpty || _selectedFilter != "all"
                                ? () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = "";
                                      _selectedFilter = "all";
                                    });
                                  }
                                : widget.onNavigateToSearch,
                          )
                        : ResponsiveListGridView(
                            itemCount: filteredBookings.length,
                            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                            maxCrossAxisExtent: 450,
                            mainAxisExtent: 220,
                            itemBuilder: (context, index) {
                              final booking = filteredBookings[index];
                              final checkin = DateTime.tryParse(booking.checkIn) ?? DateTime.now();
                              final checkout = DateTime.tryParse(booking.checkOut) ?? DateTime.now();
                              final rangeStr = "${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(checkin)} → ${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(checkout)}";
                              final isCancelled = booking.statutBooking == 'ANNULE' || booking.statutBooking == 'ANNULEE';
                              final isConfirmed = booking.statutBooking == 'CONFIRME' || booking.statutBooking == 'CONFIRMEE';

                              String statusText = booking.statutBooking;
                              if (isConfirmed) statusText = l10n.effectueStatus;
                              if (isCancelled) statusText = l10n.cancelledStatus;
                              if (booking.statutBooking == 'EN_ATTENTE') statusText = l10n.pendingStatus;

                              return Container(
                                margin: MediaQuery.of(context).size.width < AppDimensions.breakpointMd
                                    ? const EdgeInsets.only(bottom: AppDimensions.spacingSm + 4)
                                    : EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.deepBlue : Colors.white,
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                  border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
                                  boxShadow: const [AppShadows.shadowCard],
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingDetailPage(booking: booking),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimensions.spacingMd,
                                      vertical: AppDimensions.spacingSm + 2,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              booking.reference,
                                              style: AppTextStyles.bodySmall.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.champagneGold,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: AppDimensions.spacingSm - 2,
                                                vertical: 2.0,
                                              ),
                                              color: isConfirmed
                                                  ? AppColors.statusSuccess.withValues(alpha: 0.1)
                                                  : (isCancelled ? AppColors.statusError.withValues(alpha: 0.1) : AppColors.statusWarning.withValues(alpha: 0.1)),
                                              child: Text(
                                                statusText.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color: isConfirmed
                                                      ? AppColors.statusSuccess
                                                      : (isCancelled ? AppColors.statusError : AppColors.statusWarning),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppDimensions.spacingSm),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    l10n.bookingsTitle.toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: 1.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: AppDimensions.spacingSm - 4),
                                                  Text(
                                                    booking.typeChambre,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                                                  ),
                                                  const SizedBox(height: AppDimensions.spacingSm),
                                                  Text(
                                                    l10n.periodOfStay.toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: 1.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: AppDimensions.spacingSm - 4),
                                                  Text(
                                                    rangeStr,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: AppDimensions.spacingSm),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  l10n.totalAmount.toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1.0,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: AppDimensions.spacingSm - 4),
                                                Text(
                                                  _formatCurrency(booking.prixTotal),
                                                  style: AppTextStyles.titleMedium.copyWith(
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.champagneGold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (!isCancelled) ...[
                                          const SizedBox(height: AppDimensions.spacingSm),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: SraButton(
                                              isOutlined: true,
                                              backgroundColor: AppColors.statusError,
                                              foregroundColor: AppColors.statusError,
                                              label: l10n.cancelLabel,
                                              onPressed: () async {
                                                final bookingBloc = context.read<AdminBookingBloc>();
                                                final confirmed = await ConfirmDeleteDialog.show(
                                                  context,
                                                  title: l10n.cancelBookingTitle,
                                                  message: l10n.cancelBookingConfirm(booking.reference),
                                                  confirmLabel: l10n.deleteLabel,
                                                  cancelLabel: l10n.cancelLabel,
                                                );
                                                if (confirmed) {
                                                  bookingBloc.add(CancelAdminBookingEvent(booking.id));
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
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
      },
    );
  }
}
