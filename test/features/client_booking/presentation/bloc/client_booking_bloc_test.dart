import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room.dart';
import 'package:sra_hotel/features/client_booking/domain/repositories/client_booking_repository.dart';
import 'package:sra_hotel/features/client_booking/domain/usecases/get_booking_room_types_usecase.dart';
import 'package:sra_hotel/features/client_booking/domain/usecases/check_type_availability_usecase.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_bloc.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_event.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_state.dart';

class MockClientBookingRepository implements ClientBookingRepository {
  final List<BookingRoomType> types;
  final List<BookingRoom> rooms;

  MockClientBookingRepository({required this.types, required this.rooms});

  @override
  Future<List<BookingRoomType>> getRoomTypes({DateTime? checkIn, DateTime? checkOut}) async => types;

  @override
  Future<List<BookingRoom>> getAvailableRooms({
    required DateTime checkIn,
    required DateTime checkOut,
  }) async => rooms;
}

void main() {
  group('ClientBookingBloc Tests', () {
    late ClientBookingBloc bloc;
    late MockClientBookingRepository repository;
    late GetBookingRoomTypesUseCase getRoomTypesUseCase;
    late CheckTypeAvailabilityUseCase checkTypeAvailabilityUseCase;

    final mockTypes = [
      const BookingRoomType(id: '1', nom: 'Standard', prixNuit: 50000, capacite: 2, description: 'Standard description', images: [], equipments: []),
    ];
    final mockRooms = [
      const BookingRoom(id: '1', numero: '101', idTypeDeChambre: '1', statut: 'libre', prixNuit: 50000),
    ];

    setUp(() {
      repository = MockClientBookingRepository(types: mockTypes, rooms: mockRooms);
      getRoomTypesUseCase = GetBookingRoomTypesUseCase(repository);
      checkTypeAvailabilityUseCase = CheckTypeAvailabilityUseCase(repository);
      bloc = ClientBookingBloc(
        getRoomTypesUseCase: getRoomTypesUseCase,
        checkTypeAvailabilityUseCase: checkTypeAvailabilityUseCase,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be ClientBookingInitial', () {
      expect(bloc.state, isA<ClientBookingInitial>());
    });

    test('should emit [ClientBookingInitial, RoomTypesLoadedState] when LoadRoomTypesEvent is added', () async {
      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ClientBookingInitial>(),
          isA<RoomTypesLoadedState>(),
        ]),
      );
      bloc.add(LoadRoomTypesEvent());
    });

    test('should emit [SelectingDatesState] when SelectRoomTypeEvent is added', () async {
      bloc.add(LoadRoomTypesEvent());
      await bloc.stream.firstWhere((state) => state is RoomTypesLoadedState);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SelectingDatesState>(),
        ]),
      );
      bloc.add(SelectRoomTypeEvent(mockTypes[0]));
    });

    test('should emit [CheckingAvailabilityState, AvailabilityResultState] when SelectDatesEvent is added', () async {
      bloc.add(LoadRoomTypesEvent());
      await bloc.stream.firstWhere((state) => state is RoomTypesLoadedState);
      
      bloc.add(SelectRoomTypeEvent(mockTypes[0]));
      await bloc.stream.firstWhere((state) => state is SelectingDatesState);

      final checkIn = DateTime(2026, 7, 8);
      final checkOut = DateTime(2026, 7, 10);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<CheckingAvailabilityState>(),
          isA<AvailabilityResultState>(),
        ]),
      );
      bloc.add(SelectDatesEvent(checkIn: checkIn, checkOut: checkOut));
    });
  });
}
