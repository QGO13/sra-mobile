import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/room_search/domain/usecases/search_rooms_usecase.dart';
import 'package:sra_hotel/features/room_search/domain/usecases/verify_availability_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final SearchRoomsUseCase searchRoomsUseCase;
  final VerifyAvailabilityUseCase verifyAvailabilityUseCase;

  BookingBloc({
    required this.searchRoomsUseCase,
    required this.verifyAvailabilityUseCase,
  }) : super(BookingInitial()) {
    on<SearchRoomsRequested>(_onSearchRoomsRequested);
    on<VerifyRoomRequested>(_onVerifyRoomRequested);
  }

  Future<void> _onSearchRoomsRequested(
    SearchRoomsRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final rooms = await searchRoomsUseCase(
        SearchRoomsParams(
          checkIn: event.checkIn,
          checkOut: event.checkOut,
          categoryId: event.categoryId,
        ),
      );
      emit(RoomsLoadSuccess(rooms));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  Future<void> _onVerifyRoomRequested(
    VerifyRoomRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final isAvailable = await verifyAvailabilityUseCase(
        VerifyAvailabilityParams(
          roomId: event.roomId,
          checkIn: event.checkIn,
          checkOut: event.checkOut,
        ),
      );
      emit(RoomVerificationSuccess(
        roomId: event.roomId,
        isAvailable: isAvailable,
        message: isAvailable
            ? "Chambre disponible pour ces dates."
            : "Désolé, cette chambre a été réservée par un autre client à ces dates (Surbooking évité).",
      ));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}

