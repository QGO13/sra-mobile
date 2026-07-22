import 'package:sra_hotel/features/room_search/domain/repositories/booking_repository.dart';

class VerifyAvailabilityParams {
  final String roomId;
  final DateTime checkIn;
  final DateTime checkOut;

  const VerifyAvailabilityParams({
    required this.roomId,
    required this.checkIn,
    required this.checkOut,
  });
}

class VerifyAvailabilityUseCase {
  final BookingRepository repository;

  VerifyAvailabilityUseCase(this.repository);

  Future<bool> call(VerifyAvailabilityParams params) async {
    return await repository.verifyRoomAvailability(
      roomId: params.roomId,
      checkIn: params.checkIn,
      checkOut: params.checkOut,
    );
  }
}

