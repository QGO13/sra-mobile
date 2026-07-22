import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_assignment/domain/repositories/room_assignment_repository.dart';

class UpdateAssignmentUseCase {
  final RoomAssignmentRepository repository;

  UpdateAssignmentUseCase(this.repository);

  Future<Booking> call(Booking booking) async {
    return await repository.updateBooking(booking);
  }
}
