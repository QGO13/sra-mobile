import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_assignment/presentation/widgets/edit_assignment_dialog.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class AssignmentListWidget extends StatefulWidget {
  final List<Room> rooms;
  final List<Booking> bookings;
  final Function(Booking) onBookingUpdated;
  final Function(Booking) onBookingCancelled;

  const AssignmentListWidget({
    super.key,
    required this.rooms,
    required this.bookings,
    required this.onBookingUpdated,
    required this.onBookingCancelled,
  });

  @override
  State<AssignmentListWidget> createState() => _AssignmentListWidgetState();
}

class _AssignmentListWidgetState extends State<AssignmentListWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedFilter = "all";

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
    final s = booking.statutBooking.toUpperCase();
    switch (filter) {
      case "confirmed":
        return s == 'CONFIRME' || s == 'CONFIRMEE';
      case "pending":
        return s == 'EN_ATTENTE';
      case "in_house":
        return s == 'EFFECTUE';
      case "completed":
        return s == 'TERMINEE';
      case "cancelled":
        return s == 'ANNULE' || s == 'ANNULEE';
      case "all":
      default:
        return true;
    }
  }

  bool _matchesSearch(Booking booking, String query) {
    if (query.isEmpty) return true;
    final lowerQuery = query.toLowerCase();
    final roomNo = booking.lines.isNotEmpty ? booking.lines[0].roomNumber ?? '' : '';
    return booking.reference.toLowerCase().contains(lowerQuery) ||
        booking.clientNom.toLowerCase().contains(lowerQuery) ||
        booking.typeChambre.toLowerCase().contains(lowerQuery) ||
        roomNo.toLowerCase().contains(lowerQuery);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final filtered = widget.bookings.where((b) {
      return _matchesFilter(b, _selectedFilter) && _matchesSearch(b, _searchQuery);
    }).toList();

    final filterChips = [
      {'id': 'all', 'label': l10n.filterAll},
      {'id': 'pending', 'label': l10n.pendingStatus},
      {'id': 'confirmed', 'label': l10n.filterConfirmed},
      {'id': 'in_house', 'label': "En séjour"},
      {'id': 'completed', 'label': "Terminé"},
      {'id': 'cancelled', 'label': l10n.filterCancelled},
    ];

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: l10n.searchBookingsPlaceholder,
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: isDark ? Colors.white10 : AppColors.softGrey),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.champagneGold, width: 2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = "";
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),

        SraFilterBar(
          items: filterChips
              .map((chip) => SraFilterItem(id: chip['id']!, label: chip['label']!))
              .toList(),
          selectedId: _selectedFilter,
          onSelected: (id) {
            setState(() {
              _selectedFilter = id;
            });
          },
        ),
        const SizedBox(height: AppDimensions.spacingMd),

        // Bookings list
        Expanded(
          child: filtered.isEmpty
              ? EmptyStateView(
                  icon: Icons.calendar_today_outlined,
                  title: "Aucune réservation trouvée",
                  subtitle: _searchQuery.isNotEmpty || _selectedFilter != "all"
                      ? "Ajustez vos filtres ou termes de recherche."
                      : "Il n'y a pas encore de réservations.",
                  actionLabel: _searchQuery.isNotEmpty || _selectedFilter != "all"
                      ? "Réinitialiser"
                      : null,
                  onAction: _searchQuery.isNotEmpty || _selectedFilter != "all"
                      ? () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = "";
                            _selectedFilter = "all";
                          });
                        }
                      : null,
                )
              : ResponsiveListGridView(
                  itemCount: filtered.length,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                  maxCrossAxisExtent: 450,
                  mainAxisExtent: 230,
                  itemBuilder: (context, index) {
                    final booking = filtered[index];
                    final roomNo = booking.lines.isNotEmpty ? booking.lines[0].roomNumber : null;
                    final checkIn = DateTime.tryParse(booking.checkIn) ?? DateTime.now();
                    final checkOut = DateTime.tryParse(booking.checkOut) ?? DateTime.now();
                    final dateRange = "${DateFormat.yMMMd('fr').format(checkIn)} → ${DateFormat.yMMMd('fr').format(checkOut)}";

                    final isCancelled = booking.statutBooking == 'ANNULE' || booking.statutBooking == 'ANNULEE';
                    final isConfirmed = booking.statutBooking == 'CONFIRME' || booking.statutBooking == 'CONFIRMEE';
                    final isStaying = booking.statutBooking == 'EFFECTUE';

                    return Container(
                      margin: MediaQuery.of(context).size.width < AppDimensions.breakpointMd
                          ? const EdgeInsets.only(bottom: AppDimensions.spacingSm + 4)
                          : EdgeInsets.zero,
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
                          // Reference & Status Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                booking.reference,
                                style: AppTextStyles.monospace.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.champagneGold,
                                  fontSize: 12.5,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                color: isConfirmed
                                    ? AppColors.champagneGold.withValues(alpha: 0.15)
                                    : (isCancelled
                                        ? AppColors.statusError.withValues(alpha: 0.15)
                                        : (isStaying
                                            ? AppColors.statusInfo.withValues(alpha: 0.15)
                                            : Colors.orange.withValues(alpha: 0.15))),
                                child: Text(
                                  booking.statutBooking.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isConfirmed
                                        ? AppColors.champagneGold
                                        : (isCancelled
                                            ? AppColors.statusError
                                            : (isStaying ? AppColors.statusInfo : Colors.orange.shade700)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.spacingSm),

                          // Client details
                          Text(
                            booking.clientNom,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),

                          // Dates & Details
                          Text(
                            "${booking.typeChambre} • $dateRange",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                          ),
                          Text(
                            "${booking.adultes} adultes${booking.enfants != null && booking.enfants! > 0 ? ' + ${booking.enfants} enfants' : ''}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                          ),

                          if (roomNo != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.meeting_room, size: 14, color: AppColors.champagneGold),
                                const SizedBox(width: 4),
                                Text(
                                  "Chambre assignée : Apart $roomNo",
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.champagneGold),
                                ),
                              ],
                            ),
                          ],

                          const Divider(height: 20),

                          // Price & Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatCurrency(booking.prixTotal),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.champagneGold),
                              ),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => EditAssignmentDialog(
                                          booking: booking,
                                          rooms: widget.rooms,
                                          bookings: widget.bookings,
                                          onSave: widget.onBookingUpdated,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit, size: 14, color: AppColors.champagneGold),
                                    label: const Text("Modifier", style: TextStyle(color: AppColors.champagneGold, fontSize: 12)),
                                  ),
                                  if (!isCancelled && booking.statutBooking != 'TERMINEE') ...[
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Annuler la réservation"),
                                            content: Text("Êtes-vous sûr de vouloir annuler la réservation ${booking.reference} ?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text("Fermer"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  widget.onBookingCancelled(booking);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Annuler la réservation", style: TextStyle(color: AppColors.statusError)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.cancel_outlined, size: 14, color: AppColors.statusError),
                                      label: const Text("Annuler", style: TextStyle(color: AppColors.statusError, fontSize: 12)),
                                    ),
                                  ],
                                ],
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
}
