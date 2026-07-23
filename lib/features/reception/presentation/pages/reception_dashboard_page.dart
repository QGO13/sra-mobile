import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sra_hotel/core/error/error_handler.dart';
import 'package:sra_hotel/core/routes/app_routes.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_event.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/reception/presentation/bloc/reception_bloc.dart';
import 'package:sra_hotel/features/reception/presentation/bloc/reception_event.dart';
import 'package:sra_hotel/features/reception/presentation/bloc/reception_state.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';
import 'package:sra_hotel/features/settings/presentation/pages/settings_page.dart';

class ReceptionDashboardPage extends StatefulWidget {
  const ReceptionDashboardPage({super.key});

  @override
  State<ReceptionDashboardPage> createState() => _ReceptionDashboardPageState();
}

class _ReceptionDashboardPageState extends State<ReceptionDashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, String> _selectedRooms = {}; // maps arrival reference -> selected room number

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.receptionTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.champagneGold),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.champagneGold),
            onPressed: () {
              context.read<ReceptionBloc>().add(LoadReceptionDashboardEvent());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: AppColors.statusError),
            onPressed: () async {
              final l10n = AppLocalizations.of(context)!;
              final confirmed = await ConfirmDeleteDialog.show(
                context,
                title: l10n.confirmLogoutTitle,
                message: l10n.confirmLogoutMessage,
                confirmLabel: l10n.logout,
                cancelLabel: l10n.cancelLabel,
                isDestructive: false,
              );
              if (confirmed && context.mounted) {
                context.read<AuthBloc>().add(LogoutRequested());
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              }
            },
          ),
          const SizedBox(width: AppDimensions.spacingSm),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.champagneGold,
          labelColor: AppColors.champagneGold,
          unselectedLabelColor: AppColors.textMuted,
          tabs: [
            Tab(text: l10n.arrivalsTab),
            Tab(text: l10n.departuresTab),
            Tab(text: l10n.roomGridTab),
          ],
        ),
      ),
      body: BlocConsumer<ReceptionBloc, ReceptionState>(
        listener: (context, state) {
          if (state is ReceptionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ErrorMapper.getSubtitle(state.error, l10n)),
                backgroundColor: AppColors.statusError,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReceptionLoading || state is ReceptionInitial) {
            return const LoadingWidget();
          } else if (state is ReceptionFailure) {
            return ErrorStateView(
              message: state.error,
              onRetry: () => context.read<ReceptionBloc>().add(LoadReceptionDashboardEvent()),
            );
          } else if (state is ReceptionLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildArrivalsTab(state, isDark, theme),
                _buildDeparturesTab(state, isDark, theme),
                _buildRoomGridTab(state, isDark, theme),
              ],
            );
          }
          return const ErrorStateView(message: 'Erreur inconnue');
        },
      ),
    );
  }

  // ── STATS HEADER ──
  Widget _buildStatsHeader(ReceptionLoaded state, bool isDark, ThemeData theme) {
    final activeRoomsCount = state.rooms.where((r) => r.estActive == 1).length;
    final occupiedCount = state.rooms.where((r) => r.estActive == 1 && r.occupee == 1).length;
    final occupancy = activeRoomsCount > 0 ? (occupiedCount / activeRoomsCount * 100).round() : 0;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatChip(l10n.arrivalsTab.split(' ')[0].toUpperCase(), state.arrivals.length.toString(), AppColors.champagneGold, isDark),
            const SizedBox(width: AppDimensions.spacingSm),
            _buildStatChip(l10n.departuresTab.split(' ')[0].toUpperCase(), state.departures.length.toString(), AppColors.statusSuccess, isDark),
            const SizedBox(width: AppDimensions.spacingSm),
            _buildStatChip(l10n.occupationRate, '$occupancy%', AppColors.statusInfo, isDark),
            const SizedBox(width: AppDimensions.spacingSm),
            _buildStatChip(l10n.dirtyStatus.toUpperCase(), state.rooms.where((r) => r.statutMenage == 'SALE').length.toString(), AppColors.statusError, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd, vertical: AppDimensions.spacingSm + 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepBlue : AppColors.surfaceLight,
        border: Border.all(color: isDark ? AppColors.overlayDark : AppColors.softGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // ── ARRIVALS TAB ──
  Widget _buildArrivalsTab(ReceptionLoaded state, bool isDark, ThemeData theme) {
    // Rooms that are active, clean, and not occupied
    final availableRooms = state.rooms.where((r) => r.estActive == 1 && r.statutMenage == 'PROPRE' && r.occupee == 0).toList();
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      children: [
        _buildStatsHeader(state, isDark, theme),
        if (state.arrivals.isEmpty)
          EmptyStateView(
            icon: Icons.login_outlined,
            title: l10n.arrivalsTitle,
            subtitle: "Toutes les arrivées pour aujourd'hui ont été traitées.",
          )
        else
          ...state.arrivals.map((arrival) {
            final checkin = DateTime.tryParse(arrival.checkIn) ?? DateTime.now();
            final checkout = DateTime.tryParse(arrival.checkOut) ?? DateTime.now();
            final rangeStr = "${DateFormat.MMMd('fr').format(checkin)} → ${DateFormat.MMMd('fr').format(checkout)}";
            final isDone = arrival.statutCheckin == 'EFFECTUE';
            final assignedRoom = arrival.chambreAttribuee;

            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm + 4),
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepBlue : Colors.white,
                border: Border.all(color: isDark ? Colors.white10 : AppColors.softGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(arrival.reference, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.champagneGold)),
                      if (isDone)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm - 2, vertical: 2.0),
                          color: AppColors.statusSuccess.withValues(alpha: 0.1),
                          child: Text(l10n.effectueStatus, style: const TextStyle(fontSize: 9, color: AppColors.statusSuccess, fontWeight: FontWeight.bold)),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm - 2, vertical: 2.0),
                          color: AppColors.statusWarning.withValues(alpha: 0.1),
                          child: Text(l10n.pendingStatus, style: const TextStyle(fontSize: 9, color: AppColors.statusWarning, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Text(arrival.clientNom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('${arrival.typeChambre} - $rangeStr', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  Text('${arrival.adultes} ${l10n.adultsCount}', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  const Divider(height: 24),
                  if (isDone)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.assignedRoomLabel, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                        Text("Apart $assignedRoom", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.champagneGold)),
                      ],
                    )
                  else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.assignRoomLabel, style: const TextStyle(fontSize: 13)),
                        SizedBox(
                          width: 160,
                          height: 40,
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedRooms[arrival.reference],
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              border: OutlineInputBorder(),
                            ),
                            hint: Text(l10n.selectOption, style: const TextStyle(fontSize: 12)),
                            items: availableRooms.map((room) {
                              return DropdownMenuItem<String>(
                                value: room.numero,
                                child: Text("Apart ${room.numero}", style: const TextStyle(fontSize: 12)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                if (val != null) _selectedRooms[arrival.reference] = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingSm + 4),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedRooms[arrival.reference] == null
                            ? null
                            : () {
                                final roomNo = _selectedRooms[arrival.reference]!;
                                context.read<ReceptionBloc>().add(
                                      PerformCheckInEvent(arrival.reference, roomNo),
                                    );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.champagneGold,
                          foregroundColor: AppColors.textOnGold,
                          disabledBackgroundColor: AppColors.textMuted.withValues(alpha: 0.2),
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: Text(l10n.confirmCheckinButton),
                      ),
                    )
                  ],
                ],
              ),
            );
          }),
      ],
    );
  }

  // ── DEPARTURES TAB ──
  Widget _buildDeparturesTab(ReceptionLoaded state, bool isDark, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      children: [
        _buildStatsHeader(state, isDark, theme),
        if (state.departures.isEmpty)
          EmptyStateView(
            icon: Icons.logout_outlined,
            title: l10n.departuresTitle,
            subtitle: "Tous les départs pour aujourd'hui ont été réglés.",
          )
        else
          ...state.departures.map((depart) {
            final checkin = DateTime.tryParse(depart.checkIn) ?? DateTime.now();
            final checkout = DateTime.tryParse(depart.checkOut) ?? DateTime.now();
            final rangeStr = "${DateFormat.MMMd('fr').format(checkin)} → ${DateFormat.MMMd('fr').format(checkout)}";
            final isDone = depart.statutCheckout == 'EFFECTUE';

            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spacingSm + 4),
              padding: const EdgeInsets.all(AppDimensions.spacingMd),
              decoration: BoxDecoration(
                color: isDark ? AppColors.deepBlue : AppColors.surfaceLight,
                border: Border.all(color: isDark ? AppColors.overlayDark : AppColors.softGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(depart.reference, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.champagneGold)),
                      if (isDone)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm - 2, vertical: 2.0),
                          color: AppColors.textMuted.withValues(alpha: 0.15),
                          child: Text(l10n.libre, style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.bold)),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm - 2, vertical: 2.0),
                          color: AppColors.statusSuccess.withValues(alpha: 0.1),
                          child: Text(l10n.pendingStatus, style: const TextStyle(fontSize: 9, color: AppColors.statusSuccess, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(depart.clientNom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('${l10n.room} : Apart ${depart.chambreAttribuee} - $rangeStr', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.invoiceBalanceLabel, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          Text(
                            _formatCurrency(depart.prixTotal ?? 0.0),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.champagneGold),
                          )
                        ],
                      ),
                      if (!isDone)
                        ElevatedButton(
                          onPressed: () {
                            context.read<ReceptionBloc>().add(PerformCheckOutEvent(depart.reference));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.imperialNightBlue,
                            foregroundColor: AppColors.textOnGold,
                            shape: const RoundedRectangleBorder(),
                          ),
                          child: Text(l10n.settleCheckoutButton),
                        )
                    ],
                  )
                ],
              ),
            );
          }),
      ],
    );
  }

  // ── ROOM OCCUPANCY GRID TAB ──
  Widget _buildRoomGridTab(ReceptionLoaded state, bool isDark, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.interactivePlanTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(l10n.interactivePlanSubtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5)),
          const SizedBox(height: AppDimensions.spacingMd),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.rooms.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final room = state.rooms[index];
              final isOccupied = room.occupee == 1;
              final status = room.statutMenage;

              Color bg = AppColors.statusSuccess.withValues(alpha: 0.1);
              Color tc = AppColors.statusSuccess;
              String desc = l10n.libre;

              if (room.estActive == 0) {
                bg = AppColors.textMuted.withValues(alpha: 0.08);
                tc = AppColors.textMuted;
                desc = l10n.maintenanceStatus;
              } else if (isOccupied) {
                bg = AppColors.champagneGold.withValues(alpha: 0.1);
                tc = AppColors.champagneGold;
                desc = room.clientActuel ?? l10n.occupee;
              } else if (status == 'SALE') {
                bg = AppColors.statusError.withValues(alpha: 0.08);
                tc = AppColors.statusError;
                desc = l10n.dirtyStatus;
              } else if (status == 'EN_COURS') {
                bg = AppColors.statusWarning.withValues(alpha: 0.1);
                tc = AppColors.statusWarning;
                desc = l10n.cleaningStatus;
              }

              return InkWell(
                onTap: () => _showRoomDetailsBottomSheet(context, room, tc, desc, isDark),
                child: Container(
                  decoration: BoxDecoration(
                    color: bg,
                    border: Border.all(color: tc.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        room.numero,
                        style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20, color: tc, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          desc,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, color: tc, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimensions.spacingXl),
        ],
      ),
    );
  }

  void _showRoomDetailsBottomSheet(BuildContext context, Room room, Color color, String desc, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXl)),
      ),
      builder: (ctx) {
        String localizedMenage = room.statutMenage;
        if (room.statutMenage == 'PROPRE') localizedMenage = l10n.cleanStatus;
        if (room.statutMenage == 'SALE') localizedMenage = l10n.dirtyStatus;
        if (room.statutMenage == 'EN_COURS') localizedMenage = l10n.cleaningStatus;

        return Container(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${l10n.room} ${room.numero}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingSm + 2, vertical: AppDimensions.spacingXs),
                    color: color.withValues(alpha: 0.1),
                    child: Text(
                      room.estActive == 0 ? l10n.horsService : localizedMenage.toUpperCase(),
                      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text("${l10n.typeLabel} : ${room.type}", style: const TextStyle(fontSize: 14)),
              Text('${l10n.floorLabel} : ${room.etage}', style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
              const Divider(height: 30),
              if (room.occupee == 1) ...[
                Text(l10n.activeOccupantLabel, style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                const SizedBox(height: AppDimensions.spacingSm - 2),
                Row(
                  children: [
                    const Icon(Icons.person_outline, color: AppColors.champagneGold),
                    const SizedBox(width: 8),
                    Text(room.clientActuel ?? 'Client', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.statusSuccess),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Text(room.estActive == 0 ? l10n.roomMaintenanceMessage : l10n.roomAvailableMessage, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
              const SizedBox(height: AppDimensions.spacingLg),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(l10n.closeButton),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
