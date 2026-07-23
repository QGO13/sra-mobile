import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/core/theme/app_theme.dart';
import 'package:sra_hotel/core/widgets/widgets.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_bloc.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_event.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_state.dart';
import 'package:sra_hotel/features/room_assignment/presentation/widgets/visio_planning_widget.dart';
import 'package:sra_hotel/features/room_assignment/presentation/widgets/assignment_kanban_widget.dart';
import 'package:sra_hotel/features/room_assignment/presentation/widgets/assignment_calendar_widget.dart';
import 'package:sra_hotel/features/room_assignment/presentation/widgets/assignment_list_widget.dart';
import 'package:sra_hotel/l10n/app_localizations.dart';

class RoomAssignmentDashboardPage extends StatefulWidget {
  const RoomAssignmentDashboardPage({super.key});

  @override
  State<RoomAssignmentDashboardPage> createState() => _RoomAssignmentDashboardPageState();
}

class _RoomAssignmentDashboardPageState extends State<RoomAssignmentDashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<RoomAssignmentBloc>().add(LoadRoomAssignmentDataEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.roomAssignmentTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.champagneGold,
          labelColor: AppColors.champagneGold,
          unselectedLabelColor: AppColors.textMuted,
          isScrollable: true,
          tabs: [
            Tab(text: l10n.visioPlanningTab),
            Tab(text: l10n.kanbanTab),
            Tab(text: l10n.calendarViewTab),
            Tab(text: l10n.bookings),
          ],
        ),
      ),
      body: BlocConsumer<RoomAssignmentBloc, RoomAssignmentState>(
        listener: (context, state) {
          if (state is RoomAssignmentActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.statusSuccess,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is RoomAssignmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.statusError,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is RoomAssignmentLoading || state is RoomAssignmentInitial) {
            return const LoadingWidget();
          } else if (state is RoomAssignmentError && state is! RoomAssignmentLoaded) {
            return ErrorStateView(
              message: state.message,
              onRetry: () => context.read<RoomAssignmentBloc>().add(LoadRoomAssignmentDataEvent()),
            );
          } else if (state is RoomAssignmentLoaded || state is RoomAssignmentActionSuccess) {
            // Get actual list from state (or retrieve it from the previous Loaded state if we are in ActionSuccess)
            final List<Room> rooms;
            final List<Booking> bookings;

            if (state is RoomAssignmentLoaded) {
              rooms = state.rooms;
              bookings = state.bookings;
            } else {
              // Retrieve from Bloc's getAssignmentDataUseCase cached values if possible,
              // or we wait for Loaded to rebuild. In this architecture, BLoC triggers LoadRoomAssignmentDataEvent
              // right after ActionSuccess, so this is transient. Let's show a loader or simple sizebox.
              return const LoadingWidget();
            }

            return TabBarView(
              controller: _tabController,
              children: [
                // 1. Visio Planning Timeline
                VisioPlanningWidget(
                  rooms: rooms,
                  bookings: bookings,
                  onBookingUpdated: (booking) {
                    context.read<RoomAssignmentBloc>().add(UpdateBookingAssignmentEvent(booking));
                  },
                ),

                // 2. Kanban Board
                AssignmentKanbanWidget(
                  rooms: rooms,
                  bookings: bookings,
                  onBookingUpdated: (booking) {
                    context.read<RoomAssignmentBloc>().add(UpdateBookingAssignmentEvent(booking));
                  },
                ),

                // 3. Calendar View
                AssignmentCalendarWidget(
                  rooms: rooms,
                  bookings: bookings,
                  onBookingUpdated: (booking) {
                    context.read<RoomAssignmentBloc>().add(UpdateBookingAssignmentEvent(booking));
                  },
                ),

                // 4. Booking List
                AssignmentListWidget(
                  rooms: rooms,
                  bookings: bookings,
                  onBookingUpdated: (booking) {
                    context.read<RoomAssignmentBloc>().add(UpdateBookingAssignmentEvent(booking));
                  },
                  onBookingCancelled: (booking) {
                    context.read<RoomAssignmentBloc>().add(CancelBookingAssignmentEvent(booking));
                  },
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
