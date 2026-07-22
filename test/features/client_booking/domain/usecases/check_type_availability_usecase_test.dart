import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room.dart';
import 'package:sra_hotel/features/client_booking/domain/repositories/client_booking_repository.dart';
import 'package:sra_hotel/features/client_booking/domain/usecases/check_type_availability_usecase.dart';

class MockClientBookingRepository implements ClientBookingRepository {
  final List<BookingRoom> mockRooms;
  MockClientBookingRepository({required this.mockRooms});

  @override
  Future<List<BookingRoomType>> getRoomTypes() async => [];

  @override
  Future<List<BookingRoom>> getAvailableRooms({
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    return mockRooms;
  }
}

void main() {
  group('CheckTypeAvailabilityUseCase Tests', () {
    test('should return available rooms for a type and dates', () async {
      final mockRooms = [
        const BookingRoom(id: '1', numero: '101', idTypeDeChambre: '1', statut: 'libre', prixNuit: 50000),
      ];
      final repository = MockClientBookingRepository(mockRooms: mockRooms);
      final useCase = CheckTypeAvailabilityUseCase(repository);

      final checkIn = DateTime(2026, 7, 8);
      final checkOut = DateTime(2026, 7, 10);
      final result = await useCase(CheckTypeAvailabilityParams(checkIn: checkIn, checkOut: checkOut));

      expect(result.length, 1);
      expect(result[0].numero, '101');
    });
  });
}
