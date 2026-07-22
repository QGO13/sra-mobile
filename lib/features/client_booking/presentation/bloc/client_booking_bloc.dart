import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room.dart';
import 'package:sra_hotel/features/client_booking/domain/usecases/get_booking_room_types_usecase.dart';
import 'package:sra_hotel/features/client_booking/domain/usecases/check_type_availability_usecase.dart';
import 'client_booking_event.dart';
import 'client_booking_state.dart';

class ClientBookingBloc extends Bloc<ClientBookingEvent, ClientBookingState> {
  final GetBookingRoomTypesUseCase getRoomTypesUseCase;
  final CheckTypeAvailabilityUseCase checkTypeAvailabilityUseCase;

  List<BookingRoomType> _loadedRoomTypes = [];
  BookingRoomType? _selectedType;
  DateTime? _checkIn;
  DateTime? _checkOut;
  List<BookingRoom> _availableRoomsForDates = [];

  ClientBookingBloc({
    required this.getRoomTypesUseCase,
    required this.checkTypeAvailabilityUseCase,
  }) : super(ClientBookingInitial()) {
    on<LoadRoomTypesEvent>(_onLoadRoomTypes);
    on<SelectRoomTypeEvent>(_onSelectRoomType);
    on<SelectDatesEvent>(_onSelectDates);
    on<ConfirmQuantityEvent>(_onConfirmQuantity);
    on<ResetBookingFlowEvent>(_onResetBookingFlow);
  }

  Future<void> _onLoadRoomTypes(
    LoadRoomTypesEvent event,
    Emitter<ClientBookingState> emit,
  ) async {
    emit(ClientBookingInitial());
    try {
      _loadedRoomTypes = await getRoomTypesUseCase();
      emit(RoomTypesLoadedState(_loadedRoomTypes));
    } catch (e) {
      emit(BookingErrorState(e.toString()));
    }
  }

  void _onSelectRoomType(
    SelectRoomTypeEvent event,
    Emitter<ClientBookingState> emit,
  ) {
    _selectedType = event.roomType;
    emit(SelectingDatesState(_selectedType!));
  }

  Future<void> _onSelectDates(
    SelectDatesEvent event,
    Emitter<ClientBookingState> emit,
  ) async {
    if (_selectedType == null) {
      emit(const BookingErrorState("Aucun type de chambre sélectionné."));
      return;
    }

    _checkIn = event.checkIn;
    _checkOut = event.checkOut;

    emit(CheckingAvailabilityState());
    try {
      // Get all available rooms for the dates
      final allAvailableRooms = await checkTypeAvailabilityUseCase(
        CheckTypeAvailabilityParams(
          checkIn: _checkIn!,
          checkOut: _checkOut!,
        ),
      );

      // Filter by selected type
      final matchingRooms = allAvailableRooms
          .where((room) => room.idTypeDeChambre == _selectedType!.id)
          .toList();

      if (matchingRooms.isNotEmpty) {
        _availableRoomsForDates = matchingRooms;
        emit(AvailabilityResultState(
          selectedType: _selectedType!,
          checkIn: _checkIn!,
          checkOut: _checkOut!,
          isAvailable: true,
          availableRooms: matchingRooms,
          maxQuantity: matchingRooms.length,
          alternatives: const [],
        ));
      } else {
        _availableRoomsForDates = [];
        // Find alternative room types that have available rooms
        final availableTypeIds = allAvailableRooms
            .map((room) => room.idTypeDeChambre)
            .toSet();

        final alternatives = _loadedRoomTypes
            .where((type) => availableTypeIds.contains(type.id))
            .toList();

        emit(AvailabilityResultState(
          selectedType: _selectedType!,
          checkIn: _checkIn!,
          checkOut: _checkOut!,
          isAvailable: false,
          availableRooms: const [],
          maxQuantity: 0,
          alternatives: alternatives,
        ));
      }
    } catch (e) {
      emit(BookingErrorState(e.toString()));
    }
  }

  void _onConfirmQuantity(
    ConfirmQuantityEvent event,
    Emitter<ClientBookingState> emit,
  ) {
    if (_availableRoomsForDates.isEmpty || event.quantity > _availableRoomsForDates.length) {
      emit(const BookingErrorState("Quantité indisponible."));
      return;
    }

    // Take the first Q available rooms
    final roomsToAdd = _availableRoomsForDates.take(event.quantity).toList();

    emit(BookingCompletedState(
      roomsToAdd: roomsToAdd,
      checkIn: _checkIn!,
      checkOut: _checkOut!,
      continueBooking: event.continueBooking,
    ));
  }

  void _onResetBookingFlow(
    ResetBookingFlowEvent event,
    Emitter<ClientBookingState> emit,
  ) {
    _selectedType = null;
    _checkIn = null;
    _checkOut = null;
    _availableRoomsForDates = [];
    emit(RoomTypesLoadedState(_loadedRoomTypes));
  }
}
