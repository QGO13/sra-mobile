import 'package:sra_hotel/features/client_booking/domain/entities/booking_room_type.dart';
import 'package:sra_hotel/features/client_booking/domain/entities/booking_room.dart';
import 'package:sra_hotel/features/client_booking/domain/repositories/client_booking_repository.dart';
import 'package:sra_hotel/features/client_booking/data/datasources/client_booking_remote_datasource.dart';

class ClientBookingRepositoryImpl implements ClientBookingRepository {
  final ClientBookingRemoteDataSource remoteDataSource;

  ClientBookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BookingRoomType>> getRoomTypes() async {
    return await remoteDataSource.getRoomTypes();
  }

  @override
  Future<List<BookingRoom>> getAvailableRooms({
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    final checkInStr = checkIn.toIso8601String().substring(0, 10);
    final checkOutStr = checkOut.toIso8601String().substring(0, 10);
    return await remoteDataSource.getAvailableRooms(
      checkIn: checkInStr,
      checkOut: checkOutStr,
    );
  }
}
