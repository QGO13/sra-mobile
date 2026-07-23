import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_state.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_event.dart';
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_state.dart';
import 'package:sra_hotel/features/reservation_management/presentation/pages/booking_detail_page.dart';
import 'package:sra_hotel/features/reservation_management/presentation/pages/booking_items_page.dart';
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

  String _getBookingImageUrl(Booking booking) {
    final roomType = booking.typeChambre.toLowerCase();
    if (roomType.contains('suite')) {
      return 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?w=800&q=80';
    } else if (roomType.contains('prem') || roomType.contains('sup')) {
      return 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=800&q=80';
    } else {
      return 'https://images.unsplash.com/photo-1631049552057-403cdb8f0658?w=800&q=80';
    }
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
              return const LoadingWidget();
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

                  // ── Barre de Filtres Standardisée SRA Hotel ──
                  SraFilterBar(
                    items: [
                      SraFilterItem(id: 'all', label: l10n.filterAll),
                      SraFilterItem(id: 'confirmed', label: l10n.filterConfirmed),
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
                            maxCrossAxisExtent: 480,
                            mainAxisExtent: 250,
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
                                    final adminBookingBloc = context.read<AdminBookingBloc>();
                                    if (booking.lines.length > 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: adminBookingBloc,
                                            child: BookingItemsPage(booking: booking),
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: adminBookingBloc,
                                            child: BookingDetailPage(
                                              booking: booking,
                                              selectedLine: booking.lines.isNotEmpty ? booking.lines.first : null,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppDimensions.spacingMd),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // ── Ligne Supérieure : Référence & Statut ──
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
                                                vertical: 3.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isConfirmed
                                                    ? AppColors.statusSuccess.withValues(alpha: 0.12)
                                                    : (isCancelled
                                                        ? AppColors.statusError.withValues(alpha: 0.12)
                                                        : AppColors.statusWarning.withValues(alpha: 0.12)),
                                                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                                              ),
                                              child: Text(
                                                statusText.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: isConfirmed
                                                      ? AppColors.statusSuccess
                                                      : (isCancelled
                                                          ? AppColors.statusError
                                                          : AppColors.statusWarning),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppDimensions.spacingSm + 2),

                                        // ── Corps de Carte avec Vignette Photo ──
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                                                  child: CachedNetworkImage(
                                                    imageUrl: _getBookingImageUrl(booking),
                                                    width: 84,
                                                    height: 84,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) => Container(
                                                      width: 84,
                                                      height: 84,
                                                      color: isDark ? AppColors.darkSurface : AppColors.fog,
                                                      child: const Center(
                                                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.champagneGold),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url, error) => Container(
                                                      width: 84,
                                                      height: 84,
                                                      color: isDark ? AppColors.darkSurface : AppColors.fog,
                                                      child: const Icon(Icons.hotel, color: AppColors.champagneGold, size: 28),
                                                    ),
                                                  ),
                                                ),
                                                if (booking.lines.length > 1)
                                                  Positioned(
                                                    bottom: 4,
                                                    right: 4,
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.champagneGold,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        "${booking.lines.length} hab.",
                                                        style: const TextStyle(
                                                          color: AppColors.imperialNightBlue,
                                                          fontSize: 9,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                            const SizedBox(height: 2),
                                                            Text(
                                                              booking.lines.length > 1
                                                                  ? "${booking.lines.length} hébergements"
                                                                  : booking.typeChambre,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
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
                                                          const SizedBox(height: 2),
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
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    l10n.periodOfStay.toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 9,
                                                      fontWeight: FontWeight.w600,
                                                      letterSpacing: 1.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    rangeStr,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
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
