import 'package:sra_hotel/features/reservation_management/data/models/booking_model.dart';
import 'package:sra_hotel/features/reservation_management/domain/entities/booking.dart';
import 'package:sra_hotel/features/room_management/domain/entities/room.dart';
import 'package:sra_hotel/features/room_assignment/data/datasources/room_assignment_remote_datasource.dart';
import 'package:sra_hotel/features/room_assignment/domain/repositories/room_assignment_repository.dart';

class RoomAssignmentRepositoryImpl implements RoomAssignmentRepository {
  final RoomAssignmentRemoteDataSource remoteDataSource;

  RoomAssignmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Booking>> getBookings() async {
    return await remoteDataSource.getBookings();
  }

  @override
  Future<List<Room>> getRooms() async {
    return await remoteDataSource.getRooms();
  }

  @override
  Future<Booking> updateBooking(Booking booking) async {
    final model = BookingModel(
      id: booking.id,
      reference: booking.reference,
      clientNom: booking.clientNom,
      typeChambre: booking.typeChambre,
      checkIn: booking.checkIn,
      checkOut: booking.checkOut,
      adultes: booking.adultes,
      enfants: booking.enfants,
      statutBooking: booking.statutBooking,
      prixTotal: booking.prixTotal,
      lines: booking.lines,
    );
    return await remoteDataSource.updateBooking(model);
  }
}
