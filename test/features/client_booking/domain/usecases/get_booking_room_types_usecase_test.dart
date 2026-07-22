import 'package:flutter_test/flutter_test.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room.dart';
import 'package:sra_hotel/features/client_booking/domain/repositories/client_booking_repository.dart';
import 'package:sra_hotel/features/client_booking/domain/usecases/get_booking_room_types_usecase.dart';

class MockClientBookingRepository implements ClientBookingRepository {
  @override
  Future<List<BookingRoomType>> getRoomTypes() async {
    return [
      const BookingRoomType(
        id: '1',
        nom: 'Standard',
        description: 'Standard room',
        prixNuit: 50000,
        capacite: 2,
        images: [],
        equipments: [],
      ),
    ];
  }

  @override
  Future<List<BookingRoom>> getAvailableRooms({
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    return [];
  }
}

void main() {
  group('GetBookingRoomTypesUseCase Tests', () {
    late GetBookingRoomTypesUseCase useCase;
    late MockClientBookingRepository repository;

    setUp(() {
      repository = MockClientBookingRepository();
      useCase = GetBookingRoomTypesUseCase(repository);
    });

    test('should fetch booking room types from repository', () async {
      final result = await useCase();
      expect(result.length, 1);
      expect(result[0].nom, 'Standard');
      expect(result[0].prixNuit, 50000);
    });
  });
}
