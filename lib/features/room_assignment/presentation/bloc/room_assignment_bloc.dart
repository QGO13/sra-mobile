import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_assignment/domain/usecases/get_assignment_data_usecase.dart';
import 'package:sra_hotel/features/room_assignment/domain/usecases/update_assignment_usecase.dart';
import 'room_assignment_event.dart';
import 'room_assignment_state.dart';

class RoomAssignmentBloc extends Bloc<RoomAssignmentEvent, RoomAssignmentState> {
  final GetAssignmentDataUseCase getAssignmentDataUseCase;
  final UpdateAssignmentUseCase updateAssignmentUseCase;

  RoomAssignmentBloc({
    required this.getAssignmentDataUseCase,
    required this.updateAssignmentUseCase,
  }) : super(RoomAssignmentInitial()) {
    on<LoadRoomAssignmentDataEvent>(_onLoadData);
    on<UpdateBookingAssignmentEvent>(_onUpdateAssignment);
    on<CancelBookingAssignmentEvent>(_onCancelAssignment);
  }

  Future<void> _onLoadData(
    LoadRoomAssignmentDataEvent event,
    Emitter<RoomAssignmentState> emit,
  ) async {
    emit(RoomAssignmentLoading());
    try {
      final data = await getAssignmentDataUseCase();
      emit(RoomAssignmentLoaded(rooms: data.rooms, bookings: data.bookings));
    } catch (e) {
      emit(RoomAssignmentError(e.toString()));
    }
  }

  Future<void> _onUpdateAssignment(
    UpdateBookingAssignmentEvent event,
    Emitter<RoomAssignmentState> emit,
  ) async {
    // Keep reference to previous loaded data so we don't flash loading screen too much,
    // or just let it reload. Let's emit Loading or do it in-place.
    final currentState = state;
    List<Room> currentRooms = [];
    List<Booking> currentBookings = [];
    if (currentState is RoomAssignmentLoaded) {
      currentRooms = currentState.rooms;
      currentBookings = currentState.bookings;
    }

    try {
      await updateAssignmentUseCase(event.booking);
      emit(RoomAssignmentActionSuccess("Modifications enregistrées"));
      // Reload fresh data
      final data = await getAssignmentDataUseCase();
      emit(RoomAssignmentLoaded(rooms: data.rooms, bookings: data.bookings));
    } catch (e) {
      emit(RoomAssignmentError(e.toString()));
      if (currentRooms.isNotEmpty) {
        emit(RoomAssignmentLoaded(rooms: currentRooms, bookings: currentBookings));
      }
    }
  }

  Future<void> _onCancelAssignment(
    CancelBookingAssignmentEvent event,
    Emitter<RoomAssignmentState> emit,
  ) async {
    final currentState = state;
    List<Room> currentRooms = [];
    List<Booking> currentBookings = [];
    if (currentState is RoomAssignmentLoaded) {
      currentRooms = currentState.rooms;
      currentBookings = currentState.bookings;
    }

    try {
      final cancelledBooking = Booking(
        id: event.booking.id,
        reference: event.booking.reference,
        clientNom: event.booking.clientNom,
        typeChambre: event.booking.typeChambre,
        checkIn: event.booking.checkIn,
        checkOut: event.booking.checkOut,
        adultes: event.booking.adultes,
        enfants: event.booking.enfants,
        statutBooking: 'ANNULEE',
        prixTotal: event.booking.prixTotal,
        lines: event.booking.lines,
      );
      await updateAssignmentUseCase(cancelledBooking);
      emit(RoomAssignmentActionSuccess("Réservation annulée"));
      // Reload fresh data
      final data = await getAssignmentDataUseCase();
      emit(RoomAssignmentLoaded(rooms: data.rooms, bookings: data.bookings));
    } catch (e) {
      emit(RoomAssignmentError(e.toString()));
      if (currentRooms.isNotEmpty) {
        emit(RoomAssignmentLoaded(rooms: currentRooms, bookings: currentBookings));
      }
    }
  }
}
