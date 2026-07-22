import 'package:sra_hotel/features/room_search/data/datasources/booking_local_data_source.dart';
import 'package:sra_hotel/features/room_search/data/datasources/booking_remote_data_source.dart';
import 'package:sra_hotel/features/room_search/domain/entities/room_entity.dart';
import 'package:sra_hotel/features/room_search/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final BookingLocalDataSource localDataSource;

  BookingRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<RoomEntity>> searchAvailableRooms({
    required DateTime checkIn,
    required DateTime checkOut,
    String? categoryId,
  }) async {
    final checkInStr = checkIn.toIso8601String().substring(0, 10);
    final checkOutStr = checkOut.toIso8601String().substring(0, 10);
    
    try {
      final rooms = await remoteDataSource.getAvailableRooms(
        checkIn: checkInStr,
        checkOut: checkOutStr,
        categoryId: categoryId,
      );
      await localDataSource.cacheAvailableRooms(rooms);
      return rooms;
    } catch (_) {
      // Offline mode fallback: query cached rooms from SQLite local db
      final cachedRooms = await localDataSource.getCachedAvailableRooms();
      if (categoryId != null) {
        return cachedRooms.where((r) => r.idTypeDeChambre == categoryId).toList();
      }
      return cachedRooms;
    }
  }

  @override
  Future<bool> verifyRoomAvailability({
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    final checkInStr = checkIn.toIso8601String().substring(0, 10);
    final checkOutStr = checkOut.toIso8601String().substring(0, 10);

    try {
      return await remoteDataSource.verifyRoomAvailability(
        roomId: roomId,
        checkIn: checkInStr,
        checkOut: checkOutStr,
      );
    } catch (_) {
      // Offline fallback: assume available if room is cached as ready
      final cachedRooms = await localDataSource.getCachedAvailableRooms();
      return cachedRooms.any((r) => r.id == roomId && r.statut == 'prêt');
    }
  }
}

