import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_assignment/domain/repositories/room_assignment_repository.dart';
import 'package:sra_hotel/features/room_assignment/domain/usecases/get_assignment_data_usecase.dart';
import 'package:sra_hotel/features/room_assignment/domain/usecases/update_assignment_usecase.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_bloc.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_event.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_state.dart';

class MockRoomAssignmentRepository implements RoomAssignmentRepository {
  final List<Room> rooms;
  final List<Booking> bookings;

  MockRoomAssignmentRepository({required this.rooms, required this.bookings});

  @override
  Future<List<Booking>> getBookings() async => bookings;

  @override
  Future<List<Room>> getRooms() async => rooms;

  @override
  Future<Booking> updateBooking(Booking booking) async {
    final index = bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      bookings[index] = booking;
    }
    return booking;
  }
}

void main() {
  group('RoomAssignmentBloc Tests', () {
    late RoomAssignmentBloc bloc;
    late MockRoomAssignmentRepository repository;
    late GetAssignmentDataUseCase getAssignmentDataUseCase;
    late UpdateAssignmentUseCase updateAssignmentUseCase;

    final mockRooms = [
      Room(id: '1', numero: '101', idTypeDeChambre: '1', type: 'Chambre Standard', etage: 1, statutMenage: 'PROPRE', estActive: 1, occupee: 0),
    ];
    final mockBookings = [
      Booking(
        id: '1',
        reference: 'SRA-REF1',
        clientNom: 'Ibrahima',
        typeChambre: 'Chambre Standard',
        checkIn: '2026-07-10',
        checkOut: '2026-07-12',
        adultes: 1,
        enfants: 0,
        statutBooking: 'CONFIRME',
        prixTotal: 50000.0,
        lines: [],
      ),
    ];

    setUp(() {
      repository = MockRoomAssignmentRepository(rooms: mockRooms, bookings: List.from(mockBookings));
      getAssignmentDataUseCase = GetAssignmentDataUseCase(repository);
      updateAssignmentUseCase = UpdateAssignmentUseCase(repository);
      bloc = RoomAssignmentBloc(
        getAssignmentDataUseCase: getAssignmentDataUseCase,
        updateAssignmentUseCase: updateAssignmentUseCase,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be RoomAssignmentInitial', () {
      expect(bloc.state, isA<RoomAssignmentInitial>());
    });

    test('should emit [RoomAssignmentLoading, RoomAssignmentLoaded] when LoadRoomAssignmentDataEvent is added', () async {
      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<RoomAssignmentLoading>(),
          isA<RoomAssignmentLoaded>(),
        ]),
      );
      bloc.add(LoadRoomAssignmentDataEvent());
    });

    test('should emit [RoomAssignmentActionSuccess, RoomAssignmentLoaded] when UpdateBookingAssignmentEvent is added', () async {
      bloc.add(LoadRoomAssignmentDataEvent());
      await bloc.stream.firstWhere((state) => state is RoomAssignmentLoaded);

      final updatedBooking = Booking(
        id: '1',
        reference: 'SRA-REF1',
        clientNom: 'Ibrahima Modified',
        typeChambre: 'Chambre Standard',
        checkIn: '2026-07-10',
        checkOut: '2026-07-12',
        adultes: 1,
        enfants: 0,
        statutBooking: 'CONFIRME',
        prixTotal: 50000.0,
        lines: [],
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<RoomAssignmentActionSuccess>(),
          isA<RoomAssignmentLoaded>(),
        ]),
      );

      bloc.add(UpdateBookingAssignmentEvent(updatedBooking));
    });

    test('should emit [RoomAssignmentActionSuccess, RoomAssignmentLoaded] when CancelBookingAssignmentEvent is added', () async {
      bloc.add(LoadRoomAssignmentDataEvent());
      await bloc.stream.firstWhere((state) => state is RoomAssignmentLoaded);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<RoomAssignmentActionSuccess>(),
          isA<RoomAssignmentLoaded>(),
        ]),
      );

      bloc.add(CancelBookingAssignmentEvent(mockBookings[0]));
    });
  });
}
